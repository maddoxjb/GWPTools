(* ::Package:: *)

(* ::Package:: *)
(**)


Needs["GWPTools`"]

(* ========================================================== *)
(* DEFINITIONS AND CONFIGURATION                              *)
(* ========================================================== *)

(* Save the user's current global assumptions before modifying them *)
$userAssumptions = $Assumptions;

ToExpression[STR0 = "PAR=GWPPARAM[RA+I*IA,RX+I*IX,RP+I*IP,RG+I*IG,\"HBAR\"->HBAR,\"MASS\"->MASS]"];
ToExpression[STR00 = "$Assumptions=GWPASSUMPTIONS[PAR,\"Time\"->t]"];

(* Dynamically load the system templates directly from the package API *)
(* This pulls: {"FREE", "HO", "LINEAR[FK]", "HARMONIC[OMEGA]", ...} *)
systemTemplates = GWP["SystemFunctions"];

components = {
  {"01-RA", "GWPRA", "GWPRATD"},
  {"02-IA", "GWPIA", "GWPIATD"},
  {"03-RX", "GWPRX", "GWPRXTD"},
  {"04-RP", "GWPRP", "GWPRPTD"},
  {"05-RG", "GWPRG", "GWPRGTD"},
  {"06-IG", "GWPIG", "GWPIGTD"}
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
    
    (* Extract the clean head name (e.g., "FHOLIN[OMEGA, AK]" -> "FHOLIN") *)
    sysName = StringReplace[sysInput, "[" ~~ ___ ~~ "]" -> ""];
    
    (* Construct the evaluation string (e.g., "FHOLIN[OMEGA, AK][t][PAR]") *)
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
