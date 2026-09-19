(* ::Package:: *)

(* ========================================================================= *)
(* TEST SUITE  : GWPTools (Version 1.0.0)                                    *)
(* FILE        : 1D-HYDRO-EXPECTATION.wl                                     *)
(* DESCRIPTION : Tests Expection values section of GWPHydrodynamics1D.wl     *)
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

(* 1. Definitions tests *)

VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF01]
VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF02]

(* ---------------------------------------------------------- *)
(* Hydrodynamic Expectation Values & Energy Decomposition  *)
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
