(* ::Package:: *)

(* ::Title:: *)
(*GWPPhaseSpace Package*)


(* ::Section::Closed:: *)
(*GWPDeveloper Usage Registration*)


(* ::Subsection::Closed:: *)
(*BeginPackage*)


(* --- Open GWPDeveloper Package --- *)
BeginPackage["GWPTools`GWPDeveloper`"]


(* ::Subsection::Closed:: *)
(*Usage Statements*)


GWPDMX::usage = "GWPDMX[x, y][param] evaluates the spatial density matrix.";
GWPWIG::usage = "GWPWIG[x, p][param] evaluates the Wigner phase space distribution.";


(* ::Subsection::Closed:: *)
(*End*)


(* --- Close GWPDeveloper Package --- *)
EndPackage[]
$ContextPath = DeleteCases[$ContextPath, "GWPTools`GWPDeveloper`"];


(* ::Section::Closed:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPPhaseSpace`                                     *)
(* DESCRIPTION : Phase space functions for the GWPTools framework            *)
(*                                                                           *)
(* ========================================================================= *)

(* IMPORTANT: Do NOT include a second-argument array here! *)
BeginPackage["GWPTools`GWPPhaseSpace`"]

Begin["`Private`"]

(* LOAD DEPENDENCIES INTERNALLY *)
(* These will be available for compilation, but automatically erased from *)
(* the user's $ContextPath when EndPackage[] is called at the bottom.   *)
Needs["GWPTools`GWPDeveloper`"];
Needs["GWPTools`GWPEngine`"];


(* ::Section::Closed:: *)
(*Code*)


(* --- Phase Space & Density Matrices --- *)
GWPDMX[x_, y_][GWPARG] = Sqrt[2*RA / Pi] * Exp[-(RA + I*IA)*(x - RX)^2 - (RA - I*IA)*(y - RX)^2 + (I*RP*(x - y))/HBAR];

GWPWIG[x_, p_][GWPARG] = 1/(Pi*HBAR) * Exp[-((2*(RA^2 + IA^2)*(x - RX)^2)/RA) - ((p - RP)^2)/(2*HBAR^2*RA) - (2*IA*(x - RX)*(p - RP))/(HBAR*RA)];


(* ::Section::Closed:: *)
(*GWPObject Registry*)


$regPhaseSpace = Append[#, "PhaseSpace"] & /@ {
  {"DensityMatrix",  "DMX", "Bivariate", "BivariateSpatial"},
  {"WignerFunction", "WIG", "Bivariate", "BivariateSpatial"}
};

(* Export the combined chunk to the package context so GWPTools can find it *)
GWPTools`GWPPhaseSpace`$GWPPhaseSpaceRegistry = $regPhaseSpace;

(* The Hook: Dynamically inject this registry into the Object *)
If[TrueQ[GWPTools`Private`$DispatcherActive],
  GWPTools`Private`GWPRegisterExtension[GWPTools`GWPPhaseSpace`$GWPPhaseSpaceRegistry]
];


(* ::Section::Closed:: *)
(*End*)


End[];

(* Hide internal code from the ? menu *)
SetAttributes[Evaluate[Names["GWPTools`GWPPhaseSpace`*"]], {ReadProtected}];

EndPackage[]
