(* ::Package:: *)

(* ========================================================================= *)
(* TEST SUITE  : GWPTools (Version 1.0.0)                                    *)
(* FILE        : 1D-HYDRO-PSPACE.wl                                          *)
(* DESCRIPTION : Tests HYDRODYNAMICSP section of GWPHydrodynamics1D.wl       *)
(* ========================================================================= *)

(* Load the Master Test Environment *)
Needs["GWPTools`GWPDiagnostics`"]

(* ========================================================== *)
(* DEFINITIONS AND CONFIGURATION                              *)
(* ========================================================== *)

(* Save the user's current global assumptions before modifying them *)
$userAssumptions = $Assumptions;

(* Fully unwrapped and generalized Parameter Sequence injecting {V0,V1,V2} for explicit PE validations *)
ToExpression[DEF01 = "PAR=Sequence@@{RA, IA, -1/2*(IP + 2*HBAR*IA*IX)/(HBAR*RA) + RX, (IA*(IP + 2*HBAR*IA*IX))/RA + 2*HBAR*IX*RA + RP, -1/4*(4*HBAR*IA^2*IP*IX + 4*HBAR^2*IA^3*IX^2 + 2*RA*(-2*HBAR*RA*RG + IP*RP) + IA*(IP^2 + 4*HBAR*IX*RA*(HBAR*IX*RA + RP)))/(HBAR*RA^2), -1/4*(IP^2 + 4*HBAR*IA*IP*IX + 4*HBAR*(-(IG*RA) + HBAR*IX^2*(IA^2 + RA^2) + IX*RA*RP))/(HBAR*RA), ((2/Pi)^(1/4)*RA^(1/4))/E^((IP^2 + 4*HBAR*IA*IP*IX + 4*HBAR*(-(IG*RA) + HBAR*IX^2*(IA^2 + RA^2) + IX*RA*RP))/(4*HBAR^2*RA)), HBAR, MASS, {V0, V1, V2}, {RA, IA, RX, IX, RP, IP, RG, IG}}"];

(* Evaluates and sets the global assumptions natively *)
ToExpression[DEF02 = "$Assumptions=GWP1DASSUMPTIONS[PAR,\"Momentum\"->p]"];

ToExpression[STR01 = "PSIP0=GWP1DPSIP[p][PAR]"];
ToExpression[STR02 = "RHOP0=GWP1DRHOP[p][PAR]"];
ToExpression[STR03 = "RHOP1=GWP1DRHOP[1][p][PAR]"];
ToExpression[STR04 = "RHOP2=GWP1DRHOP[2][p][PAR]"];

ToExpression[STR05 = "SP=GWP1DSP[p][PAR]"];
ToExpression[STR06 = "XP=GWP1DXP[p][PAR]"];
ToExpression[STR07 = "VP=GWP1DVP[p][PAR]"];
ToExpression[STR08 = "QPP=GWP1DQPP[p][PAR]"];

(* ========================================================== *)
(* HYDRODYNAMIC VERIFICATION TESTS (MOMENTUM SPACE)           *)
(* ========================================================== *)

VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF01]
VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF02]

(* ---------------------------------------------------------- *)
(* 1. Amplitude, Phase, and Mappings                          *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWP1DAP[p][PAR] - Sqrt[RHOP0]] == 0,
  TestID -> "GWP1DAP-01-Definition", MetaInformation -> STR02
]
VerificationTest[
  FullSimplify[Exp[I/HBAR*GWP1DSP[p][PAR]] - (PSIP0/GWP1DAP[p][PAR])] == 0,
  TestID -> "GWP1DSP-01-Definition", MetaInformation -> STR01
]
VerificationTest[
  Simplify[GWP1DXP[p][PAR] - (-D[SP, p])] == 0,
  TestID -> "GWP1DXP-01-Definition", MetaInformation -> STR05
]

(* ---------------------------------------------------------- *)
(* 2. Flow Velocities and Current                             *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWP1DVP[p][PAR] - (-V1 - 2*V2*XP)] == 0,
  TestID -> "GWP1DVP-01-Definition", MetaInformation -> STR06
]
VerificationTest[
  Simplify[GWP1DOVP[p][PAR] - (HBAR*V2*(RHOP1/RHOP0))] == 0,
  TestID -> "GWP1DOVP-01-Definition", MetaInformation -> STR03
]
VerificationTest[
  Simplify[GWP1DJP[p][PAR] - (VP*RHOP0)] == 0,
  TestID -> "GWP1DJP-01-Definition", MetaInformation -> STR07
]

(* ---------------------------------------------------------- *)
(* 3. Quantum Potential, Force, and Stress                    *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWP1DQPP[p][PAR] - (-V2*HBAR^2*(D[GWP1DAP[p][PAR], {p, 2}]/GWP1DAP[p][PAR]))] == 0,
  TestID -> "GWP1DQPP-01-Definition"
]
VerificationTest[
  Simplify[GWP1DQFP[p][PAR] - (-D[QPP, p])] == 0,
  TestID -> "GWP1DQFP-01-Definition", MetaInformation -> STR08
]
VerificationTest[
  FullSimplify[Expand[GWP1DQSP[p][PAR] - ((V2*HBAR^2/2)*(RHOP2 - RHOP1^2/RHOP0))]] == 0,
  TestID -> "GWP1DQSP-01-Definition", MetaInformation -> STR04
]

(* ---------------------------------------------------------- *)
(* 4. Information and Energy Densities                        *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWP1DFIP[p][PAR] - (RHOP1^2/RHOP0)] == 0,
  TestID -> "GWP1DFIP-01-Definition", MetaInformation -> STR03
]
VerificationTest[
  Simplify[GWP1DIPEP[p][PAR] - ((V2*HBAR^2/4)*(RHOP1^2/RHOP0))] == 0,
  TestID -> "GWP1DIPEP-01-Definition", MetaInformation -> STR03
]
VerificationTest[
  Simplify[GWP1DCPEP[p][PAR] - ((V0 + V1*XP + V2*XP^2)*RHOP0)] == 0,
  TestID -> "GWP1DCPEP-01-Definition", MetaInformation -> STR06
]
VerificationTest[
  FullSimplify[GWP1DTPEP[p][PAR] - (GWP1DCPEP[p][PAR] + GWP1DIPEP[p][PAR])] == 0,
  TestID -> "GWP1DTPEP-01-Decomposition"
]
VerificationTest[
  Simplify[GWP1DTEDP[p][PAR] - (GWP1DTKEP[p][PAR] + GWP1DTPEP[p][PAR])] == 0,
  TestID -> "GWP1DTEDP-01-Decomposition"
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
ClearAll[PAR, PSIP0, RHOP0, RHOP1, RHOP2, SP, XP, VP, QPP];

(* Clear the abstract symbolic variables and coordinates used in the tests *)
ClearAll[RA, IA, RX, IX, RP, IP, RG, IG, HBAR, MASS, V0, V1, V2, p];
