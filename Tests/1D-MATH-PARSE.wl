(* ::Package:: *)

(* ========================================================================= *)
(* TEST SUITE  : GWPTools (Version 1.0.0)                                    *)
(* FILE        : 1D-MATH-PARSE.wl                                            *)
(* DESCRIPTION : Tests Parameters section of GWPEngine1D.wl                  *)
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
  Simplify[GWP1DSHAPE[RA + I*IA, ARG1] - RIA1] == {0,0}, 
  TestID -> "GWP1DSHAPE-01-ReIm", 
  MetaInformation -> STR1
]

VerificationTest[
  Simplify[GWP1DSHAPE[{"Covariance", UX, 0}, ARG1] - RIA2] == {0,0}, 
  TestID -> "GWP1DSHAPE-02-UX-0", 
  MetaInformation -> STR2
]

VerificationTest[
  Simplify[GWP1DSHAPE[{"Covariance", UX, COVXP}, ARG1] - RIA3] == {0,0}, 
  TestID -> "GWP1DSHAPE-03-UX-COVXP", 
  MetaInformation -> STR3
]

VerificationTest[
  Simplify[GWP1DSHAPE[{"Uncertainty", UX, UP, 1}, ARG1] - RIA4] == {0,0}, 
  TestID -> "GWP1DSHAPE-04-UX-UP-posChirp", 
  MetaInformation -> STR4
]

VerificationTest[
  Simplify[GWP1DSHAPE[{"Uncertainty", UX, UP, -1}, ARG1] - RIA5] == {0,0}, 
  TestID -> "GWP1DSHAPE-05-UX-UP-negChirp", 
  MetaInformation -> STR5
]

VerificationTest[
  GWP1DSHAPE[{1, 2}, ARG1] === {$Failed, $Failed}, 
  True, 
  {GWP1DSHAPE::badform},
  TestID -> "GWP1DSHAPE-06-RawList-Fail"
]

VerificationTest[
  GWP1DSHAPE[{"Covariance", {UX}, COVXP}, ARG1] === {$Failed, $Failed}, 
  True, 
  {GWP1DSHAPE::badform},
  TestID -> "GWP1DSHAPE-07-NestedList-Fail"
]

(* ========================================================== *)
(* POSITION PARSER VERIFICATION TESTS                         *)
(* ========================================================== *)

VerificationTest[
  Simplify[GWP1DPOSITION[RX + I*IX] - RIX1] == {0,0}, 
  TestID -> "GWP1DPOSITION-01-ReIm", 
  MetaInformation -> STR12
]

VerificationTest[
  GWP1DPOSITION[{RX, IX}] === {$Failed, $Failed}, 
  True, 
  {GWP1DPOSITION::badform},
  TestID -> "GWP1DPOSITION-02-RawList-Fail"
]

(* ========================================================== *)
(* MOMENTUM PARSER VERIFICATION TESTS                         *)
(* ========================================================== *)

VerificationTest[
  Simplify[GWP1DMOMENTUM[RP + I*IP, MASS] - RIP1] == {0,0}, 
  TestID -> "GWP1DMOMENTUM-01-ReIm", 
  MetaInformation -> STR13
]

VerificationTest[
  Simplify[GWP1DMOMENTUM[{"KineticEnergy", EK, 1}, MASS] - RIP2] == {0,0}, 
  TestID -> "GWP1DMOMENTUM-02-KineticEnergy-pos", 
  MetaInformation -> STR14
]

VerificationTest[
  Simplify[GWP1DMOMENTUM[{"KineticEnergy", EK, -1}, MASS] - RIP3] == {0,0}, 
  TestID -> "GWP1DMOMENTUM-03-KineticEnergy-neg", 
  MetaInformation -> STR15
]

VerificationTest[
  GWP1DMOMENTUM[{RP, IP}, MASS] === {$Failed, $Failed}, 
  True, 
  {GWP1DMOMENTUM::badform},
  TestID -> "GWP1DMOMENTUM-04-RawList-Fail"
]

VerificationTest[
  GWP1DMOMENTUM[{"KineticEnergy", {EK}, 1}, MASS] === {$Failed, $Failed}, 
  True, 
  {GWP1DMOMENTUM::badform},
  TestID -> "GWP1DMOMENTUM-05-NestedList-Fail"
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
  Simplify[GWP1DPHASE[RG + I*IG, ARG2] - RIG1] == {0,0}, 
  TestID -> "GWP1DPHASE-01-ReIm", 
  MetaInformation -> STR6
]

VerificationTest[
  Simplify[GWP1DPHASE[{"Action", S}, ARG2] - RIG2] == {0,0}, 
  TestID -> "GWP1DPHASE-02-Action-NoMaslov", 
  MetaInformation -> STR7
]

VerificationTest[
  Simplify[GWP1DPHASE[{"Action", S, MU}, ARG2] - RIG3] == {0,0}, 
  TestID -> "GWP1DPHASE-03-Action-Maslov", 
  MetaInformation -> STR8
]

VerificationTest[
  Simplify[GWP1DPHASE[{"Displacement", X0, P0}, ARG2] - RIG4] == {0,0}, 
  TestID -> "GWP1DPHASE-04-Displacement", 
  MetaInformation -> STR9
]

VerificationTest[
  Simplify[GWP1DPHASE[{"Coefficient", PHI, W}, ARG2] - RIG5] == {0,0}, 
  TestID -> "GWP1DPHASE-05-PHI-W", 
  MetaInformation -> STR10
]

VerificationTest[
  Simplify[GWP1DPHASE[{"Evolution", EN, TT}, ARG2] - RIG6] == {0,0}, 
  TestID -> "GWP1DPHASE-06-ET", 
  MetaInformation -> STR11
]

VerificationTest[
  GWP1DPHASE[{RG, IG}, ARG2] === {$Failed, $Failed}, 
  True, 
  {GWP1DPHASE::badform},
  TestID -> "GWP1DPHASE-07-RawList-Fail"
]

VerificationTest[
  GWP1DPHASE[{"Action", {S}}, ARG2] === {$Failed, $Failed}, 
  True, 
  {GWP1DPHASE::badform},
  TestID -> "GWP1DPHASE-08-NestedList-Fail"
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
