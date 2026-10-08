(* ::Package:: *)

(* ::Title:: *)
(*GWPNumericalMC1D Package*)


(* ::Section::Closed:: *)
(*GWPDeveloper Usage Registration*)


(* ::Subsection::Closed:: *)
(*BeginPackage*)


(* --- Hoist Usage Statements into the Developer Context --- *)
Needs["GWPTools`GWPDeveloper`"];
BeginPackage["GWPTools`GWPDeveloper`"]

If[TrueQ[Global`$GWPDebug], Print["[GWPNumericalMC1D] BeginPackage GWPDeveloper"]];

Off[General::shdw];


(* ::Subsection::Closed:: *)
(*Usage Statements*)


GWPMC1DNUMERICAL::usage = "GWPMC1DNUMERICAL[V0, V1, V2, tMin, tMax, opts][t][param] evaluates the numerically integrated multi-component state parameters at time t.";
GWPMC1DNDSolveCache::usage = "Internal memoization engine for the MC1D numerical differential equations.";


(* ::Subsection::Closed:: *)
(*End Package*)


Off[General::shdw];

If[TrueQ[Global`$GWPDebug], Print["[GWPNumericalMC1D] EndPackage GWPDeveloper"]];
Quiet[EndPackage[], General::shdw]

$ContextPath = DeleteCases[$ContextPath, "GWPTools`GWPDeveloper`"];


