(* ::Package:: *)

(* ========================================================================= *)
(* TEST SUITE  : GWPTools (Version 1.0.0)                                    *)
(* FILE        : 1D-MATH-EXPECTATION.wl                                      *)
(* DESCRIPTION : Tests ExpectionValues section of GWPEngine1D.wl             *)
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
ToExpression[DEF02 = "$Assumptions=GWP1DASSUMPTIONS[PAR,\"Position\"->x,\"Momentum\"->p]"];

ToExpression[STR01 = "RHOX0=GWP1DRHOX[x][PAR]"];
ToExpression[STR02 = "RHOP0=GWP1DRHOP[p][PAR]"];
ToExpression[STR03 = "CSIX0=GWP1DCSIX[x][PAR]"];
ToExpression[STR04 = "PSIX0=GWP1DPSIX[x][PAR]"];
ToExpression[STR05 = "PSIX1=GWP1DPSIX[1][x][PAR]"];
ToExpression[STR06 = "PSIX2=GWP1DPSIX[2][x][PAR]"];
ToExpression[STR07 = "PSIX4=GWP1DPSIX[4][x][PAR]"];
ToExpression[STR08 = "PEX0=GWP1DPEX[x][PAR]"];
ToExpression[STR09 = "FEX0=GWP1DFEX[x][PAR]"];
ToExpression[STR10 = "LEGX=Through[{GWP1DEX1,GWP1DEX2,GWP1DEX3,GWP1DEX4}[PAR]]"];
ToExpression[STR11 = "LEGP=Through[{GWP1DEP1,GWP1DEP2,GWP1DEP3,GWP1DEP4}[PAR]]"];

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
  And @@ Table[Simplify[GWP1DEX[n][PAR] - Integrate[x^n*RHOX0, {x, -Infinity, Infinity}]] == 0, {n, 0, 6}],
  TestID -> "GWP1DEX-01-ArbitraryMoments", MetaInformation -> STR01
]
(*
VerificationTest[
  Simplify[Through[Table[GWP1DEX[n], {n, 4}][PAR]] - LEGX] == {0, 0, 0, 0},
  TestID -> "GWP1DEX-02-LegacyWrappers", MetaInformation -> STR10
]
*)
VerificationTest[
  Simplify[GWP1DUX[PAR]^2 - (GWP1DEX[2][PAR] - GWP1DEX[1][PAR]^2)] == 0,
  TestID -> "GWP1DUX-01-Uncertainty"
]

(* ---------------------------------------------------------- *)
(* 3. Momentum Moments and Uncertainty                        *)
(* ---------------------------------------------------------- *)
VerificationTest[
  And @@ Table[Simplify[GWP1DEP[n][PAR] - Integrate[p^n*RHOP0, {p, -Infinity, Infinity}]] == 0, {n, 0, 6}],
  TestID -> "GWP1DEP-01-ArbitraryMoments", MetaInformation -> STR02
]
(*
VerificationTest[
  Simplify[Through[Table[GWP1DEP[n], {n, 4}][PAR]] - LEGP] == {0, 0, 0, 0},
  TestID -> "GWP1DEP-02-LegacyWrappers", MetaInformation -> STR11
]
*)
VerificationTest[
  Simplify[GWP1DUP[PAR]^2 - (GWP1DEP[2][PAR] - GWP1DEP[1][PAR]^2)] == 0,
  TestID -> "GWP1DUP-01-Uncertainty"
]

