(* ::Package:: *)

(* ========================================================================= *)
(* TEST SUITE  : GWPTools (Version 1.0.0)                                    *)
(* FILE        : 13-GWPHYDRODYNAMICSP.wl                                     *)
(* DESCRIPTION : Tests HYDRODYNAMICSP section of GWPDeveloper.wl             *)
(* ========================================================================= *)

(* Load the underlying developer math engine for raw testing *)
Needs["GWPTools`GWPDeveloper`"]

(* ========================================================== *)
(* DEFINITIONS AND CONFIGURATION                              *)
(* ========================================================== *)

(* Save the user's current global assumptions before modifying them *)
$userAssumptions = $Assumptions;

(* Fully unwrapped and generalized Parameter Sequence injecting {V0,V1,V2} for explicit PE validations *)
ToExpression[DEF01 = "PAR=Sequence@@{RA, IA, -1/2*(IP + 2*HBAR*IA*IX)/(HBAR*RA) + RX, (IA*(IP + 2*HBAR*IA*IX))/RA + 2*HBAR*IX*RA + RP, -1/4*(4*HBAR*IA^2*IP*IX + 4*HBAR^2*IA^3*IX^2 + 2*RA*(-2*HBAR*RA*RG + IP*RP) + IA*(IP^2 + 4*HBAR*IX*RA*(HBAR*IX*RA + RP)))/(HBAR*RA^2), -1/4*(IP^2 + 4*HBAR*IA*IP*IX + 4*HBAR*(-(IG*RA) + HBAR*IX^2*(IA^2 + RA^2) + IX*RA*RP))/(HBAR*RA), ((2/Pi)^(1/4)*RA^(1/4))/E^((IP^2 + 4*HBAR*IA*IP*IX + 4*HBAR*(-(IG*RA) + HBAR*IX^2*(IA^2 + RA^2) + IX*RA*RP))/(4*HBAR^2*RA)), HBAR, MASS, {V0, V1, V2}, {RA, IA, RX, IX, RP, IP, RG, IG}}"];

(* Evaluates and sets the global assumptions natively *)
ToExpression[DEF02 = "$Assumptions=GWPASSUMPTIONS[PAR,\"Momentum\"->p]"];

ToExpression[STR01 = "PSIP0=GWPPSIP[p][PAR]"];
ToExpression[STR02 = "RHOP0=GWPRHOP[p][PAR]"];
ToExpression[STR03 = "RHOP1=GWPRHOP[1][p][PAR]"];
ToExpression[STR04 = "RHOP2=GWPRHOP[2][p][PAR]"];

ToExpression[STR05 = "SP=GWPSP[p][PAR]"];
ToExpression[STR06 = "XP=GWPXP[p][PAR]"];
ToExpression[STR07 = "VP=GWPVP[p][PAR]"];
ToExpression[STR08 = "QPP=GWPQPP[p][PAR]"];

(* ========================================================== *)
(* HYDRODYNAMIC VERIFICATION TESTS (MOMENTUM SPACE)           *)
(* ========================================================== *)

VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF01]
VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF02]

(* ---------------------------------------------------------- *)
(* 1. Amplitude, Phase, and Mappings                          *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWPAP[p][PAR] - Sqrt[RHOP0]] == 0,
  TestID -> "GWPAP-01-Definition", MetaInformation -> STR02
]
VerificationTest[
  FullSimplify[Exp[I/HBAR*GWPSP[p][PAR]] - (PSIP0/GWPAP[p][PAR])] == 0,
  TestID -> "GWPSP-01-Definition", MetaInformation -> STR01
]
VerificationTest[
  Simplify[GWPXP[p][PAR] - (-D[SP, p])] == 0,
  TestID -> "GWPXP-01-Definition", MetaInformation -> STR05
]

(* ---------------------------------------------------------- *)
(* 2. Flow Velocities and Current                             *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWPVP[p][PAR] - (-V1 - 2*V2*XP)] == 0,
  TestID -> "GWPVP-01-Definition", MetaInformation -> STR06
]
VerificationTest[
  Simplify[GWPOVP[p][PAR] - (HBAR*V2*(RHOP1/RHOP0))] == 0,
  TestID -> "GWPOVP-01-Definition", MetaInformation -> STR03
]
VerificationTest[
  Simplify[GWPJP[p][PAR] - (VP*RHOP0)] == 0,
  TestID -> "GWPJP-01-Definition", MetaInformation -> STR07
]

(* ---------------------------------------------------------- *)
(* 3. Quantum Potential, Force, and Stress                    *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWPQPP[p][PAR] - (-V2*HBAR^2*(D[GWPAP[p][PAR], {p, 2}]/GWPAP[p][PAR]))] == 0,
  TestID -> "GWPQPP-01-Definition"
]
VerificationTest[
  Simplify[GWPQFP[p][PAR] - (-D[QPP, p])] == 0,
  TestID -> "GWPQFP-01-Definition", MetaInformation -> STR08
]
VerificationTest[
  FullSimplify[Expand[GWPQSP[p][PAR] - ((V2*HBAR^2/2)*(RHOP2 - RHOP1^2/RHOP0))]] == 0,
  TestID -> "GWPQSP-01-Definition", MetaInformation -> STR04
]

(* ---------------------------------------------------------- *)
(* 4. Information and Energy Densities                        *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWPFIP[p][PAR] - (RHOP1^2/RHOP0)] == 0,
  TestID -> "GWPFIP-01-Definition", MetaInformation -> STR03
]
VerificationTest[
  Simplify[GWPIPEP[p][PAR] - ((V2*HBAR^2/4)*(RHOP1^2/RHOP0))] == 0,
  TestID -> "GWPIPEP-01-Definition", MetaInformation -> STR03
]
VerificationTest[
  Simplify[GWPCPEP[p][PAR] - ((V0 + V1*XP + V2*XP^2)*RHOP0)] == 0,
  TestID -> "GWPCPEP-01-Definition", MetaInformation -> STR06
]
VerificationTest[
  FullSimplify[GWPTPEP[p][PAR] - (GWPCPEP[p][PAR] + GWPIPEP[p][PAR])] == 0,
  TestID -> "GWPTPEP-01-Decomposition"
]
VerificationTest[
  Simplify[GWPTEDP[p][PAR] - (GWPTKEP[p][PAR] + GWPTPEP[p][PAR])] == 0,
  TestID -> "GWPTEDP-01-Decomposition"
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
