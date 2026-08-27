(* ::Package:: *)

(* ========================================================================= *)
(* TEST SUITE  : GWPTools (Version 1.0.0)                                    *)
(* FILE        : 11-GWPEXPECTATION.wl                                        *)
(* DESCRIPTION : Tests ExpectionValues & Energies section of GWPDeveloper.wl *)
(* ========================================================================= *)

(* Load the Master Test Environment *)
Needs["GWPTools`GWPDiagnostics`"]

(* ========================================================== *)
(* DEFINITIONS AND CONFIGURATION                              *)
(* ========================================================== *)

(* Save the user's current global assumptions before modifying them *)
$userAssumptions = $Assumptions;

(* Optimized Parameter Sequence injecting {V0,V1,V2} to prevent zero-variance singularities in PE correlations *)
ToExpression[DEF01 = "PAR=Sequence[RA,IA,RX,RP,RG,IG,E^(IG/HBAR)*(2/Pi)^(1/4)*RA^(1/4),HBAR,MASS,{V0,V1,V2},{RA,IA,RX,0,RP,0,RG,IG}]"];
(* General parameter sequence *)
(*
ToExpression[DEF01 = "PAR=Sequence@@{RA, IA, -1/2*(IP + 2*HBAR*IA*IX)/(HBAR*RA) + RX, (IA*(IP + 2*HBAR*IA*IX))/RA + 2*HBAR*IX*RA + RP, 
 -1/4*(4*HBAR*IA^2*IP*IX + 4*HBAR^2*IA^3*IX^2 + 2*RA*(-2*HBAR*RA*RG + IP*RP) + IA*(IP^2 + 4*HBAR*IX*RA*(HBAR*IX*RA + RP)))/(HBAR*RA^2), 
 -1/4*(IP^2 + 4*HBAR*IA*IP*IX + 4*HBAR*(-(IG*RA) + HBAR*IX^2*(IA^2 + RA^2) + IX*RA*RP))/(HBAR*RA), 
 ((2/Pi)^(1/4)*RA^(1/4))/E^((IP^2 + 4*HBAR*IA*IP*IX + 4*HBAR*(-(IG*RA) + HBAR*IX^2*(IA^2 + RA^2) + IX*RA*RP))/(4*HBAR^2*RA)), HBAR, MASS, {V0, V1, V2}, 
 {RA, IA, RX, IX, RP, IP, RG, IG}}"];
 *)
ToExpression[DEF02 = "$Assumptions=GWPASSUMPTIONS[PAR,\"Position\"->x,\"Momentum\"->p]"];

ToExpression[STR01 = "RHOX0=GWPRHOX[x][PAR]"];
ToExpression[STR02 = "RHOP0=GWPRHOP[p][PAR]"];
ToExpression[STR03 = "CSIX0=GWPCSIX[x][PAR]"];
ToExpression[STR04 = "PSIX0=GWPPSIX[x][PAR]"];
ToExpression[STR05 = "PSIX1=GWPPSIX[1][x][PAR]"];
ToExpression[STR06 = "PSIX2=GWPPSIX[2][x][PAR]"];
ToExpression[STR07 = "PSIX4=GWPPSIX[4][x][PAR]"];
ToExpression[STR08 = "PEX0=GWPPEX[x][PAR]"];
ToExpression[STR09 = "FEX0=GWPFEX[x][PAR]"];
ToExpression[STR10 = "LEGX=Through[{GWPEX1,GWPEX2,GWPEX3,GWPEX4}[PAR]]"];
ToExpression[STR11 = "LEGP=Through[{GWPEP1,GWPEP2,GWPEP3,GWPEP4}[PAR]]"];

(* ========================================================== *)
(* EXPECTATION VALUE VERIFICATION TESTS                       *)
(* ========================================================== *)

(* 1. Definitions tests *)

VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF01]
VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF02]

(* ---------------------------------------------------------- *)
(* 2. Position Moments and Uncertainty                        *)
(* ---------------------------------------------------------- *)
VerificationTest[
  And @@ Table[Simplify[GWPEX[n][PAR] - Integrate[x^n*RHOX0, {x, -Infinity, Infinity}]] == 0, {n, 0, 6}],
  TestID -> "GWPEX-01-ArbitraryMoments", MetaInformation -> STR01
]
(*
VerificationTest[
  Simplify[Through[Table[GWPEX[n], {n, 4}][PAR]] - LEGX] == {0, 0, 0, 0},
  TestID -> "GWPEX-02-LegacyWrappers", MetaInformation -> STR10
]
*)
VerificationTest[
  Simplify[GWPUX[PAR]^2 - (GWPEX[2][PAR] - GWPEX[1][PAR]^2)] == 0,
  TestID -> "GWPUX-01-Uncertainty"
]

