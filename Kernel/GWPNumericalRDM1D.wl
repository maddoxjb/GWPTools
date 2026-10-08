(* ::Package:: *)

(* ::Title:: *)
(*GWPNumericalRDM1D Package*)


(* ::Section::Closed:: *)
(*GWPDeveloper Usage Registration*)


(* ::Subsection::Closed:: *)
(*BeginPackage*)


(* --- Hoist Usage Statements into the Developer Context --- *)
Needs["GWPTools`GWPDeveloper`"];
BeginPackage["GWPTools`GWPDeveloper`"]

If[TrueQ[Global`$GWPDebug], Print["[GWPNumericalRDM1D] BeginPackage GWPDeveloper"]];

Off[General::shdw];


(* ::Subsection::Closed:: *)
(*Usage Statements*)


GWPRDM1DNUMERICAL::usage = "GWPRDM1DNUMERICAL[V0, V1, V2, tMin, tMax, opts][t][param] evaluates the numerically integrated RDM parameters for unitary evolution.";
GWPRDM1DNUMERICALCL::usage = "GWPRDM1DNUMERICALCL[V0, V1, V2, GAMMA, KT, tMin, tMax, opts][t][param] evaluates the RDM parameters under Caldeira-Leggett thermal decoherence.";
GWPRDM1DNDSolveCache::usage = "Internal memoization engine for RDM numerical variance differential equations.";


(* ::Subsection::Closed:: *)
(*End Package*)


Off[General::shdw];

If[TrueQ[Global`$GWPDebug], Print["[GWPNumericalRDM1D] EndPackage GWPDeveloper"]];

Quiet[EndPackage[], General::shdw]

$ContextPath = DeleteCases[$ContextPath, "GWPTools`GWPDeveloper`"];


(* ::Section::Closed:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPNumericalRDM1D`                                 *)
(* DESCRIPTION : Numerical integration extensions for Reduced Density GWPs.  *)
(* ========================================================================= *)

BeginPackage["GWPTools`GWPNumericalRDM1D`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPNumericalRDM1D] BeginPackage"]];
Begin["`Private`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPNumericalRDM1D] Begin Private"]];

Needs["GWPTools`GWPDeveloper`"];
Needs["GWPTools`GWPRegistry`"];
Needs["GWPTools`GWPEngineRDM1D`"];


(* ::Section::Closed:: *)
(*The Numerical Engine*)


GWPRDM1DNUMERICAL::outofbounds = "The requested time `1` is outside the simulated time domain [`2`, `3`].";

(* The internal cache for NDSolve. Integrates strictly linear variance ODEs for maximum stability. *)
GWPRDM1DNDSolveCache[v0_, v1_, v2_, gamma_, kT_, initList_, tMin_, tMax_, opts___] := 
  GWPRDM1DNDSolveCache[v0, v1, v2, gamma, kT, initList, tMin, tMax, opts] = Module[
  {sxx0, sxp0, spp0, rx0, rp0, hbar, mass,
   sxx, sxp, spp, x, p, t, eqs, inits},
  
  {sxx0, sxp0, spp0, rx0, rp0, hbar, mass} = initList;
  
  (* ODEs for Caldeira-Leggett Dissipation / Unitary Evolution (if gamma = 0) *)
  eqs = {
    sxx'[t] == 2 * sxp[t] / mass,
    sxp'[t] == spp[t] / mass - 2 * v2[t] * sxx[t] - gamma[t] * sxp[t],
    spp'[t] == -4 * v2[t] * sxp[t] - 2 * gamma[t] * spp[t] + 2 * mass * gamma[t] * kT[t],
    x'[t]   == p[t] / mass,
    p'[t]   == -v1[t] - 2 * v2[t] * x[t] - gamma[t] * p[t]
  };

  inits = {
    sxx[tMin] == sxx0, 
    sxp[tMin] == sxp0, 
    spp[tMin] == spp0, 
    x[tMin]   == rx0, 
    p[tMin]   == rp0
  };

  Quiet @ NDSolveValue[Join[eqs, inits], {sxx, sxp, spp, x, p}, {t, tMin, tMax}, opts]
];

(* The Temporal Router for Caldeira-Leggett Evolution *)
GWPRDM1DNUMERICALCL[v0_, v1_, v2_, gamma_, kT_, tMin_, tMax_, opts___][t_?NumericQ][GWPRDM1DARG] := Module[
  {sol, initList, sxx0, sxp0, spp0, 
   sxxT, sxpT, sppT, xT, pT,
   raT, iaT, thetaT, rgT},
  
  If[t < tMin || t > tMax, 
    Message[GWPRDM1DNUMERICAL::outofbounds, t, tMin, tMax];
    Return[$Failed];
  ];
  
  (* Step 1: Map Initial Wavepacket Shape to Phase-Space Variances *)
  sxx0 = 1 / (4 * RA);
  sxp0 = (HBAR * IA) / (2 * RA);
  spp0 = HBAR^2 * (2 * THETA + RA + IA^2 / RA);
  
  initList = {sxx0, sxp0, spp0, RX, RP, HBAR, MASS};
  
  (* Step 2: Retrieve from Cache and Evaluate *)
  sol = GWPRDM1DNDSolveCache[v0, v1, v2, gamma, kT, initList, tMin, tMax, opts];
  {sxxT, sxpT, sppT, xT, pT} = Through[sol[t]];
  
  (* Step 3: Map Integrated Variances Back to Wavepacket Shape *)
  raT = 1 / (4 * sxxT);
  iaT = sxpT / (2 * HBAR * sxxT);
  thetaT = (sxxT * sppT - sxpT^2) / (2 * HBAR^2 * sxxT) - 1 / (8 * sxxT);
  
  (* Enforce Trace Normalization dynamically (RG is strictly algebraic in RDM) *)
  rgT = 1/4 * Log[2 * raT / Pi];
  
  (* Return the 12-element RDM1D parameter bus *)
  Sequence @@ {raT, iaT, xT, pT, rgT, IG, thetaT, NORM, HBAR, MASS, {v0[t], v1[t], v2[t]}, INIT}
];

(* Overload for Standard Unitary Evolution (Forces gamma = 0 and kT = 0) *)
With[{VAL = GWPRDM1DVAL},
  GWPRDM1DNUMERICAL[v0_, v1_, v2_, tMin_, tMax_, opts___][t_?NumericQ][GWPRDM1DARG] := 
    GWPRDM1DNUMERICALCL[v0, v1, v2, 0&, 0&, tMin, tMax, opts][t][VAL]
];


(* ::Section::Closed:: *)
(*GWPRegistry Setup*)


$potentialsNumericalRDM1D = {
  {"Numerical",   GWPRDM1DNUMERICAL,   "{\"Numerical\", V0, V1, V2, TMin, TMax, Opts___}", "Parameterized"},
  {"NumericalCL", GWPRDM1DNUMERICALCL, "{\"NumericalCL\", V0, V1, V2, GAMMA, KT, TMin, TMax, Opts___}", "Parameterized"}
};

GWPTools`GWPRegistry`GWPRegisterPotentials[$potentialsNumericalRDM1D, "RDM1D"];
Clear[$potentialsNumericalRDM1D];


(* ::Section::Closed:: *)
(*End*)


(* --- End "GWPTools`GWPNumericalRDM1D`Private`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPNumericalRDM1D] End Private"]];
End[]

SetAttributes[Evaluate[Names["GWPTools`GWPNumericalRDM1D`*"]], {ReadProtected}];

(* --- End "GWPTools`GWPNumericalRDM1D`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPNumericalRDM1D] EndPackage"]];
EndPackage[]