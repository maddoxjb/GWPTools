(* ::Package:: *)

(* ========================================================================= *)
(* TEST SUITE  : GWPTools (Version 1.0.0)                                    *)
(* FILE        : 03-GWPPARSE.wl                                              *)
(* DESCRIPTION : Tests Parameters section of GWPDeveloper.wl                 *)
(* ========================================================================= *)

(* Load the Master Test Environment *)
Needs["GWPTools`GWPDiagnostics`"]

(* ========================================================== *)
(* DEFINITIONS AND METADATA STRINGS                           *)
(* ========================================================== *)

(* Shape Parser Strings *)
ToExpression[STR0 = "ARG1=Sequence[HBAR,MASS]"];
ToExpression[STR1 = "RIA1={RA,IA}"];
ToExpression[STR2 = "RIA2={1/(4*UX^2),0}"];
ToExpression[STR3 = "RIA3={1/(4*UX^2),-1/2*COVXP/(HBAR*UX^2)}"];
ToExpression[STR4 = "RIA4={1/(4*UX^2),+Sqrt[-1/16*1/UX^4+UP^2/(4*HBAR^2*UX^2)]}"];
ToExpression[STR5 = "RIA5={1/(4*UX^2),-Sqrt[-1/16*1/UX^4+UP^2/(4*HBAR^2*UX^2)]}"];

(* Position Parser Strings *)
ToExpression[STR12 = "RIX1={RX,IX}"];

(* Momentum Parser Strings *)
ToExpression[STR13 = "RIP1={RP,IP}"];
ToExpression[STR14 = "RIP2={Sqrt[2*MASS*EK],0}"];
ToExpression[STR15 = "RIP3={-Sqrt[2*MASS*EK],0}"];

(* Phase Parser Strings *)
ToExpression[STR0a = "ARG2=Sequence[HBAR,RA1,RX1,RP1]"];
ToExpression[STR6 = "RIG1={RG,IG}"];
ToExpression[STR7 = "RIG2={S,-HBAR/4*Log[2*RA1/Pi]}"];
ToExpression[STR8 = "RIG3={S-HBAR*MU*Pi/2,-HBAR/4*Log[2*RA1/Pi]}"];
ToExpression[STR9 = "RIG4={(RX1-X0)*(RP1-P0)/2,-HBAR/4*Log[2*RA1/Pi]}"];
ToExpression[STR10 = "RIG5={HBAR*PHI,-HBAR*Log[W]}"];
ToExpression[STR11 = "RIG6={-EN*TT,0}"];


(* ========================================================== *)
(* SHAPE PARSER VERIFICATION TESTS                           *)
(* ========================================================== *)

VerificationTest[
  True, 
  TestID -> "Definition", 
  MetaInformation -> STR0
]

VerificationTest[
  Simplify[GWPSHAPE[RA + I*IA, ARG1] - RIA1] == {0,0}, 
  TestID -> "GWPSHAPE-01-ReIm", 
  MetaInformation -> STR1
]

VerificationTest[
  Simplify[GWPSHAPE[{"Covariance", UX, 0}, ARG1] - RIA2] == {0,0}, 
  TestID -> "GWPSHAPE-02-UX-0", 
  MetaInformation -> STR2
]

VerificationTest[
  Simplify[GWPSHAPE[{"Covariance", UX, COVXP}, ARG1] - RIA3] == {0,0}, 
  TestID -> "GWPSHAPE-03-UX-COVXP", 
  MetaInformation -> STR3
]

VerificationTest[
  Simplify[GWPSHAPE[{"Uncertainty", UX, UP, 1}, ARG1] - RIA4] == {0,0}, 
  TestID -> "GWPSHAPE-04-UX-UP-posChirp", 
  MetaInformation -> STR4
]

VerificationTest[
  Simplify[GWPSHAPE[{"Uncertainty", UX, UP, -1}, ARG1] - RIA5] == {0,0}, 
  TestID -> "GWPSHAPE-05-UX-UP-negChirp", 
  MetaInformation -> STR5
]

VerificationTest[
  GWPSHAPE[{1, 2}, ARG1] === {$Failed, $Failed}, 
  True, 
  {GWPSHAPE::badform},
  TestID -> "GWPSHAPE-06-RawList-Fail"
]

VerificationTest[
  GWPSHAPE[{"Covariance", {UX}, COVXP}, ARG1] === {$Failed, $Failed}, 
  True, 
  {GWPSHAPE::badform},
  TestID -> "GWPSHAPE-07-NestedList-Fail"
]

(* ========================================================== *)
(* POSITION PARSER VERIFICATION TESTS                         *)
(* ========================================================== *)

