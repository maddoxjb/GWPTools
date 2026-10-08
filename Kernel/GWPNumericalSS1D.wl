(* ::Package:: *)

(* ::Title:: *)
(*GWPNumericalSS1D Package*)


(* ::Section::Closed:: *)
(*GWPDeveloper Usage Registration*)


(* ::Subsection::Closed:: *)
(*BeginPackage*)


(* --- Hoist Usage Statements into the Developer Context --- *)
Needs["GWPTools`GWPDeveloper`"];
BeginPackage["GWPTools`GWPDeveloper`"]

If[TrueQ[Global`$GWPDebug], Print["[GWPNumericalSS1D] BeginPackage GWPDeveloper"]];

Off[General::shdw];



(* ::Subsection::Closed:: *)
(*Usage Statements*)


GWPSS1DNUMERICAL::usage = "GWPSS1DNUMERICAL[V0, V1, V2, tMin, tMax, opts][t][param] evaluates the numerically integrated dual-wavepacket SS1D parameters at time t.";
GWPSS1DNDSolveCache::usage = "GWPSS1DNDSolveCache is the internal memoization engine for the SS1D numerical differential equations.";



(* ::Subsection::Closed:: *)
(*End Package*)


Off[General::shdw];

If[TrueQ[Global`$GWPDebug], Print["[GWPNumericalSS1D] EndPackage GWPDeveloper"]];

Quiet[EndPackage[], General::shdw]

(* Scrub the Developer context from the global path immediately *)
$ContextPath = DeleteCases[$ContextPath, "GWPTools`GWPDeveloper`"];