(* ---------------------------------------------------------- *)
(* 3. Momentum Moments and Uncertainty                        *)
(* ---------------------------------------------------------- *)
VerificationTest[
  And @@ Table[Simplify[GWPEP[n][PAR] - Integrate[p^n*RHOP0, {p, -Infinity, Infinity}]] == 0, {n, 0, 6}],
  TestID -> "GWPEP-01-ArbitraryMoments", MetaInformation -> STR02
]
(*
VerificationTest[
  Simplify[Through[Table[GWPEP[n], {n, 4}][PAR]] - LEGP] == {0, 0, 0, 0},
  TestID -> "GWPEP-02-LegacyWrappers", MetaInformation -> STR11
]
*)
VerificationTest[
  Simplify[GWPUP[PAR]^2 - (GWPEP[2][PAR] - GWPEP[1][PAR]^2)] == 0,
  TestID -> "GWPUP-01-Uncertainty"
]

(* ---------------------------------------------------------- *)
(* 4. Cross-Terms and Correlation                             *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWPEXP[PAR] - Integrate[CSIX0*x*(-I*HBAR*PSIX1), {x, -Infinity, Infinity}]] == 0,
  TestID -> "GWPEXP-01-Operator", MetaInformation -> STR03 <> "\\n" <> STR05
]
VerificationTest[
  Simplify[GWPEPX[PAR] - Integrate[CSIX0*(-I*HBAR)*(PSIX0 + x*PSIX1), {x, -Infinity, Infinity}]] == 0,
  TestID -> "GWPEPX-01-Operator", MetaInformation -> STR04
]
VerificationTest[
  Simplify[GWPCOVXP[PAR] - ((1/2)*(GWPEXP[PAR] + GWPEPX[PAR]) - GWPEX[1][PAR]*GWPEP[1][PAR])] == 0,
  TestID -> "GWPCOVXP-01-Definition"
]
VerificationTest[
  Simplify[GWPCORXP[PAR] - (GWPCOVXP[PAR]/(GWPUX[PAR]*GWPUP[PAR]))] == 0,
  TestID -> "GWPCORXP-01-Definition"
]

(* ---------------------------------------------------------- *)
(* 5. Kinetic Energy Operators                                *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWPEKE[1][PAR] - Integrate[CSIX0*(-HBAR^2/(2*MASS))*PSIX2, {x, -Infinity, Infinity}]] == 0,
  TestID -> "GWPEKE1-01-Expectation", MetaInformation -> STR06
]
VerificationTest[
  Simplify[GWPEKE[2][PAR] - Integrate[CSIX0*(HBAR^4/(4*MASS^2))*PSIX4, {x, -Infinity, Infinity}]] == 0,
  TestID -> "GWPEKE2-01-Expectation", MetaInformation -> STR07
]
VerificationTest[
  Simplify[GWPUKE[PAR]^2 - (GWPEKE[2][PAR] - GWPEKE[1][PAR]^2)] == 0,
  TestID -> "GWPUKE-01-Uncertainty"
]

(* ---------------------------------------------------------- *)
(* 6. Potential Energy and Force                              *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWPEPE[1][PAR] - Integrate[PEX0*RHOX0, {x, -Infinity, Infinity}]] == 0,
  TestID -> "GWPEPE1-01-Expectation", MetaInformation -> STR08
]
VerificationTest[
  Simplify[GWPEF1[PAR] - Integrate[FEX0*RHOX0, {x, -Infinity, Infinity}]] == 0,
  TestID -> "GWPEF1-01-Expectation", MetaInformation -> STR09
]
VerificationTest[
  Simplify[GWPEPE[2][PAR] - Integrate[PEX0^2*RHOX0, {x, -Infinity, Infinity}]] == 0,
  TestID -> "GWPEPE2-01-Expectation"
]
VerificationTest[
  Simplify[GWPEF2[PAR] - Integrate[FEX0^2*RHOX0, {x, -Infinity, Infinity}]] == 0,
  TestID -> "GWPEF2-01-Expectation"
]
VerificationTest[
  Simplify[GWPUPE[PAR]^2 - (GWPEPE[2][PAR] - GWPEPE[1][PAR]^2)] == 0,
  TestID -> "GWPUPE-01-Uncertainty"
]
VerificationTest[
  Simplify[GWPUF[PAR]^2 - (GWPEF2[PAR] - GWPEF1[PAR]^2)] == 0,
  TestID -> "GWPUF-01-Uncertainty"
]

