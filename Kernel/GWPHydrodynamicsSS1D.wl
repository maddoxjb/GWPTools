(* ::Package:: *)

(* ::Title:: *)
(*GWPHydrodynamicsSS1D Package*)


(* ::Section::Closed:: *)
(*GWPDeveloper Usage Registration*)


(* ::Subsection::Closed:: *)
(*BeginPackage*)


Needs["GWPTools`GWPDeveloper`"];
BeginPackage["GWPTools`GWPDeveloper`"]

If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamicsSS1D] BeginPackage GWPDeveloper"]];

Off[General::shdw];


(* ::Subsection::Closed:: *)
(*Usage Statements*)


(* --- x-Space Hydrodynamic Fields --- *)
GWPSS1DQPX::usage = "GWPSS1DQPX[x][superParam] evaluates the quantum potential for the superposition.";
GWPSS1DQFX::usage = "GWPSS1DQFX[x][superParam] evaluates the quantum force for the superposition.";
GWPSS1DJX::usage = "GWPSS1DJX[x][param] evaluates the x-space probability current density for a 1D superposition.";
GWPSS1DVX::usage = "GWPSS1DVX[x][param] evaluates the x-space velocity flow field for a 1D superposition.";


(* ::Subsection::Closed:: *)
(*EndPackage*)


Off[General::shdw];

If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamicsSS1D] EndPackage GWPDeveloper"]];

Quiet[EndPackage[], General::shdw]

(* Scrub the Developer context from the global path immediately *)
$ContextPath = DeleteCases[$ContextPath, "GWPTools`GWPDeveloper`"];


(* ::Section::Closed:: *)
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
(*Properties*)


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


(* ==================================================================== *)
(* x-Space Hydrodynamic Fields (Superposition)                          *)
(* ==================================================================== *)

With[{VAL = GWPSS1DVAL},
  GWPSS1DJX[x_][GWPSS1DARG] := Module[{psi, cpsi, dpsi, cdpsi, HBAR, MASS},
    (* Extract physical constants from the first component *)
    HBAR = PARAM11[[8]];
    MASS = PARAM11[[9]];
    
    (* Evaluate the zeroth and first spatial derivatives *)
    psi = GWPSS1DPSIX[0][x][VAL];
    cpsi = GWPSS1DCSIX[0][x][VAL];
    dpsi = GWPSS1DPSIX[1][x][VAL];
    cdpsi = GWPSS1DCSIX[1][x][VAL];
    
    (* J(x) = (HBAR / 2 m i) * (Psi^* dPsi - Psi dPsi^ *)
    Re[(HBAR / (2 * I * MASS)) * (cpsi * dpsi - psi * cdpsi)]
  ]
];
  
With[{VAL = GWPSS1DVAL},
  GWPSS1DVX[x_][GWPSS1DARG] := GWPSS1DJX[x][VAL] / GWPSS1DRHOX[0][x][VAL];
];


(* ::Section::Closed:: *)
(*GWPObject Registration*)


(* --- GWPObject Registry (SS1D Hydrodynamics) --- *)
$regHydroXSS1D = Join[#, {"HydrodynamicsX", "SS1D"}] & /@ {
  {"QuantumPotentialX", "QPX", "Field", "Spatial"},
  {"QuantumForceX",     "QFX", "Field", "Spatial"},
  {"CurrentX",  "JX", "Field", "Spatial"},
  {"VelocityX", "VX", "Field", "Spatial"}
};

(* Inject into the central registry *)
GWPTools`GWPRegistry`GWPRegisterExtension[$regHydroXSS1D];
Clear[$regHydroXSS1D];


(* ::Section::Closed:: *)
(*End*)


(* --- End "GWPTools`GWPHydrodynamicsSS1D`Private`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamicsSS1D] End Private"]];
End[];

(* Hide internal code for all Developer functions from the ? menu *)
SetAttributes[Evaluate[Names["GWPTools`GWPHydrodynamicsSS1D`*"]], {ReadProtected}];

(* --- End "GWPTools`GWPHydrodynamicsSS1D" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamicsSS1D] EndPackage"]];
EndPackage[]