(* ::Section::Closed:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPNumericalSS1D`                                  *)
(* DESCRIPTION : Numerical NDSolve integration extensions for SS1D GWPs.     *)
(* ========================================================================= *)

BeginPackage["GWPTools`GWPNumericalSS1D`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPNumericalSS1D] BeginPackage"]];
Begin["`Private`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPNumericalSS1D] Begin Private"]];

(* Load dependencies strictly internally *)
Needs["GWPTools`GWPDeveloper`"];
Needs["GWPTools`GWPRegistry`"];
Needs["GWPTools`GWPEngine1D`"];
Needs["GWPTools`GWPEngineSS1D`"];


(* ::Section::Closed:: *)
(*The Numerical Engine*)


GWPSS1DNUMERICAL::outofbounds = "The requested time `1` is outside the simulated time domain [`2`, `3`].";

(* The internal cache for NDSolve. Integrates both wavepackets simultaneously in a 12-equation system. *)
GWPSS1DNDSolveCache[v0_, v1_, v2_, initList1_, initList2_, tMin_, tMax_, opts___] := 
  GWPSS1DNDSolveCache[v0, v1, v2, initList1, initList2, tMin, tMax, opts] = Module[
  {ra10, ia10, rx10, rp10, rg10, ig10, hbar, mass,
   ra20, ia20, rx20, rp20, rg20, ig20,
   x1, p1, ra1, ia1, rg1, ig1,
   x2, p2, ra2, ia2, rg2, ig2, t, eqs, inits},
  
  (* Unpack the exact numerical initial conditions from the 1D parameter sub-lists *)
  {ra10, ia10, rx10, rp10, rg10, ig10, hbar, mass} = initList1;
  {ra20, ia20, rx20, rp20, rg20, ig20, hbar, mass} = initList2;
  
  eqs = {
    (* Wavepacket 1 ODEs *)
    ra1'[t] == (4 * hbar / mass) * ra1[t] * ia1[t],
    ia1'[t] == -(2 * hbar / mass) * (ra1[t]^2 - ia1[t]^2) + (v2[t] / hbar),
    x1'[t]  == p1[t] / mass,
    p1'[t]  == -v1[t] - 2 * v2[t] * x1[t],
    rg1'[t] == (p1[t]^2 / (2 * mass)) - (v0[t] + v1[t]*x1[t] + v2[t]*x1[t]^2) - (hbar^2 / mass) * ra1[t],
    ig1'[t] == -(hbar^2 / mass) * ia1[t],

    (* Wavepacket 2 ODEs *)
    ra2'[t] == (4 * hbar / mass) * ra2[t] * ia2[t],
    ia2'[t] == -(2 * hbar / mass) * (ra2[t]^2 - ia2[t]^2) + (v2[t] / hbar),
    x2'[t]  == p2[t] / mass,
    p2'[t]  == -v1[t] - 2 * v2[t] * x2[t],
    rg2'[t] == (p2[t]^2 / (2 * mass)) - (v0[t] + v1[t]*x2[t] + v2[t]*x2[t]^2) - (hbar^2 / mass) * ra2[t],
    ig2'[t] == -(hbar^2 / mass) * ia2[t]
  };

  inits = {
    ra1[tMin] == ra10, ia1[tMin] == ia10, x1[tMin] == rx10, p1[tMin] == rp10, rg1[tMin] == rg10, ig1[tMin] == ig10,
    ra2[tMin] == ra20, ia2[tMin] == ia20, x2[tMin] == rx20, p2[tMin] == rp20, rg2[tMin] == rg20, ig2[tMin] == ig20
  };

  Quiet @ NDSolveValue[Join[eqs, inits], {ra1, ia1, x1, p1, rg1, ig1, ra2, ia2, x2, p2, rg2, ig2}, {t, tMin, tMax}, opts]
];

(* The Temporal Router maps directly into the standard SS1D parameter bus *)
GWPSS1DNUMERICAL[v0_, v1_, v2_, tMin_, tMax_, opts___][t_?NumericQ][GWPSS1DARG] := Module[
  {
   sol, init1, init2, 
   rat1, iat1, xt1, pt1, rgt1, igt1, 
   rat2, iat2, xt2, pt2, rgt2, igt2,
   nval1, nval2, nval12
  },
  
  If[t < tMin || t > tMax, 
    Message[GWPSS1DNUMERICAL::outofbounds, t, tMin, tMax];
    Return[$Failed];
  ];
  
  (* Safely extract the core mathematical initial conditions using the 1D API *)
  init1 = {GWP1DRA @@ PARAM11, GWP1DIA @@ PARAM11, GWP1DRX @@ PARAM11, GWP1DRP @@ PARAM11, 
           GWP1DRG @@ PARAM11, GWP1DIG @@ PARAM11, GWP1DHBAR @@ PARAM11, GWP1DMASS @@ PARAM11};
           
  init2 = {GWP1DRA @@ PARAM22, GWP1DIA @@ PARAM22, GWP1DRX @@ PARAM22, GWP1DRP @@ PARAM22, 
           GWP1DRG @@ PARAM22, GWP1DIG @@ PARAM22, GWP1DHBAR @@ PARAM22, GWP1DMASS @@ PARAM22};
  
  (* Execute memoized NDSolve solver *)
  sol = GWPSS1DNDSolveCache[v0, v1, v2, init1, init2, tMin, tMax, opts];
  
  {rat1, iat1, xt1, pt1, rgt1, igt1, rat2, iat2, xt2, pt2, rgt2, igt2} = Through[sol[t]];
  
  (* Reconstruct the 1D parameter arrays using the exact sequence order, pulling static metadata safely *)
  nval1 = {rat1, iat1, xt1, pt1, rgt1, igt1, 
           GWP1DNORM @@ PARAM11, GWP1DHBAR @@ PARAM11, GWP1DMASS @@ PARAM11, 
           {v0[t], v1[t], v2[t]}, GWP1DINPUT @@ PARAM11};
           
  nval2 = {rat2, iat2, xt2, pt2, rgt2, igt2, 
           GWP1DNORM @@ PARAM22, GWP1DHBAR @@ PARAM22, GWP1DMASS @@ PARAM22, 
           {v0[t], v1[t], v2[t]}, GWP1DINPUT @@ PARAM22};
  
  (* Dynamically generate the cross-term parameters at time t *)
  nval12 = {GWP1DPARAM12[Sequence @@ nval1][Sequence @@ nval2]};
  
  (* Return the exact 7-element sequence expected by GWPSS1DARG *)
  Sequence @@ {nval1, nval2, nval12, RC, IC, NORM, NORM2}
];


(* ::Section::Closed:: *)
(*GWPRegistry Setup*)


$potentialsNumericalSS1D = {
  {"Numerical", GWPSS1DNUMERICAL, "{\"Numerical\", V0, V1, V2, TMin, TMax, Opts___}", "Parameterized"}
};

GWPTools`GWPRegistry`GWPRegisterPotentials[$potentialsNumericalSS1D, "SS1D"];
Clear[$potentialsNumericalSS1D];


(* ::Section::Closed:: *)
(*End*)


(* --- End "GWPTools`GWPNumericalSS1D`Private`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPNumericalSS1D] End Private"]];
End[]

(* Hide internal code for all Developer functions from the ? menu *)
SetAttributes[Evaluate[Names["GWPTools`GWPNumericalSS1D`*"]], {ReadProtected}];

(* --- End "GWPTools`GWPNumericalSS1D`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPNumericalSS1D] EndPackage"]];
EndPackage[]