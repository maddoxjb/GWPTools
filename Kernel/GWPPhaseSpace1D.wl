(* ::Package:: *)

(* ::Title:: *)
(*GWPPhaseSpace1D Package*)


(* ::Section::Closed:: *)
(*GWPDeveloper Usage Registration*)


(* ::Subsection::Closed:: *)
(*BeginPackage*)


Needs["GWPTools`GWPDeveloper`"];
BeginPackage["GWPTools`GWPDeveloper`"]


If[TrueQ[Global`$GWPDebug], Print["[GWPPhaseSpace1D] BeginPackage GWPDeveloper"]];

Off[General::shdw];


(* ::Subsection::Closed:: *)
(*Usage Statements*)


(* --- Phase Space Usages --- *)
GWP1DDMX::usage = "GWP1DDMX[x, y][param] evaluates the spatial density matrix.";
GWP1DDMP::usage = "GWP1DDMP[p1, p2][param] evaluates the momentum space density matrix.";
GWP1DWIG::usage = "GWP1DWIG[x, p][param] evaluates the Wigner phase space distribution.";
GWP1DHUSIMI::usage = "GWP1DHUSIMI[x, p, s][param] evaluates the Husimi Q-distribution.";
GWP1DWEHRL::usage = "GWP1DWEHRL[s][param] evaluates the Wehrl entropy.";
GWP1DPURITY::usage = "GWP1DPURITY[param] evaluates the state purity.";
GWP1DVONNEUMANN::usage = "GWP1DVONNEUMANN[param] evaluates the von Neumann entropy.";


(* ::Subsection::Closed:: *)
(*End*)


Off[General::shdw];

If[TrueQ[Global`$GWPDebug], Print["[GWPPhaseSpace1D] EndPackage GWPDeveloper"]];

Quiet[EndPackage[], General::shdw]

(* Scrub the Developer context from the global path immediately *)
$ContextPath = DeleteCases[$ContextPath, "GWPTools`GWPDeveloper`"];


(* ::Section::Closed:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPPhaseSpace1D`                                   *)
(* DESCRIPTION : 1D Phase space functions for the GWPTools framework.        *)
(* ========================================================================= *)
BeginPackage["GWPTools`GWPPhaseSpace1D`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPPhaseSpace1D] BeginPackage"]];
Begin["`Private`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPPhaseSpace1D] Begin Private"]];
Needs["GWPTools`GWPDeveloper`"];
Needs["GWPTools`GWPRegistry`"];
Needs["GWPTools`GWPEngine1D`"];


(* ::Section::Closed:: *)
(*Prototype Properties*)


(* --- Phase Space & Density Matrices --- *)
GWP1DDMX[x_, y_][GWP1DARG] = Sqrt[2*RA / Pi] * Exp[-(RA + I*IA)*(x - RX)^2 - (RA - I*IA)*(y - RX)^2 + (I*RP*(x - y))/HBAR];

GWP1DDMP[p1_, p2_][GWP1DARG] = Sqrt[RA / (2*Pi*HBAR^2*(RA^2 + IA^2))] * 
  Exp[-((p1 - RP)^2)/(4*HBAR^2*(RA + I*IA)) - ((p2 - RP)^2)/(4*HBAR^2*(RA - I*IA)) - (I*RX*(p1 - p2))/HBAR];

GWP1DWIG[x_, p_][GWP1DARG] = 1/(Pi*HBAR) * Exp[-((2*(RA^2 + IA^2)*(x - RX)^2)/RA) - ((p - RP)^2)/(2*HBAR^2*RA) - (2*IA*(x - RX)*(p - RP))/(HBAR*RA)];

(* --- Phase Space Distributions --- *)

(* Husimi Q-Distribution (Requires reference coherent state width 's') *)
GWP1DHUSIMI[s_?GWPScalarQ][x_, p_][GWP1DARG] = (1 / (2*Pi*HBAR)) * (2*Sqrt[RA*s] / Sqrt[(RA + s)^2 + IA^2]) * 
  Exp[-((2*s*(RA^2 + IA^2 + s*RA)*(x - RX)^2 + ((RA + s)/(2*HBAR^2))*(p - RP)^2 + (2*s*IA/HBAR)*(x - RX)*(p - RP)) / ((RA + s)^2 + IA^2))];

(* Fallback: If no shape parameter is provided, default to s = 1/2 *)
GWP1DHUSIMI[x_, p_][args___] := GWP1DHUSIMI[1/2][x, p][args];

(* --- Phase Space Metrics --- *)

(* Wehrl Entropy (Entropy of the Husimi Q-Distribution) *)
GWP1DWEHRL[s_?GWPScalarQ][GWP1DARG] = 1 + Log[((RA + s)^2 + IA^2) / (4*RA*s)];

(* Fallback: If pre-argument sequence does not match a single scalar, route to 1/2 *)
GWP1DWEHRL[param___] /; !MatchQ[{param}, {_?GWPScalarQ}] := GWP1DWEHRL[1/2][param];

(* Purity (Trivially 1 for pure states) *)
GWP1DPURITY[GWP1DARG] = 1;

(* Von Neumann Entropy (Trivially 0 for pure states) *)
GWP1DVONNEUMANN[GWP1DARG] = 0;


(* ::Section::Closed:: *)
(*GWPObject Registration*)


(* --- GWPObject Registry (1D Phase Space) --- *)
$regPhaseSpace1D = Join[#, {"PhaseSpace", "1D"}] & /@ {
  {"DensityMatrixX",    "DMX",        "Bivariate",              "BivariateSpatial"},
  {"DensityMatrixP",    "DMP",        "Bivariate",              "BivariateSpatial"},
  {"WignerFunction",    "WIG",        "Bivariate",              "BivariateSpatial"},
  {"HusimiQ",           "HUSIMI",     "ParameterizedBivariate", "ParameterizedBivariateSpatial"},
  {"WehrlEntropy",      "WEHRL",      "ParameterizedTemporal",  "ParameterizedStaticValue"},
  {"Purity",            "PURITY",     "Static",                 "StaticValue"},
  {"VonNeumannEntropy", "VONNEUMANN", "Static",                 "StaticValue"}
};

(* Inject into the central registry *)
GWPTools`GWPRegistry`GWPRegisterExtension[$regPhaseSpace1D];
Clear[$regPhaseSpace1D];


(* ::Section::Closed:: *)
(*End*)


(* --- End "GWPTools`GWPPhaseSpace1D`Private`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPPhaseSpace1D] End Private"]];
End[];
SetAttributes[Evaluate[Names["GWPTools`GWPPhaseSpace1D`*"]], {ReadProtected}];
(* --- End "GWPTools`GWPPhaseSpace1D`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPPhaseSpace1D] EndPackage"]];
EndPackage[]