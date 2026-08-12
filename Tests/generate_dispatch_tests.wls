#!/usr/bin/env wolframscript
(* ::Package:: *)

(* 1. Ensure the package can be found *)
AppendTo[$Path, ParentDirectory[Directory[]]];
Needs["GWPTools`"];

Print["Loading GWPTools API and generating dispatch test files..."];

(* 2. Extract Named Systems cleanly using InputForm *)
namedAssoc = GWPTools`Private`$GWPNamedSystems;
namedList = {#, ToString[namedAssoc[#], InputForm]} & /@ Keys[namedAssoc];

(* 3. Extract System Functions *)
funcListRaw = GWP["SystemFunctions"];
funcList = {StringReplace[#, "[" ~~ ___ ~~ "]" -> ""], #} & /@ funcListRaw;

(* 4. Combine them into the master generation list *)
systems = Join[namedList, funcList];

(* 5. Define the exact file template (Using a safe placeholder) *)
template = "(* ::Package:: *)

Needs[\"GWPTools`\"]

(* Define the specific test environment *)
ARG = Sequence[RA + I*IA, RX + I*IX, RP + I*IP, RG + I*IG];
OPT = Sequence[\"HBAR\"->HBAR,\"MASS\"->MASS];
SYS = __SYSTEM_PLACEHOLDER__;

(* Dynamically resolve the path based on the execution method (TestReport vs Get) *)
currentFile = If[$TestFileName =!= \"\", $TestFileName, $InputFileName];
corePath = FileNameJoin[{DirectoryName[currentFile], \"16-GWPDISPATCH-CORE.wl\"}];

(* Run the common test suite *)
Get[corePath]
";

(* 6. Generate the files using safe StringReplace *)
count = 1;
Do[
  tag = item[[1]];
  sysExpr = item[[2]];
  
  (* Format index to 01, 02, etc. *)
  idx = IntegerString[count, 10, 2];
  fileName = "16-" <> idx <> "-GWPDISPATCH-" <> tag <> ".wl";
  
  (* Inject variables safely and save *)
  fileContent = StringReplace[template, "__SYSTEM_PLACEHOLDER__" -> sysExpr];
  Export[fileName, fileContent, "Text"];
  
  Print["Generated: ", fileName, " -> SYS = ", sysExpr];
  count++;
, {item, systems}];

Print["Done! Successfully generated ", count - 1, " test files."];
