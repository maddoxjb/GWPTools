(* ::Package:: *)

(* ::Package:: *)
(**)


(* ========================================================================= *)
(* TEST SUITE  : GWPTools (Version 1.0.0)                                    *)
(* FILE        : 1D-MATH-MODEL.wl                                            *)
(* DESCRIPTION : Tests Potential Models section of GWPEngine1D.wl            *)
(* ========================================================================= *)

(* Load the Master Test Environment *)
Needs["GWPTools`GWPDiagnostics`"]

(* ========================================================== *)
(* DEFINITIONS AND CONFIGURATION                              *)
(* ========================================================== *)

(* Save the user's current global assumptions before modifying them *)
$userAssumptions = $Assumptions;

ToExpression[STR0 = "PAR=GWP1DPARAM[RA+I*IA,RX+I*IX,RP+I*IP,RG+I*IG,\"HBAR\"->HBAR,\"MASS\"->MASS]"];
ToExpression[STR00 = "$Assumptions=GWP1DASSUMPTIONS[PAR,\"Time\"->t]"];

(* Explicitly define the internal mathematical potential signatures for the test generator *)
systemTemplates = {
  "GWP1DFREE", 
  "GWP1DHO", 
  "GWP1DLINEAR[FK]", 
  "GWP1DHARMONIC[OMEGA]", 
  "GWP1DPARABOLIC[OMEGA]", 
  "GWP1DFHOLIN[OMEGA, AK]", 
  "GWP1DFHORES[OMEGA, AK]", 
  "GWP1DFHONON[OMEGA, AK, OMEGA1]"
};

components = {
  {"01-RA", "GWP1DRA", "GWP1DRATD"},
  {"02-IA", "GWP1DIA", "GWP1DIATD"},
  {"03-RX", "GWP1DRX", "GWP1DRXTD"},
  {"04-RP", "GWP1DRP", "GWP1DRPTD"},
  {"05-RG", "GWP1DRG", "GWP1DRGTD"},
  {"06-IG", "GWP1DIG", "GWP1DIGTD"}
};

(* ========================================================== *)
(* AUTOMATED TEST GENERATOR (STRING-BUILDER METHOD)           *)
(* ========================================================== *)

testSuite = {
  VerificationTest[True, TestID -> "Definition", MetaInformation -> STR0],
  VerificationTest[True, TestID -> "Definition", MetaInformation -> STR00]
};

sysIndex = 1;
Do[
  Module[{sysName, sysStr, proxy, compID, func, funcTD, eqStr, idStr, metaStr, fullTestStr},
    
    (* Extract the clean head name (e.g., "GWP1DFHOLIN[OMEGA, AK]" -> "FHOLIN") *)
    sysName = StringReplace[sysInput, "[" ~~ ___ ~~ "]" -> ""];
    
    (* Construct the evaluation string (e.g., "GWP1DFHOLIN[OMEGA, AK][t][PAR]") *)
    sysStr  = sysInput <> "[t][PAR]";
    
    proxy   = "SYS" <> ToString[sysIndex];
    
    (* THE FIX: Wrap in a list, apply Floor replacement, then unpack to Sequence *)
    ToExpression[proxy <> "= Sequence @@ ({" <> sysStr <> "} /. Floor[_] -> 0)"];
    
    Do[
      compID  = comp[[1]];
      func    = comp[[2]];
      funcTD  = comp[[3]];
      
      (* REVISED: Subtraction method for pure algebraic reduction bypasses the logical prover *)
      eqStr = "Simplify[D[" <> func <> "@" <> proxy <> ", t] - (" <> funcTD <> "@" <> proxy <> ")] == 0";
      
      idStr = "TestID -> \"" <> sysName <> "-" <> compID <> "\"";
      
      (* Update MetaInformation to reflect the list-wrapping fix *)
      metaStr = If[compID === "01-RA", 
        ", MetaInformation -> \"" <> proxy <> "= Sequence @@ ({" <> sysStr <> "} /. Floor[_] -> 0)\"", 
        ""
      ];
      
      fullTestStr = "VerificationTest[" <> eqStr <> ", " <> idStr <> metaStr <> "]";
      AppendTo[testSuite, ToExpression[fullTestStr]];
      
    , {comp, components}];
  ];
  sysIndex++;
, {sysInput, systemTemplates}];

(* ========================================================== *)
(* CLEANUP: PREVENT NAMESPACE POLLUTION                       *)
(* ========================================================== *)

(* Restore the user's exact original assumptions *)
$Assumptions = $userAssumptions;
Remove[$userAssumptions];

(* Clear dynamically generated strings and system proxies so TestReport renders properly *)
ClearAll["STR*"];
ClearAll["SYS*"];
ClearAll[PAR];

(* Clear the abstract symbolic variables and time variables used in the parameters *)
ClearAll[RA, IA, RX, IX, RP, IP, RG, IG, HBAR, MASS, t];

(* Clear the specific symbolic constants used by the dynamic physics systems *)
ClearAll[FK, OMEGA, AK, OMEGA1];

(* Remove the internal script-building variables completely *)
Remove[systemTemplates, components, testSuite, sysIndex];