(* ::Section::Closed:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPNumericalMC1D`                                  *)
(* DESCRIPTION : Numerical NDSolve integration extensions for N-state GWPs.  *)
(* ========================================================================= *)

BeginPackage["GWPTools`GWPNumericalMC1D`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPNumericalMC1D] BeginPackage"]];
Begin["`Private`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPNumericalMC1D] Begin Private"]];

Needs["GWPTools`GWPDeveloper`"];
Needs["GWPTools`GWPRegistry`"];
Needs["GWPTools`GWPEngine1D`"];
Needs["GWPTools`GWPEngineMC1D`"];


(* ::Section::Closed:: *)
(*The Numerical Engine*)


GWPMC1DNUMERICAL::outofbounds = "The requested time `1` is outside the simulated time domain [`2`, `3`].";

(* The internal cache for NDSolve. Dynamically generates 6*N equations for N pure states. *)
GWPMC1DNDSolveCache[v0_, v1_, v2_, initLists_, tMin_, tMax_, opts___] := 
  GWPMC1DNDSolveCache[v0, v1, v2, initLists, tMin, tMax, opts] = Module[
  {nStates, hbar, mass, eqs, inits, vars, t, ra, ia, rx, rp, rg, ig},
  
  nStates = Length[initLists];
  
  (* Assume uniform physical constants across the ensemble *)
  hbar = initLists[[1, 7]];
  mass = initLists[[1, 8]];

  (* Construct the 6 coupled ODEs per wavepacket dynamically *)
  eqs = Flatten @ Table[{
    ra[i]'[t] == (4 * hbar / mass) * ra[i][t] * ia[i][t],
    ia[i]'[t] == -(2 * hbar / mass) * (ra[i][t]^2 - ia[i][t]^2) + (v2[t] / hbar),
    rx[i]'[t] == rp[i][t] / mass,
    rp[i]'[t] == -v1[t] - 2 * v2[t] * rx[i][t],
    rg[i]'[t] == (rp[i][t]^2 / (2 * mass)) - (v0[t] + v1[t]*rx[i][t] + v2[t]*rx[i][t]^2) - (hbar^2 / mass) * ra[i][t],
    ig[i]'[t] == -(hbar^2 / mass) * ia[i][t]
  }, {i, 1, nStates}];

  inits = Flatten @ Table[{
    ra[i][tMin] == initLists[[i, 1]],
    ia[i][tMin] == initLists[[i, 2]],
    rx[i][tMin] == initLists[[i, 3]],
    rp[i][tMin] == initLists[[i, 4]],
    rg[i][tMin] == initLists[[i, 5]],
    ig[i][tMin] == initLists[[i, 6]]
  }, {i, 1, nStates}];

  (* Flattened list of variables: {ra[1], ia[1], rx[1] ... ra[N], ia[N], rx[N] ... } *)
  vars = Flatten @ Table[{ra[i], ia[i], rx[i], rp[i], rg[i], ig[i]}, {i, 1, nStates}];

  Quiet @ NDSolveValue[Join[eqs, inits], vars, {t, tMin, tMax}, opts]
];

(* The Temporal Router for N-State Superpositions *)
With[{VAL = GWPMC1DVAL},
  GWPMC1DNUMERICAL[v0_, v1_, v2_, tMin_, tMax_, opts___][t_?NumericQ][GWPMC1DARG] := Module[
    {initLists, sol, rawVals, newDiags, newPacked, pureParam, offset},
    
    If[t < tMin || t > tMax, 
      Message[GWPMC1DNUMERICAL::outofbounds, t, tMin, tMax];
      Return[$Failed];
    ];
    
    (* 1. Safely extract the core mathematical initial conditions using the 1D API *)
    initLists = Table[
      pureParam = PACKEDPARAMS[[MC1DIndex[i, i, NSTATES]]];
      {GWP1DRA @@ pureParam, GWP1DIA @@ pureParam, GWP1DRX @@ pureParam, GWP1DRP @@ pureParam, 
       GWP1DRG @@ pureParam, GWP1DIG @@ pureParam, GWP1DHBAR @@ pureParam, GWP1DMASS @@ pureParam},
      {i, 1, NSTATES}
    ];
    
    (* 2. Execute memoized NDSolve solver for all N states simultaneously *)
    sol = GWPMC1DNDSolveCache[v0, v1, v2, initLists, tMin, tMax, opts];
    rawVals = Through[sol[t]];
    
    (* 3. Reconstruct the 1D parameter arrays for the pure diagonal states *)
    newDiags = Table[
      pureParam = PACKEDPARAMS[[MC1DIndex[i, i, NSTATES]]];
      offset = (i - 1) * 6;
      {
        rawVals[[offset + 1]], rawVals[[offset + 2]], rawVals[[offset + 3]], 
        rawVals[[offset + 4]], rawVals[[offset + 5]], rawVals[[offset + 6]], 
        GWP1DNORM @@ pureParam, GWP1DHBAR @@ pureParam, GWP1DMASS @@ pureParam, 
        {v0[t], v1[t], v2[t]}, GWP1DINPUT @@ pureParam
      },
      {i, 1, NSTATES}
    ];
    
    (* 4. Dynamically rebuild the cross-terms and pack the final array *)
    newPacked = Flatten[
      Table[
        If[i == j, 
          newDiags[[i]], 
          {GWP1DPARAM12[Sequence @@ newDiags[[i]]][Sequence @@ newDiags[[j]]]}
        ], 
        {i, 1, NSTATES}, {j, i, NSTATES}
      ], 
      1
    ];
    
    (* Return the exact 5-element sequence expected by GWPMC1DARG *)
    Sequence @@ {NSTATES, newPacked, COEFFS, NORM, NORM2}
  ]
];


(* ::Section::Closed:: *)
(*GWPRegistry Setup*)


$potentialsNumericalMC1D = {
  {"Numerical", GWPMC1DNUMERICAL, "{\"Numerical\", V0, V1, V2, TMin, TMax, Opts___}", "Parameterized"}
};

GWPTools`GWPRegistry`GWPRegisterPotentials[$potentialsNumericalMC1D, "MC1D"];
Clear[$potentialsNumericalMC1D];


(* ::Section::Closed:: *)
(*End*)


(* --- End "GWPTools`GWPNumericalMC1D`Private`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPNumericalMC1D] End Private"]];
End[]

SetAttributes[Evaluate[Names["GWPTools`GWPNumericalMC1D`*"]], {ReadProtected}];

(* --- End "GWPTools`GWPNumericalMC1D`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPNumericalMC1D] EndPackage"]];
EndPackage[]