(* ---------------------------------------------------------- *)
(* 7. Kinetic-Potential Cross-Terms                           *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWPEPEKE[PAR] - Integrate[CSIX0*PEX0*(-HBAR^2/(2*MASS))*PSIX2, {x, -Infinity, Infinity}]] == 0,
  TestID -> "GWPEPEKE-01-Operator"
]
VerificationTest[
  Simplify[GWPEKEPE[PAR] - Integrate[CSIX0*(-HBAR^2/(2*MASS))*D[PEX0*PSIX0, {x, 2}], {x, -Infinity, Infinity}]] == 0,
  TestID -> "GWPEKEPE-01-Operator"
]
VerificationTest[
  Simplify[GWPCOVKEPE[PAR] - ((1/2)*(GWPEKEPE[PAR] + GWPEPEKE[PAR]) - GWPEKE[1][PAR]*GWPEPE[1][PAR])] == 0,
  TestID -> "GWPCOVKEPE-01-Definition"
]
VerificationTest[
  FullSimplify[GWPCORKEPE[PAR] - (GWPCOVKEPE[PAR]/(GWPUKE[PAR]*GWPUPE[PAR]))] == 0,
  TestID -> "GWPCORKEPE-01-Definition"
]

(* ---------------------------------------------------------- *)
(* 8. Total Energy (Hamiltonian)                              *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWPETE[1][PAR] - (GWPEKE[1][PAR] + GWPEPE[1][PAR])] == 0,
  TestID -> "GWPETE1-01-Definition"
]
VerificationTest[
  Simplify[GWPETE[2][PAR] - (GWPEKE[2][PAR] + GWPEPE[2][PAR] + GWPEKEPE[1,1][PAR] + GWPEPEKE[1,1][PAR])] == 0,
  TestID -> "GWPETE2-01-Definition"
]
VerificationTest[
  Simplify[GWPUTE[PAR]^2 - (GWPETE[2][PAR] - GWPETE[1][PAR]^2)] == 0,
  TestID -> "GWPUTE-01-Uncertainty"
]

(* ---------------------------------------------------------- *)
(* 9. Hydrodynamic Expectation Values & Energy Decomposition  *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWPEFIX[PAR] - Integrate[GWPFIX[x]@PAR, {x, -Infinity, Infinity}]] == 0,
  TestID -> "GWPEFIX-01-Expectation"
]
VerificationTest[
  Simplify[GWPEIKE[PAR] - Integrate[GWPIKEX[x]@PAR, {x, -Infinity, Infinity}]] == 0,
  TestID -> "GWPEIKE-01-Expectation"
]
VerificationTest[
  Simplify[GWPECKE[PAR] - Integrate[GWPCKEX[x]@PAR, {x, -Infinity, Infinity}]] == 0,
  TestID -> "GWPECKE-01-Expectation"
]
VerificationTest[
  Simplify[GWPEFIP[PAR] - Integrate[GWPFIP[p]@PAR, {p, -Infinity, Infinity}]] == 0,
  TestID -> "GWPEFIP-01-Expectation"
]
VerificationTest[
  Simplify[GWPEIPE[PAR] - Integrate[GWPIPEP[p]@PAR, {p, -Infinity, Infinity}]] == 0,
  TestID -> "GWPEIPE-01-Expectation"
]
VerificationTest[
  Simplify[GWPECPE[PAR] - Integrate[GWPCPEP[p]@PAR, {p, -Infinity, Infinity}]] == 0,
  TestID -> "GWPECPE-01-Expectation"
]
VerificationTest[
  Simplify[GWPEKE[1][PAR] - (GWPECKE[PAR] + GWPEIKE[PAR])] == 0,
  TestID -> "GWPHDECOMP-01-Kinetic"
]
VerificationTest[
  Simplify[GWPEPE[1][PAR] - (GWPECPE[PAR] + GWPEIPE[PAR])] == 0,
  TestID -> "GWPHDECOMP-02-Potential"
]
VerificationTest[
  Simplify[GWPETE[1][PAR] - (GWPECKE[PAR] + GWPEIKE[PAR] + GWPECPE[PAR] + GWPEIPE[PAR])] == 0,
  TestID -> "GWPHDECOMP-03-Total"
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

(* Clear the parameter sequence and wavefunction/expectation proxies *)
ClearAll[PAR, RHOX0, RHOP0, CSIX0, PSIX0, PSIX1, PSIX2, PSIX4, PEX0, FEX0, LEGX, LEGP];

(* Clear the abstract symbolic variables, coordinates, and iterators used in the tests *)
ClearAll[RA, IA, RX, RP, RG, IG, HBAR, MASS, V0, V1, V2, x, p, n];
