(* ::Package:: *)

(* ========================================================================= *)
(* TEST SUITE  : GWPTools (Version 1.0.0)                                    *)
(* FILE        : 1D-MATH-PARAM.wl                                            *)
(* DESCRIPTION : Tests Parameters section of GWPEngine1D.wl                  *)
(* ========================================================================= *)

(* Load the Master Test Environment *)
Needs["GWPTools`GWPDiagnostics`"]

(* ========================================================== *)
(* DEFINITIONS AND METADATA STRINGS                           *)
(* ========================================================== *)

(* Store the function's definitions in a temporary variable and clear it *)
storedGWP1D486 = DownValues[GWP1D486];
Clear[GWP1D486];

(* Define sequence strings for MetaInformation and evaluate them *)
ToExpression[STR1 = "OPT=Sequence[\"HBAR\"->HBAR,\"MASS\"->MASS]"];
ToExpression[STR2 = "ARG0=Sequence[ ]"];
ToExpression[STR3 = "ARG1=Sequence[AA]"];
ToExpression[STR4 = "ARG2=Sequence[AA,XX]"];
ToExpression[STR5 = "ARG3=Sequence[AA,XX,PP]"];
ToExpression[STR6 = "ARG4=Sequence[AA,XX,PP,GG]"];

(* ========================================================== *)
(* VERIFICATION TESTS                                         *)
(* ========================================================== *)

VerificationTest[
  GWP1DPARAM[ARG0] == GWP1D486[1/4, 0, 0, 0, 1, 1], 
  TestID -> "GWP1DPARAM-01-Default", 
  MetaInformation -> STR2
]

VerificationTest[
  GWP1DPARAM[ARG1] == GWP1D486[ARG1, 0, 0, 0, 1, 1], 
  TestID -> "GWP1DPARAM-02-A", 
  MetaInformation -> STR3
]

VerificationTest[
  GWP1DPARAM[ARG2] == GWP1D486[ARG2, 0, 0, 1, 1], 
  TestID -> "GWP1DPARAM-03-AX", 
  MetaInformation -> STR4
]

VerificationTest[
  GWP1DPARAM[ARG3] == GWP1D486[ARG3, 0, 1, 1], 
  TestID -> "GWP1DPARAM-04-AXP", 
  MetaInformation -> STR5
]

VerificationTest[
  GWP1DPARAM[ARG4] == GWP1D486[ARG4, 1, 1], 
  TestID -> "GWP1DPARAM-05-AXPG", 
  MetaInformation -> STR6
]

(* Dummy test to inject STR1 into the test report metadata cleanly *)
VerificationTest[
  True, 
  TestID -> "Definition", 
  MetaInformation -> STR1
]

VerificationTest[
  GWP1DPARAM[ARG0, OPT] == GWP1D486[1/4, 0, 0, 0, HBAR, MASS], 
  TestID -> "GWP1DPARAM-06-Default-Opts"
]

VerificationTest[
  GWP1DPARAM[ARG1, OPT] == GWP1D486[ARG1, 0, 0, 0, HBAR, MASS], 
  TestID -> "GWP1DPARAM-07-A-Opts"
]

VerificationTest[
  GWP1DPARAM[ARG2, OPT] == GWP1D486[ARG2, 0, 0, HBAR, MASS], 
  TestID -> "GWP1DPARAM-08-AX-Opts"
]

VerificationTest[
  GWP1DPARAM[ARG3, OPT] == GWP1D486[ARG3, 0, HBAR, MASS], 
  TestID -> "GWP1DPARAM-09-AXP-Opts"
]

VerificationTest[
  GWP1DPARAM[ARG4, OPT] == GWP1D486[ARG4, HBAR, MASS], 
  TestID -> "GWP1DPARAM-10-AXPG-Opts"
]

VerificationTest[
  GWP1DPARAM[ARG0, "HBAR" -> {1, 2}] === $Failed, 
  True, 
  {GWP1DPARAM::posval},
  TestID -> "GWP1DPARAM-11-HBAR-List-Fail"
]

VerificationTest[
  GWP1DPARAM[ARG0, "MASS" -> {1, 2}] === $Failed, 
  True, 
  {GWP1DPARAM::posval},
  TestID -> "GWP1DPARAM-12-MASS-List-Fail"
]


(* ========================================================== *)
(* CLEANUP: PREVENT NAMESPACE POLLUTION (Snapshot Revert)     *)
(* ========================================================== *)

(* Put the definitions back! *)
DownValues[GWP1D486] = storedGWP1D486;
(* Remove the temporary storage variable completely *)
Remove[storedGWP1D486];

(* Clear the values of dynamically generated strings and options *)
ClearAll["STR*"];
ClearAll["ARG*"];
ClearAll[OPT];

(* Clear the abstract symbolic variables used in the tests *)
ClearAll[AA, XX, PP, GG, HBAR, MASS];
