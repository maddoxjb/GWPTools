(* ::Package:: *)

(* ::Title:: *)
(*GWPNumerical1D Package*)


(* ::Section::Closed:: *)
(*GWPDeveloper Usage Registration*)


(* ::Subsection::Closed:: *)
(*BeginPackage*)


(* --- Hoist Usage Statements into the Developer Context --- *)
Needs["GWPTools`GWPDeveloper`"];
BeginPackage["GWPTools`GWPDeveloper`"]

If[TrueQ[Global`$GWPDebug], Print["[GWPNumerical1D] BeginPackage GWPDeveloper"]];

Off[General::shdw];



(* ::Subsection::Closed:: *)
(*Usage Statements*)


GWP1DNUMERICAL::usage = "GWP1DNUMERICAL[V0, V1, V2, tMin, tMax, opts][t][param] evaluates the numerically integrated wavepacket parameters at time t.";
GWP1DNDSolveCache::usage = "GWP1DNDSolveCache is the internal memoization engine for the 1D numerical differential equations.";



(* ::Subsection::Closed:: *)
(*End Package*)


Off[General::shdw];

If[TrueQ[Global`$GWPDebug], Print["[GWPNumerical1D] EndPackage GWPDeveloper"]];

Quiet[EndPackage[], General::shdw]

(* Scrub the Developer context from the global path immediately *)
$ContextPath = DeleteCases[$ContextPath, "GWPTools`GWPDeveloper`"];



(* ::Section::Closed:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPNumerical1D`                                    *)
(* DESCRIPTION : Numerical NDSolve integration extensions for 1D GWPs.       *)
(* ========================================================================= *)

BeginPackage["GWPTools`GWPNumerical1D`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPNumerical1D] BeginPackage"]];
Begin["`Private`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPNumerical1D] Begin Private"]];

(* Load dependencies strictly internally *)
Needs["GWPTools`GWPDeveloper`"];
Needs["GWPTools`GWPRegistry`"];
Needs["GWPTools`GWPEngine1D`"];


(* ::Section::Closed:: *)
(*The Numerical Engine*)


GWP1DNUMERICAL::outofbounds = "The requested time `1` is outside the simulated time domain [`2`, `3`].";

(* The internal cache for NDSolve. Runs exactly once per unique configuration. *)
GWP1DNDSolveCache[v0_, v1_, v2_, initList_, tMin_, tMax_, opts___] := 
  GWP1DNDSolveCache[v0, v1, v2, initList, tMin, tMax, opts] = Module[
  {ra0, ia0, rx0, rp0, rg0, ig0, hbar, mass, x, p, ra, ia, rg, ig, t, eqs, inits},
  
  {ra0, ia0, rx0, rp0, rg0, ig0, hbar, mass} = initList;
  
  eqs = {
    ra'[t] == (4 * hbar / mass) * ra[t] * ia[t],
    ia'[t] == -(2 * hbar / mass) * (ra[t]^2 - ia[t]^2) + (v2[t] / hbar),
    x'[t]  == p[t] / mass,
    p'[t]  == -v1[t] - 2 * v2[t] * x[t],
    rg'[t] == (p[t]^2 / (2 * mass)) - (v0[t] + v1[t]*x[t] + v2[t]*x[t]^2) - (hbar^2 / mass) * ra[t],
    ig'[t] == -(hbar^2 / mass) * ia[t]
  };

  inits = {
    ra[tMin] == ra0, 
    ia[tMin] == ia0,
    x[tMin]  == rx0, 
    p[tMin]  == rp0, 
    rg[tMin] == rg0, 
    ig[tMin] == ig0
  };

  Quiet @ NDSolveValue[Join[eqs, inits], {ra, ia, x, p, rg, ig}, {t, tMin, tMax}, opts]
];

(* The Temporal Router maps directly into the standard 1D parameter bus *)
GWP1DNUMERICAL[v0_, v1_, v2_, tMin_, tMax_, opts___][t_?NumericQ][GWP1DARG] := Module[
  {solRA, solIA, solX, solP, solRG, solIG, initList},
  
  If[t < tMin || t > tMax, 
    Message[GWP1DNUMERICAL::outofbounds, t, tMin, tMax];
    Return[$Failed];
  ];
  
  initList = {RA, IA, RX, RP, RG, IG, HBAR, MASS};
  {solRA, solIA, solX, solP, solRG, solIG} = GWP1DNDSolveCache[v0, v1, v2, initList, tMin, tMax, opts];
  
  Sequence @@ {solRA[t], solIA[t], solX[t], solP[t], solRG[t], solIG[t], NORM, HBAR, MASS, {v0[t], v1[t], v2[t]}, INIT}
];


(* ::Section::Closed:: *)
(*GWPRegistry Setup*)


(* Register the Numerical Potential Model directly to the 1D type *)
$potentialsNumerical1D = {
  {"Numerical", GWP1DNUMERICAL, "{\"Numerical\", V0, V1, V2, TMin, TMax, Opts___}", "Parameterized"}
};

GWPTools`GWPRegistry`GWPRegisterPotentials[$potentialsNumerical1D, "1D"];
Clear[$potentialsNumerical1D];


(* ::Section::Closed:: *)
(*End*)


(* --- End "GWPTools`GWPNumerical1D`Private`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPNumerical1D] End Private"]];
End[]

(* Hide internal code for all Developer functions from the ? menu *)
SetAttributes[Evaluate[Names["GWPTools`GWPNumerical1D`*"]], {ReadProtected}];

(* --- End "GWPTools`GWPNumerical1D`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPNumerical1D] EndPackage"]];
EndPackage[]