VerificationTest[
  Simplify[GWPPOSITION[RX + I*IX] - RIX1] == {0,0}, 
  TestID -> "GWPPOSITION-01-ReIm", 
  MetaInformation -> STR12
]

VerificationTest[
  GWPPOSITION[{RX, IX}] === {$Failed, $Failed}, 
  True, 
  {GWPPOSITION::badform},
  TestID -> "GWPPOSITION-02-RawList-Fail"
]

(* ========================================================== *)
(* MOMENTUM PARSER VERIFICATION TESTS                         *)
(* ========================================================== *)

VerificationTest[
  Simplify[GWPMOMENTUM[RP + I*IP, MASS] - RIP1] == {0,0}, 
  TestID -> "GWPMOMENTUM-01-ReIm", 
  MetaInformation -> STR13
]

VerificationTest[
  Simplify[GWPMOMENTUM[{"KineticEnergy", EK, 1}, MASS] - RIP2] == {0,0}, 
  TestID -> "GWPMOMENTUM-02-KineticEnergy-pos", 
  MetaInformation -> STR14
]

VerificationTest[
  Simplify[GWPMOMENTUM[{"KineticEnergy", EK, -1}, MASS] - RIP3] == {0,0}, 
  TestID -> "GWPMOMENTUM-03-KineticEnergy-neg", 
  MetaInformation -> STR15
]

VerificationTest[
  GWPMOMENTUM[{RP, IP}, MASS] === {$Failed, $Failed}, 
  True, 
  {GWPMOMENTUM::badform},
  TestID -> "GWPMOMENTUM-04-RawList-Fail"
]

VerificationTest[
  GWPMOMENTUM[{"KineticEnergy", {EK}, 1}, MASS] === {$Failed, $Failed}, 
  True, 
  {GWPMOMENTUM::badform},
  TestID -> "GWPMOMENTUM-05-NestedList-Fail"
]

(* ========================================================== *)
(* PHASE PARSER VERIFICATION TESTS                           *)
(* ========================================================== *)

VerificationTest[
  True, 
  TestID -> "Definition", 
  MetaInformation -> STR0a
]

VerificationTest[
  Simplify[GWPPHASE[RG + I*IG, ARG2] - RIG1] == {0,0}, 
  TestID -> "GWPPHASE-01-ReIm", 
  MetaInformation -> STR6
]

VerificationTest[
  Simplify[GWPPHASE[{"Action", S}, ARG2] - RIG2] == {0,0}, 
  TestID -> "GWPPHASE-02-Action-NoMaslov", 
  MetaInformation -> STR7
]

VerificationTest[
  Simplify[GWPPHASE[{"Action", S, MU}, ARG2] - RIG3] == {0,0}, 
  TestID -> "GWPPHASE-03-Action-Maslov", 
  MetaInformation -> STR8
]

VerificationTest[
  Simplify[GWPPHASE[{"Displacement", X0, P0}, ARG2] - RIG4] == {0,0}, 
  TestID -> "GWPPHASE-04-Displacement", 
  MetaInformation -> STR9
]

VerificationTest[
  Simplify[GWPPHASE[{"Coefficient", PHI, W}, ARG2] - RIG5] == {0,0}, 
  TestID -> "GWPPHASE-05-PHI-W", 
  MetaInformation -> STR10
]

VerificationTest[
  Simplify[GWPPHASE[{"Evolution", EN, TT}, ARG2] - RIG6] == {0,0}, 
  TestID -> "GWPPHASE-06-ET", 
  MetaInformation -> STR11
]

VerificationTest[
  GWPPHASE[{RG, IG}, ARG2] === {$Failed, $Failed}, 
  True, 
  {GWPPHASE::badform},
  TestID -> "GWPPHASE-07-RawList-Fail"
]

VerificationTest[
  GWPPHASE[{"Action", {S}}, ARG2] === {$Failed, $Failed}, 
  True, 
  {GWPPHASE::badform},
  TestID -> "GWPPHASE-08-NestedList-Fail"
]

(* ========================================================== *)
(* CLEANUP: PREVENT NAMESPACE POLLUTION                       *)
(* ========================================================== *)

(* Clear dynamically generated strings and configuration sequences 
   so MetaInformation renders properly in the TestReport. *)
ClearAll["STR*"];
ClearAll["ARG*"];
ClearAll["RIA*"];
ClearAll["RIX*"];
ClearAll["RIP*"];
ClearAll["RIG*"];

(* Clear the abstract symbolic variables used in the shape and phase tests *)
ClearAll[HBAR, MASS, RA, IA, UX, COVXP, UP, RA1, RX1, IX, RP1, IP, EK, RX, RP, RG, IG, S, MU, X0, P0, PHI, W, EN, TT];
