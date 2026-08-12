(* ::Package:: *)

Needs["GWPTools`"]

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
(* ToExpression[DEF01="PAR=GWPPARAM[RA+I*IA,RX+I*IX,RP+I*IP,RG+I*IG,\"HBAR\"->HBAR,\"MASS\"->MASS]"]; *)

(* Evaluates and sets the global assumptions natively *)
ToExpression[DEF02 = "$Assumptions=GWPASSUMPTIONS[PAR,\"Position\"->x]"];

ToExpression[STR01 = "PSIX0=GWPPSIX[x][PAR]"];
ToExpression[STR02 = "RHOX0=GWPRHOX[x][PAR]"];
ToExpression[STR03 = "RHOX1=GWPRHOX[1][x][PAR]"];
ToExpression[STR04 = "RHOX2=GWPRHOX[2][x][PAR]"];

ToExpression[STR05 = "SX=GWPSX[x][PAR]"];
ToExpression[STR06 = "VX=GWPVX[x][PAR]"];
ToExpression[STR07 = "QPX=GWPQPX[x][PAR]"];

(* ========================================================== *)
(* HYDRODYNAMIC VERIFICATION TESTS (POSITION SPACE)           *)
(* ========================================================== *)

VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF01]
VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF02]

(* ---------------------------------------------------------- *)
(* 1. Amplitude, Phase, and Mappings                          *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWPAX[x][PAR] - Sqrt[RHOX0]] == 0,
  TestID -> "GWPAX-01-Definition", MetaInformation -> STR02
]
VerificationTest[
  Simplify[Exp[I/HBAR*GWPSX[x][PAR]] - (PSIX0/GWPAX[x][PAR])] == 0,
  TestID -> "GWPSX-01-Definition", MetaInformation -> STR01
]
VerificationTest[
  Simplify[GWPPX[x][PAR] - D[SX, x]] == 0,
  TestID -> "GWPPX-01-Definition", MetaInformation -> STR05
]

(* ---------------------------------------------------------- *)
(* 2. Flow Velocities and Current                             *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWPVX[x][PAR] - (D[SX, x]/MASS)] == 0,
  TestID -> "GWPVX-01-Definition", MetaInformation -> STR05
]
VerificationTest[
  Simplify[GWPOVX[x][PAR] - ((HBAR/(2*MASS))*(RHOX1/RHOX0))] == 0,
  TestID -> "GWPOVX-01-Definition", MetaInformation -> STR03
]
VerificationTest[
  Simplify[GWPJX[x][PAR] - (VX*RHOX0)] == 0,
  TestID -> "GWPJX-01-Definition", MetaInformation -> STR06
]

(* ---------------------------------------------------------- *)
(* 3. Quantum Potential, Force, and Stress                    *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWPQPX[x][PAR] - (-HBAR^2/(2*MASS)*(D[GWPAX[x][PAR], {x, 2}]/GWPAX[x][PAR]))] == 0,
  TestID -> "GWPQPX-01-Definition"
]
VerificationTest[
  Simplify[GWPQFX[x][PAR] - (-D[QPX, x])] == 0,
  TestID -> "GWPQFX-01-Definition", MetaInformation -> STR07
]
VerificationTest[
  Simplify[GWPQSX[x][PAR] - (HBAR^2/(4*MASS)*(RHOX2 - RHOX1^2/RHOX0))] == 0,
  TestID -> "GWPQSX-01-Definition", MetaInformation -> STR04
]

(* ---------------------------------------------------------- *)
(* 4. Information and Energy Densities                        *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWPFIX[x][PAR] - (RHOX1^2/RHOX0)] == 0,
  TestID -> "GWPFIX-01-Definition", MetaInformation -> STR03
]
VerificationTest[
  Simplify[GWPIKEX[x][PAR] - (HBAR^2/(8*MASS)*RHOX1^2/RHOX0)] == 0,
  TestID -> "GWPIKEX-01-Definition", MetaInformation -> STR03
]
VerificationTest[
  Simplify[GWPCKEX[x][PAR] - ((1/2)*MASS*(VX^2)*RHOX0)] == 0,
  TestID -> "GWPCKEX-01-Definition", MetaInformation -> STR06
]
VerificationTest[
  Simplify[GWPTKEX[x][PAR] - (GWPCKEX[x][PAR] + GWPIKEX[x][PAR])] == 0,
  TestID -> "GWPTKEX-01-Decomposition"
]
VerificationTest[
  Simplify[GWPTPEX[x][PAR] - (GWPPEX[x][PAR]*RHOX0)] == 0,
  TestID -> "GWPTPEX-01-Definition", MetaInformation -> STR02
]
VerificationTest[
  Simplify[GWPTEDX[x][PAR] - (GWPTKEX[x][PAR] + GWPTPEX[x][PAR])] == 0,
  TestID -> "GWPTEDX-01-Decomposition"
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
