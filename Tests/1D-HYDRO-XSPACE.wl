(* ::Package:: *)

(* ========================================================================= *)
(* TEST SUITE  : GWPTools (Version 1.0.0)                                    *)
(* FILE        : 1D-HYDRO-XSPACE.wl                                          *)
(* DESCRIPTION : Tests HYDRODYNAMICSX section of GWPHydrodynamics1D.wl       *)
(* ========================================================================= *)

(* Load the Master Test Environment *)
Needs["GWPTools`GWPDiagnostics`"]

(* ========================================================== *)
(* DEFINITIONS AND CONFIGURATION                              *)
(* ========================================================== *)

(* Save the user's current global assumptions before modifying them *)
$userAssumptions = $Assumptions;

(* Optimized Parameter Sequence injecting {V0,V1,V2} for explicit PE validation *)
ToExpression[DEF01 = "PAR=Sequence[RA,IA,RX,RP,RG,IG,E^(IG/HBAR)*(2/Pi)^(1/4)*RA^(1/4),HBAR,MASS,{V0,V1,V2},{RA,IA,RX,0,RP,0,RG,IG}]"];

ToExpression[DEF01 = "PAR=Sequence@@{RA, IA, -1/2*(IP + 2*HBAR*IA*IX)/(HBAR*RA) + RX, (IA*(IP + 2*HBAR*IA*IX))/RA + 2*HBAR*IX*RA + RP, 
 -1/4*(4*HBAR*IA^2*IP*IX + 4*HBAR^2*IA^3*IX^2 + 2*RA*(-2*HBAR*RA*RG + IP*RP) + IA*(IP^2 + 4*HBAR*IX*RA*(HBAR*IX*RA + RP)))/(HBAR*RA^2), 
 -1/4*(IP^2 + 4*HBAR*IA*IP*IX + 4*HBAR*(-(IG*RA) + HBAR*IX^2*(IA^2 + RA^2) + IX*RA*RP))/(HBAR*RA), 
 ((2/Pi)^(1/4)*RA^(1/4))/E^((IP^2 + 4*HBAR*IA*IP*IX + 4*HBAR*(-(IG*RA) + HBAR*IX^2*(IA^2 + RA^2) + IX*RA*RP))/(4*HBAR^2*RA)), HBAR, MASS, {V0, V1, V2}, 
 {RA, IA, RX, IX, RP, IP, RG, IG}}"];

(* --- Alternate fully general testing sequence --- *)
(* ToExpression[DEF01="PAR=GWP1DPARAM[RA+I*IA,RX+I*IX,RP+I*IP,RG+I*IG,\"HBAR\"->HBAR,\"MASS\"->MASS]"]; *)

(* Evaluates and sets the global assumptions natively *)
ToExpression[DEF02 = "$Assumptions=GWP1DASSUMPTIONS[PAR,\"Position\"->x]"];

ToExpression[STR01 = "PSIX0=GWP1DPSIX[x][PAR]"];
ToExpression[STR02 = "RHOX0=GWP1DRHOX[x][PAR]"];
ToExpression[STR03 = "RHOX1=GWP1DRHOX[1][x][PAR]"];
ToExpression[STR04 = "RHOX2=GWP1DRHOX[2][x][PAR]"];

ToExpression[STR05 = "SX=GWP1DSX[x][PAR]"];
ToExpression[STR06 = "VX=GWP1DVX[x][PAR]"];
ToExpression[STR07 = "QPX=GWP1DQPX[x][PAR]"];

(* ========================================================== *)
(* HYDRODYNAMIC VERIFICATION TESTS (POSITION SPACE)           *)
(* ========================================================== *)

VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF01]
VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF02]

(* ---------------------------------------------------------- *)
(* 1. Amplitude, Phase, and Mappings                          *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWP1DAX[x][PAR] - Sqrt[RHOX0]] == 0,
  TestID -> "GWP1DAX-01-Definition", MetaInformation -> STR02
]
VerificationTest[
  Simplify[Exp[I/HBAR*GWP1DSX[x][PAR]] - (PSIX0/GWP1DAX[x][PAR])] == 0,
  TestID -> "GWP1DSX-01-Definition", MetaInformation -> STR01
]
VerificationTest[
  Simplify[GWP1DPX[x][PAR] - D[SX, x]] == 0,
  TestID -> "GWP1DPX-01-Definition", MetaInformation -> STR05
]

