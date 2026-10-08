(* ::Package:: *)

(* ::Title:: *)
(*GWPHydrodynamicsMC1D Package*)


(* ::Section::Closed:: *)
(*GWPDeveloper Usage Registration*)


Needs["GWPTools`GWPDeveloper`"];
BeginPackage["GWPTools`GWPDeveloper`"]

If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamicsMC1D] BeginPackage GWPDeveloper"]];
Off[General::shdw];

(* --- x-Space Hydrodynamic Fields --- *)
GWPMC1DQPX::usage = "GWPMC1DQPX[x][param] evaluates the quantum potential for the multi-component superposition.";
GWPMC1DQFX::usage = "GWPMC1DQFX[x][param] evaluates the quantum force for the multi-component superposition.";
GWPMC1DJX::usage = "GWPMC1DJX[x][param] evaluates the probability current for the multi-component superposition.";
GWPMC1DVX::usage = "GWPMC1DVX[x][param] evaluates the flow velocity for the multi-component superposition.";

Off[General::shdw];
If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamicsMC1D] EndPackage GWPDeveloper"]];
Quiet[EndPackage[], General::shdw];

$ContextPath = DeleteCases[$ContextPath, "GWPTools`GWPDeveloper`"];


(* ::Section::Closed:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPHydrodynamicsMC1D`                              *)
(* DESCRIPTION : MC1D Quantum fluid dynamics and Bohmian trajectories for    *)
(*               the GWPTools framework.                                     *)
(* ========================================================================= *)
BeginPackage["GWPTools`GWPHydrodynamicsMC1D`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamicsMC1D] BeginPackage"]];
Begin["`Private`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamicsMC1D] Begin Private"]];

Needs["GWPTools`GWPDeveloper`"];
Needs["GWPTools`GWPRegistry`"];
Needs["GWPTools`GWPEngine1D`"];
Needs["GWPTools`GWPEngineMC1D`"];



(* ::Section::Closed:: *)
(*Prototype Properties*)


(* --- Internal Helpers --- *)
GWPMC1DQPFAC[GWPMC1DARG] := Module[{param1},
  param1 = PACKEDPARAMS[[MC1DIndex[1, 1, NSTATES]]];
  param1[[8]]^2 / (4 * param1[[9]])
];

(* --- x-Space Fields --- *)
With[{VAL = GWPMC1DVAL},

  GWPMC1DQPX[x_][GWPMC1DARG] := Module[{FAC, RHO0, RHO1, RHO2},
    FAC = -GWPMC1DQPFAC[VAL];
    RHO0 = GWPMC1DRHOX[0][x][VAL];
    RHO1 = GWPMC1DRHOX[1][x][VAL];
    RHO2 = GWPMC1DRHOX[2][x][VAL];
    
    FAC * (RHO2/RHO0 - 1/2*(RHO1/RHO0)^2)
  ];

  GWPMC1DQFX[x_][GWPMC1DARG] := Module[{FAC, RHO0, RHO1, RHO2, RHO3},
    FAC = GWPMC1DQPFAC[VAL];
    RHO0 = GWPMC1DRHOX[0][x][VAL];
    RHO1 = GWPMC1DRHOX[1][x][VAL];
    RHO2 = GWPMC1DRHOX[2][x][VAL];
    RHO3 = GWPMC1DRHOX[3][x][VAL];
    
    FAC * (RHO3/RHO0 - 2*RHO1*RHO2/RHO0^2 + (RHO1/RHO0)^3)
  ];
  
  GWPMC1DJX[x_][GWPMC1DARG] := Module[{psi, cpsi, dpsi, cdpsi, HBAR, MASS, param1},
    param1 = PACKEDPARAMS[[MC1DIndex[1, 1, NSTATES]]];
    HBAR = param1[[8]];
    MASS = param1[[9]];
    
    psi = GWPMC1DPSIX[0][x][VAL];
    cpsi = GWPMC1DCSIX[0][x][VAL];
    dpsi = GWPMC1DPSIX[1][x][VAL];
    cdpsi = GWPMC1DCSIX[1][x][VAL];
    
    Re[(HBAR / (2 * I * MASS)) * (cpsi * dpsi - psi * cdpsi)]
  ];

  GWPMC1DVX[x_][GWPMC1DARG] := GWPMC1DJX[x][VAL] / GWPMC1DRHOX[0][x][VAL];
];



(* ::Section::Closed:: *)
(*GWPObject Registration*)


$regHydroXMC1D = Join[#, {"HydrodynamicsX", "MC1D"}] & /@ {
  {"QuantumPotentialX", "QPX", "Field", "Spatial"},
  {"QuantumForceX",     "QFX", "Field", "Spatial"},
  {"CurrentX",          "JX",  "Field", "Spatial"},
  {"VelocityX",         "VX",  "Field", "Spatial"}
};

GWPTools`GWPRegistry`GWPRegisterExtension[$regHydroXMC1D];
Clear[$regHydroXMC1D];



(* ::Section::Closed:: *)
(*End*)


(* --- End "GWPTools`GWPHydrodynamicsMC1D`Private`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamicsMC1D] End Private"]];
End[];

SetAttributes[Evaluate[Names["GWPTools`GWPHydrodynamicsMC1D`*"]], {ReadProtected}];

(* --- End "GWPTools`GWPHydrodynamicsMC1D" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamicsMC1D] EndPackage"]];
EndPackage[]
