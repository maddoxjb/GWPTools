(* ::Package:: *)

Needs["GWPTools`"]

(* Define the specific test environment *)
ARG = Sequence[RA + I*IA, RX + I*IX, RP + I*IP, RG + I*IG];
OPT = Sequence["HBAR"->HBAR,"MASS"->MASS];
SYS = LINEAR[1];

(* Dynamically resolve the path based on the execution method (TestReport vs Get) *)
currentFile = If[$TestFileName =!= "", $TestFileName, $InputFileName];
corePath = FileNameJoin[{DirectoryName[currentFile], "16-GWPDISPATCH-CORE.wl"}];

(* Run the common test suite *)
Get[corePath]
