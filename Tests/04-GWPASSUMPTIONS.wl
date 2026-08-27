(* ::Package:: *)

(* ========================================================================= *)
(* TEST SUITE  : GWPTools (Version 1.0.0)                                    *)
(* FILE        : 04-GWPASSUMPTIONS.wl                                        *)
(* DESCRIPTION : Tests Parameters section of GWPDeveloper.wl                 *)
(* ========================================================================= *)

(* Load the Master Test Environment *)
Needs["GWPTools`GWPDiagnostics`"]

(* ========================================================== *)
(* DEFINITIONS AND METADATA STRINGS                           *)
(* ========================================================== *)

ToExpression[DEF01 = "PAR=Sequence[RA2,IA2,RX2,RP2,RG2,IG2,NORM,HBAR,MASS,{V0,V1,V2},{RA1,IA1,RX1,IX1,RP1,IP1,RG1,IG1}]"];
ToExpression[DEF02 = "OPT=Sequence[\"Position\"->x,\"Momentum\"->p,\"Energy\"->e,\"Time\"->t,\"Cumulative\"->c]"];
ToExpression[DEF03 = "NUM=Sequence[1/4, -1, 2, 5, 2, -1, 1/(E*(2*Pi)^(1/4)), 1, 1, {0, 0, 0}, {1/4, -1, 2, 0, 5, 0, 2, -1}]"];

ToExpression[STR01 = "COND01=Element[RA1|IA1|RX1|IX1|RP1|IP1|RG1|IG1,Reals]"];
ToExpression[STR02 = "COND02=Element[HBAR|MASS|V0|V1|V2,Reals]"];
ToExpression[STR03 = "COND03=Element[x|p|t|e|c,Reals]"];
ToExpression[STR04 = "COND04=0<e"];
ToExpression[STR05 = "COND05=0<c<1"];
ToExpression[STR06 = "COND06=UX>0"];
ToExpression[STR07 = "COND07=Element[UX|COVXP,Reals]"];
ToExpression[STR08 = "COND08=Element[UX|UP,Reals]"];
ToExpression[STR09 = "COND09=UX UP>=HBAR/2&&UP>0&&UX>0"];
ToExpression[STR10 = "COND10=Element[S,Reals]"];
ToExpression[STR11 = "COND11=Element[PHI|WT,Reals]"];
ToExpression[STR12 = "COND12=Element[EN|TT,Reals]"];

(* New conditions for the Maslov Index and IntegerVariables option *)
ToExpression[STR13 = "COND13=Element[MU,Reals]"];
ToExpression[STR14 = "COND14=Element[MU,Integers]"];

(* ========================================================== *)
(* ASSUMPTIONS ENGINE VERIFICATION TESTS                      *)
(* ========================================================== *)

(* Base definitions metadata *)
VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF01]
VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF02]

VerificationTest[
  Simplify[COND01, GWPASSUMPTIONS[PAR, OPT]], 
  TestID -> "GWPASSUMPTIONS-01-Variables", MetaInformation -> STR01
]

VerificationTest[
  Simplify[COND02, GWPASSUMPTIONS[PAR, OPT]], 
  TestID -> "GWPASSUMPTIONS-02-Parameters", MetaInformation -> STR02
]

VerificationTest[
  Simplify[COND03, GWPASSUMPTIONS[PAR, OPT]], 
  TestID -> "GWPASSUMPTIONS-03-Opts", MetaInformation -> STR03
]

VerificationTest[
  Simplify[COND04, GWPASSUMPTIONS[PAR, OPT]], 
  TestID -> "GWPASSUMPTIONS-04-e", MetaInformation -> STR04
]

VerificationTest[
  Simplify[COND05, GWPASSUMPTIONS[PAR, OPT]], 
  TestID -> "GWPASSUMPTIONS-05-c", MetaInformation -> STR05
]

