(* ::Package:: *)

(* ::Title:: *)
(*GWPHydrodynamicsSS1D Package*)


(* ::Section:: *)
(*GWPDeveloper Usage Registration*)


(* ::Subsection:: *)
(*BeginPackage*)


Needs["GWPTools`GWPDeveloper"];
BeginPackage["GWPTools`GWPDeveloper`"]


If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodyanamicsSS1D] BeginPackage GWPDeveloper"]];

Off[General::shdw];


(* ::Subsection::Closed:: *)
(*Usage Statements*)


(* --- x-Space Hydrodynamic Fields --- *)
GWPSS1DQPX::usage = "GWPSS1DQPX[x][superParam] evaluates the quantum potential for the superposition.";
GWPSS1DQFX::usage = "GWPSS1DQFX[x][superParam] evaluates the quantum force for the superposition.";


(* ::Subsection::Closed:: *)
(*End*)


Off[General::shdw];

If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamicsSS1D] EndPackage GWPDeveloper"]];

Quiet[EndPackage[], General::shdw]

(* Scrub the Developer context from the global path immediately *)
$ContextPath = DeleteCases[$ContextPath, "GWPTools`GWPDeveloper`"];


(* ::Section:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPHydrodynamicsSS1D`                              *)
(* DESCRIPTION : SS1D Quantum fluid dynamics and Bohmian trajectories for    *)
(*               the GWPTools framework.                                     *)
(* ========================================================================= *)
BeginPackage["GWPTools`GWPHydrodynamicsSS1D`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamicsSS1D] BeginPackage"]];
Begin["`Private`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamicsSS1D] Begin Private"]];
Needs["GWPTools`GWPDeveloper`"];
Needs["GWPTools`GWPRegistry`"];
Needs["GWPTools`GWPEngine1D`"];
Needs["GWPTools`GWPEngineSS1D`"];



(* ::Section::Closed:: *)
(*Prototype Properties*)


(* --- Internal Helpers --- *)
QPFAC[GWP1DARG] = HBAR^2/(4*MASS);

(* --- x-Space Fields --- *)
With[{VAL = GWPSS1DVAL},

  GWPSS1DQPX[x_][GWPSS1DARG] := Module[{FAC, RHO0, RHO1, RHO2},
    FAC = -(QPFAC @@ PARAM11);
    RHO0 = GWPSS1DRHOX[0][x][VAL];
    RHO1 = GWPSS1DRHOX[1][x][VAL];
    RHO2 = GWPSS1DRHOX[2][x][VAL];
    
    FAC * (RHO2/RHO0 - 1/2*(RHO1/RHO0)^2)
  ];

  GWPSS1DQFX[x_][GWPSS1DARG] := Module[{FAC, RHO0, RHO1, RHO2, RHO3},
    FAC = (QPFAC @@ PARAM11);
    RHO0 = GWPSS1DRHOX[0][x][VAL];
    RHO1 = GWPSS1DRHOX[1][x][VAL];
    RHO2 = GWPSS1DRHOX[2][x][VAL];
    RHO3 = GWPSS1DRHOX[3][x][VAL];
    
    FAC * (RHO3/RHO0 - 2*RHO1*RHO2/RHO0^2 + (RHO1/RHO0)^3)
  ];
  
];


(* ::Section::Closed:: *)
(*GWPObject Registration*)


(* --- GWPObject Registry (SS1D Hydrodynamics) --- *)
$regHydroXSS1D = Join[#, {"HydrodynamicsX", "SS1D"}] & /@ {
  {"QuantumPotentialX", "QPX", "Field", "Spatial"},
  {"QuantumForceX",     "QFX", "Field", "Spatial"}
};


(* Inject into the central registry *)
GWPTools`GWPRegistry`GWPRegisterExtension[$regHydroXSS1D];


(* ::Section:: *)
(*End*)


(* --- End "GWPTools`GWPHydrodynamicsSS1D`Private`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamicsSS1D] End Private"]];
End[];

(* Hide internal code for all Developer functions from the ? menu *)
SetAttributes[Evaluate[Names["GWPTools`GWPHydrodynamicsSS1D`*"]], {ReadProtected}];

(* --- End "GWPTools`GWPHydrodynamicsSS1D" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamicsSS1D] EndPackage"]];
EndPackage[]
