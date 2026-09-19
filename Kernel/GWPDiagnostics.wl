(* ::Package:: *)

(* ::Title:: *)
(*GWPDiagnostics Package*)


(* ::Section::Closed:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPDiagnostics`                                    *)
(* DESCRIPTION : Testing, verification, and formatting suites for the        *)
(*               GWPTools framework.                                         *)
(* ========================================================================= *)

BeginPackage["GWPTools`GWPDiagnostics`", {
  "GWPTools`",
  "GWPTools`GWPHydrodynamics`",
  "GWPTools`GWPDeveloper`"
}]


(* ::Section::Closed:: *)
(*Usage Statements*)


(* --- Testing & Diagnostics --- *)
GWPTestReport::usage = "GWPTestReport[\"key1\", \"key2\", ...] runs test files whose names contain the specified strings.\n" <>
  "GWPTestReport[\"All\"] runs the entire testing suite.\n" <>
  "GWPTestReport[] returns a list of all available test files.";

GWPFormatReport::usage = "GWPFormatReport[report] formats a TestReportObject into a Dataset.\n" <>
  "GWPFormatReport[report, \"ReportFormat\" -> format] specifies the output format (e.g., \"Summary\", \"Detailed\").";


(* ::Section::Closed:: *)
(*Private*)


Begin["`Private`"]

(* Capture Package Directory for test file routing *)
$PackageDirectory = Quiet[
  If[$InputFileName =!= "", 
    DirectoryName[$InputFileName, 2], 
    NotebookDirectory[]
  ]
];


(* ::Section::Closed:: *)
(*GWPTestReport*)


(* --- Test Runner Utility (Private Implementation) --- *)
Options[GWPTestReport] = Join[
  {
    "GWPTestDirectory" -> Automatic,
    "MergeReports" -> True (* True natively merges all results into a single TestReportObject *)
  },
  Options[TestReport]
];

GWPTestReport::nodir = "Test directory not found at `1`.";
GWPTestReport::nokeys = "No test files matched the keys: `1`.";

GWPTestReport[keys___String, opts:OptionsPattern[]] := Module[
  {testDir, allFiles, targetFiles, keyList, availableKeys, testOpts, merge},
  
  keyList = {keys};
  
  (* 1. Extract options *)
  testOpts = FilterRules[{opts}, Options[TestReport]];
  merge = OptionValue["MergeReports"];
  
  (* 2. Resolve the test directory *)
  testDir = Replace[
    OptionValue["GWPTestDirectory"], 
    Automatic :> FileNameJoin[{$PackageDirectory, "Tests"}]
  ];
  
  If[!DirectoryQ[testDir],
    Message[GWPTestReport::nodir, testDir];
    Return[$Failed];
  ];

  (* 3. Find all .wl test files and extract base names *)
  allFiles = FileNames["*.wl", testDir, Infinity];
  availableKeys = FileBaseName /@ allFiles;
  
  (* 4. BEHAVIOR: No Keys Provided -> Return a list of available tests *)
  If[Length[keyList] === 0,
    Return[availableKeys];
  ];
  
  (* 5. BEHAVIOR: Keys Provided -> Filter files *)
  targetFiles = If[MemberQ[ToLowerCase /@ keyList, "all"],
    allFiles, 
    Select[allFiles, 
      Function[file, AnyTrue[keyList, StringContainsQ[FileNameTake[file], #, IgnoreCase -> True] &]]
    ]
  ];
  
  (* 6. Catch invalid keys *)
  If[Length[targetFiles] === 0,
    Message[GWPTestReport::nokeys, keyList];
    Return[Missing["NotAvailable"]];
  ];

  (* 7. Execute tests and return raw TestReportObject(s) *)
  If[TrueQ[merge],
    TestReport[targetFiles, Sequence @@ testOpts],
    Map[TestReport[#, Sequence @@ testOpts] &, targetFiles]
  ]
];


(* ::Section::Closed:: *)
(*GWPFormatReport*)


(* --- Test Report Formatting Utility --- *)
Options[GWPFormatReport] = Join[
  {
    "ReportFormat" -> "Summary"
  },
  Options[Dataset]
];

(* Overload 1: Handles a SINGLE TestReportObject *)
GWPFormatReport[report_TestReportObject, opts:OptionsPattern[]] := Module[{format, datasetOpts},
  
  format = OptionValue["ReportFormat"];
  
  (* Filter out only the options that belong to Dataset *)
  datasetOpts = FilterRules[{opts}, Options[Dataset]];
  
  (* Check if the user provided a custom list of properties *)
  If[ListQ[format],
    Return[
      Dataset[
        Association @ MapIndexed[First[#2] -> #[format] &, report["Results"]], 
        Sequence @@ datasetOpts
      ]
    ]
  ];
  
  (* Otherwise, use the predefined string formats *)
  Switch[format,
    "Summary",
    Dataset[
      report[{"Title", "CPUTimeUsed", "AbsoluteTimeUsed", "ReportSucceeded"}], 
      Sequence @@ datasetOpts
    ],
    
    "Detailed",
    Dataset[
      Association @ MapIndexed[
        First[#2] -> #[{"TestID", "CPUTimeUsed", "Outcome", "Input", "MetaInformation"}] &, 
        report["Results"]
      ], 
      Sequence @@ datasetOpts
    ],
    
    (* Fallback *)
    _,
    report
  ]
];

(* Overload 2: Handles a LIST of TestReportObjects (if MergeReports -> False was used) *)
GWPFormatReport[reports:{__TestReportObject}, opts:OptionsPattern[]] := 
  Map[GWPFormatReport[#, opts] &, reports];


(* ::Section::Closed:: *)
(*End*)


End[]

(* Hide internal code from the ? menu *)
SetAttributes[Evaluate[Names["GWPTools`GWPDiagnostics`*"]], {ReadProtected}];

EndPackage[]