(* ---------------------------------------------------------- *)
(* 2. Flow Velocities and Current                             *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWP1DVX[x][PAR] - (D[SX, x]/MASS)] == 0,
  TestID -> "GWP1DVX-01-Definition", MetaInformation -> STR05
]
VerificationTest[
  Simplify[GWP1DOVX[x][PAR] - ((HBAR/(2*MASS))*(RHOX1/RHOX0))] == 0,
  TestID -> "GWP1DOVX-01-Definition", MetaInformation -> STR03
]
VerificationTest[
  Simplify[GWP1DJX[x][PAR] - (VX*RHOX0)] == 0,
  TestID -> "GWP1DJX-01-Definition", MetaInformation -> STR06
]

(* ---------------------------------------------------------- *)
(* 3. Quantum Potential, Force, and Stress                    *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWP1DQPX[x][PAR] - (-HBAR^2/(2*MASS)*(D[GWP1DAX[x][PAR], {x, 2}]/GWP1DAX[x][PAR]))] == 0,
  TestID -> "GWP1DQPX-01-Definition"
]
VerificationTest[
  Simplify[GWP1DQFX[x][PAR] - (-D[QPX, x])] == 0,
  TestID -> "GWP1DQFX-01-Definition", MetaInformation -> STR07
]
VerificationTest[
  Simplify[GWP1DQSX[x][PAR] - (HBAR^2/(4*MASS)*(RHOX2 - RHOX1^2/RHOX0))] == 0,
  TestID -> "GWP1DQSX-01-Definition", MetaInformation -> STR04
]

(* ---------------------------------------------------------- *)
(* 4. Information and Energy Densities                        *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWP1DFIX[x][PAR] - (RHOX1^2/RHOX0)] == 0,
  TestID -> "GWP1DFIX-01-Definition", MetaInformation -> STR03
]
VerificationTest[
  Simplify[GWP1DIKEX[x][PAR] - (HBAR^2/(8*MASS)*RHOX1^2/RHOX0)] == 0,
  TestID -> "GWP1DIKEX-01-Definition", MetaInformation -> STR03
]
VerificationTest[
  Simplify[GWP1DCKEX[x][PAR] - ((1/2)*MASS*(VX^2)*RHOX0)] == 0,
  TestID -> "GWP1DCKEX-01-Definition", MetaInformation -> STR06
]
VerificationTest[
  Simplify[GWP1DTKEX[x][PAR] - (GWP1DCKEX[x][PAR] + GWP1DIKEX[x][PAR])] == 0,
  TestID -> "GWP1DTKEX-01-Decomposition"
]
VerificationTest[
  Simplify[GWP1DTPEX[x][PAR] - (GWP1DPEX[x][PAR]*RHOX0)] == 0,
  TestID -> "GWP1DTPEX-01-Definition", MetaInformation -> STR02
]
VerificationTest[
  Simplify[GWP1DTEDX[x][PAR] - (GWP1DTKEX[x][PAR] + GWP1DTPEX[x][PAR])] == 0,
  TestID -> "GWP1DTEDX-01-Decomposition"
]

(* ========================================================== *)
(* CLEANUP: PREVENT NAMESPACE POLLUTION                       *)
(* ========================================================== *)

(* Restore the user's exact original assumptions *)
$Assumptions = $userAssumptions;
Remove[$userAssumptions];

(* Clear dynamically generated strings so MetaInformation renders properly *)
ClearAll["DEF*"];
ClearAll["STR*"];

(* Clear the parameter sequence and wavefunction/hydrodynamic variables *)
ClearAll[PAR, PSIX0, RHOX0, RHOX1, RHOX2, SX, VX, QPX];

(* Clear the abstract symbolic variables and coordinates used in the tests *)
ClearAll[RA, IA, RX, IX, RP, IP, RG, IG, HBAR, MASS, V0, V1, V2, x];