VerificationTest[
  Simplify[COND06, GWPASSUMPTIONS@GWPPARAM[{"Covariance", UX, COVXP}]], 
  TestID -> "GWPASSUMPTIONS-06-UX", MetaInformation -> STR06
]

VerificationTest[
  Simplify[COND07, GWPASSUMPTIONS@GWPPARAM[{"Covariance", UX, COVXP}]], 
  TestID -> "GWPASSUMPTIONS-07-UX-COVXP", MetaInformation -> STR07
]

VerificationTest[
  Simplify[COND08, GWPASSUMPTIONS@GWPPARAM[{"Uncertainty", UX, UP, 1}]], 
  TestID -> "GWPASSUMPTIONS-08-UX-UP", MetaInformation -> STR08
]

VerificationTest[
  Simplify[COND09, GWPASSUMPTIONS@GWPPARAM[{"Uncertainty", UX, UP, 1}, "HBAR" -> HBAR]], 
  TestID -> "GWPASSUMPTIONS-09-Uncertainty", MetaInformation -> STR09
]

VerificationTest[
  Simplify[COND10, GWPASSUMPTIONS@GWPPARAM[1/4, 0, 0, {"Action", S}]], 
  TestID -> "GWPASSUMPTIONS-10-Action", MetaInformation -> STR10
]

VerificationTest[
  Simplify[COND11, GWPASSUMPTIONS@GWPPARAM[1/4, 0, 0, {"Coefficient", PHI, WT}]], 
  TestID -> "GWPASSUMPTIONS-11-PhaseAmp", MetaInformation -> STR11
]

VerificationTest[
  Simplify[COND12, GWPASSUMPTIONS@GWPPARAM[1/4, 0, 0, {"Evolution", EN, TT}]], 
  TestID -> "GWPASSUMPTIONS-12-EnergyTime", MetaInformation -> STR12
]

(* ---------------------------------------------------------- *)
(* NEW TESTS: Maslov Index & Integer Option                   *)
(* ---------------------------------------------------------- *)

VerificationTest[
  Simplify[COND13, GWPASSUMPTIONS@GWPPARAM[1/4, 0, 0, {"Action", S, MU}]], 
  TestID -> "GWPASSUMPTIONS-13-MaslovReal", MetaInformation -> STR13
]

VerificationTest[
  Simplify[COND14, GWPASSUMPTIONS[GWPPARAM[1/4, 0, 0, {"Action", S, MU}], "IntegerVariables" -> MU]], 
  TestID -> "GWPASSUMPTIONS-14-MaslovInteger", MetaInformation -> STR14
]

(* ---------------------------------------------------------- *)
(* Numeric testing metadata                                   *)
(* ---------------------------------------------------------- *)

VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF03]

VerificationTest[
  GWPASSUMPTIONS@NUM, 
  TestID -> "GWPASSUMPTIONS-15-NumericFallback"
]

VerificationTest[
  GWPASSUMPTIONS[NUM, "RP2Sign" -> -1], 
  $Failed, 
  {GWPASSUMPTIONS::rp2conflict}, 
  TestID -> "GWPASSUMPTIONS-16-RP2Conflict"
]

(* ========================================================== *)
(* CLEANUP: PREVENT NAMESPACE POLLUTION                       *)
(* ========================================================== *)

(* Clear dynamically generated strings so MetaInformation renders properly *)
ClearAll["DEF*"];
ClearAll["STR*"];
ClearAll["COND*"];

(* Clear the sequence parameters and option definitions *)
ClearAll[PAR, OPT, NUM];

(* Clear all abstract symbolic variables used throughout the tests *)
ClearAll[RA2, IA2, RX2, RP2, RG2, IG2, NORM, HBAR, MASS, V0, V1, V2];
ClearAll[RA1, IA1, RX1, IX1, RP1, IP1, RG1, IG1];
ClearAll[x, p, e, t, c, UX, COVXP, UP, S, PHI, WT, EN, TT, MU];