(* ---------------------------------------------------------- *)
(* 4. Cross-Terms and Correlation                             *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWP1DEXP[PAR] - Integrate[CSIX0*x*(-I*HBAR*PSIX1), {x, -Infinity, Infinity}]] == 0,
  TestID -> "GWP1DEXP-01-Operator", MetaInformation -> STR03 <> "\\n" <> STR05
]
VerificationTest[
  Simplify[GWP1DEPX[PAR] - Integrate[CSIX0*(-I*HBAR)*(PSIX0 + x*PSIX1), {x, -Infinity, Infinity}]] == 0,
  TestID -> "GWP1DEPX-01-Operator", MetaInformation -> STR04
]
VerificationTest[
  Simplify[GWP1DCOVXP[PAR] - ((1/2)*(GWP1DEXP[PAR] + GWP1DEPX[PAR]) - GWP1DEX[1][PAR]*GWP1DEP[1][PAR])] == 0,
  TestID -> "GWP1DCOVXP-01-Definition"
]
VerificationTest[
  Simplify[GWP1DCORXP[PAR] - (GWP1DCOVXP[PAR]/(GWP1DUX[PAR]*GWP1DUP[PAR]))] == 0,
  TestID -> "GWP1DCORXP-01-Definition"
]

(* ---------------------------------------------------------- *)
(* 5. Kinetic Energy Operators                                *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWP1DEKE[1][PAR] - Integrate[CSIX0*(-HBAR^2/(2*MASS))*PSIX2, {x, -Infinity, Infinity}]] == 0,
  TestID -> "GWP1DEKE1-01-Expectation", MetaInformation -> STR06
]
VerificationTest[
  Simplify[GWP1DEKE[2][PAR] - Integrate[CSIX0*(HBAR^4/(4*MASS^2))*PSIX4, {x, -Infinity, Infinity}]] == 0,
  TestID -> "GWP1DEKE2-01-Expectation", MetaInformation -> STR07
]
VerificationTest[
  Simplify[GWP1DUKE[PAR]^2 - (GWP1DEKE[2][PAR] - GWP1DEKE[1][PAR]^2)] == 0,
  TestID -> "GWP1DUKE-01-Uncertainty"
]

(* ---------------------------------------------------------- *)
(* 6. Potential Energy and Force                              *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWP1DEPE[1][PAR] - Integrate[PEX0*RHOX0, {x, -Infinity, Infinity}]] == 0,
  TestID -> "GWP1DEPE1-01-Expectation", MetaInformation -> STR08
]
VerificationTest[
  Simplify[GWP1DEF1[PAR] - Integrate[FEX0*RHOX0, {x, -Infinity, Infinity}]] == 0,
  TestID -> "GWP1DEF1-01-Expectation", MetaInformation -> STR09
]
VerificationTest[
  Simplify[GWP1DEPE[2][PAR] - Integrate[PEX0^2*RHOX0, {x, -Infinity, Infinity}]] == 0,
  TestID -> "GWP1DEPE2-01-Expectation"
]
VerificationTest[
  Simplify[GWP1DEF2[PAR] - Integrate[FEX0^2*RHOX0, {x, -Infinity, Infinity}]] == 0,
  TestID -> "GWP1DEF2-01-Expectation"
]
VerificationTest[
  Simplify[GWP1DUPE[PAR]^2 - (GWP1DEPE[2][PAR] - GWP1DEPE[1][PAR]^2)] == 0,
  TestID -> "GWP1DUPE-01-Uncertainty"
]
VerificationTest[
  Simplify[GWP1DUF[PAR]^2 - (GWP1DEF2[PAR] - GWP1DEF1[PAR]^2)] == 0,
  TestID -> "GWP1DUF-01-Uncertainty"
]

(* ---------------------------------------------------------- *)
(* 7. Kinetic-Potential Cross-Terms                           *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWP1DEPEKE[PAR] - Integrate[CSIX0*PEX0*(-HBAR^2/(2*MASS))*PSIX2, {x, -Infinity, Infinity}]] == 0,
  TestID -> "GWP1DEPEKE-01-Operator"
]
VerificationTest[
  Simplify[GWP1DEKEPE[PAR] - Integrate[CSIX0*(-HBAR^2/(2*MASS))*D[PEX0*PSIX0, {x, 2}], {x, -Infinity, Infinity}]] == 0,
  TestID -> "GWP1DEKEPE-01-Operator"
]
VerificationTest[
  Simplify[GWP1DCOVKEPE[PAR] - ((1/2)*(GWP1DEKEPE[PAR] + GWP1DEPEKE[PAR]) - GWP1DEKE[1][PAR]*GWP1DEPE[1][PAR])] == 0,
  TestID -> "GWP1DCOVKEPE-01-Definition"
]
VerificationTest[
  FullSimplify[GWP1DCORKEPE[PAR] - (GWP1DCOVKEPE[PAR]/(GWP1DUKE[PAR]*GWP1DUPE[PAR]))] == 0,
  TestID -> "GWP1DCORKEPE-01-Definition"
]

(* ---------------------------------------------------------- *)
(* 8. Total Energy (Hamiltonian)                              *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWP1DETE[1][PAR] - (GWP1DEKE[1][PAR] + GWP1DEPE[1][PAR])] == 0,
  TestID -> "GWP1DETE1-01-Definition"
]
VerificationTest[
  Simplify[GWP1DETE[2][PAR] - (GWP1DEKE[2][PAR] + GWP1DEPE[2][PAR] + GWP1DEKEPE[1,1][PAR] + GWP1DEPEKE[1,1][PAR])] == 0,
  TestID -> "GWP1DETE2-01-Definition"
]
VerificationTest[
  Simplify[GWP1DUTE[PAR]^2 - (GWP1DETE[2][PAR] - GWP1DETE[1][PAR]^2)] == 0,
  TestID -> "GWP1DUTE-01-Uncertainty"
]
(*
(* ---------------------------------------------------------- *)
(* 9. Hydrodynamic Expectation Values & Energy Decomposition  *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWP1DEFIX[PAR] - Integrate[GWP1DFIX[x]@PAR, {x, -Infinity, Infinity}]] == 0,
  TestID -> "GWP1DEFIX-01-Expectation"
]
VerificationTest[
  Simplify[GWP1DEIKE[PAR] - Integrate[GWP1DIKEX[x]@PAR, {x, -Infinity, Infinity}]] == 0,
  TestID -> "GWP1DEIKE-01-Expectation"
]
VerificationTest[
  Simplify[GWP1DECKE[PAR] - Integrate[GWP1DCKEX[x]@PAR, {x, -Infinity, Infinity}]] == 0,
  TestID -> "GWP1DECKE-01-Expectation"
]
VerificationTest[
  Simplify[GWP1DEFIP[PAR] - Integrate[GWP1DFIP[p]@PAR, {p, -Infinity, Infinity}]] == 0,
  TestID -> "GWP1DEFIP-01-Expectation"
]
VerificationTest[
  Simplify[GWP1DEIPE[PAR] - Integrate[GWP1DIPEP[p]@PAR, {p, -Infinity, Infinity}]] == 0,
  TestID -> "GWP1DEIPE-01-Expectation"
]
VerificationTest[
  Simplify[GWP1DECPE[PAR] - Integrate[GWP1DCPEP[p]@PAR, {p, -Infinity, Infinity}]] == 0,
  TestID -> "GWP1DECPE-01-Expectation"
]
VerificationTest[
  Simplify[GWP1DEKE[1][PAR] - (GWP1DECKE[PAR] + GWP1DEIKE[PAR])] == 0,
  TestID -> "GWP1DHDECOMP-01-Kinetic"
]
VerificationTest[
  Simplify[GWP1DEPE[1][PAR] - (GWP1DECPE[PAR] + GWP1DEIPE[PAR])] == 0,
  TestID -> "GWP1DHDECOMP-02-Potential"
]
VerificationTest[
  Simplify[GWP1DETE[1][PAR] - (GWP1DECKE[PAR] + GWP1DEIKE[PAR] + GWP1DECPE[PAR] + GWP1DEIPE[PAR])] == 0,
  TestID -> "GWP1DHDECOMP-03-Total"
]
*)
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
