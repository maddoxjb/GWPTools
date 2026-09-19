(* ::Package:: *)

(* ========================================================================= *)
(* TEST SUITE  : GWPTools (Version 1.0.0)                                    *)
(* FILE        : 1D-GWPObject-LIST.wl                                        *)
(* DESCRIPTION : Automated List-Threading and Vectorization Equivalence      *)
(*               Suite using GWPObject ShortKeys for the 1D Engine.          *)
(* ========================================================================= *)

(* Load the Master Test Environment *)
Needs["GWPTools`GWPDiagnostics`"]

(* ========================================================== *)
(* INITIALIZATION                                             *)
(* ========================================================== *)

(* Explicitly target the 1D engine during instantiation *)
OBJ = GWP["1D"][1/4, 0, 1, 0, "Potential" -> "HO"];
VerificationTest[True, TestID -> "Definition", MetaInformation -> "OBJ = GWP[\"1D\"][1/4, 0, 1, 0, \"Potential\" -> \"HO\"]"];

timeList   = {0.1, 1.0, 2.5};
timeScalar = 1.0;
spaceList  = {-1.0, 0.0, 1.0};
spaceList2 = {0.0, 1.0, 2.0};
energyList = {0.1, 1.5, 3.0};
cumulList  = {0.1, 0.5, 0.9}; (* Strictly 0 < c < 1 *) 

(* Send definitions to the diagnostic report *)
VerificationTest[True, TestID -> "Definition", MetaInformation -> "timeList = " <> ToString[timeList]];
VerificationTest[True, TestID -> "Definition", MetaInformation -> "timeScalar = " <> ToString[timeScalar]];
VerificationTest[True, TestID -> "Definition", MetaInformation -> "spaceList = " <> ToString[spaceList]];
VerificationTest[True, TestID -> "Definition", MetaInformation -> "spaceList2 = " <> ToString[spaceList2]];
VerificationTest[True, TestID -> "Definition", MetaInformation -> "energyList = " <> ToString[energyList]];
VerificationTest[True, TestID -> "Definition", MetaInformation -> "cumulList = " <> ToString[cumulList]];

(* Grab the shortkeys directly from the object; this auto-filters to 1D properties *)
shortKeys = OBJ["ShortKeys"];

(* ========================================================== *)
(* DYNAMIC AUTOMATED TESTS                                    *)
(* ========================================================== *)

(* Pull the full 1D dictionary directly from the backend registry *)
infoDict1D = GWPTools`GWPRegistry`$GWPInformation["1D"];

automatedListTests = Flatten @ KeyValueMap[
  Function[{longName, infoMap},
    Module[{short, dynamicClass},
      
      short = infoMap["ShortKey"];
      dynamicClass = infoMap["DynamicClass"];
      
      (* Force injection of the literal strings before VerificationTest holds them *)
      With[{S = short, DC = dynamicClass},
      
        (* 1. Skip constants that cause false dimension mismatches *)
        If[MemberQ[{"PECOEFF", "PEX", "FEX"}, S],
          Nothing
          
        (* 2. Intercept Energy Domain *)
        , If[S == "RHOE",
          VerificationTest[
            OBJ[S][energyList, timeScalar],
            Map[OBJ[S][#, timeScalar] &, energyList],
            SameTest -> (Chop[#1] == Chop[#2] &),
            TestID -> "AutoList-1D-" <> S <> "-Energy"
          ]
          
        (* 3. Intercept C-Space Domain *)
        , If[StringEndsQ[S, "C"] && MemberQ[{"Field", "Recursive"}, DC],
          If[DC == "Recursive",
            VerificationTest[
              OBJ[S, 2][cumulList, timeScalar],
              Map[OBJ[S, 2][#, timeScalar] &, cumulList],
              SameTest -> (Chop[#1] == Chop[#2] &),
              TestID -> "AutoList-1D-" <> S <> "-Cumul-Recursive"
            ],
            VerificationTest[
              OBJ[S][cumulList, timeScalar],
              Map[OBJ[S][#, timeScalar] &, cumulList],
              SameTest -> (Chop[#1] == Chop[#2] &),
              TestID -> "AutoList-1D-" <> S <> "-Cumul-Field"
            ]
          ]
          
        (* 4. Standard Dispatcher *)
        , Switch[DC,
            "Temporal",
            VerificationTest[
              OBJ[S][timeList],
              Map[OBJ[S], timeList],
              SameTest -> (Chop[#1] == Chop[#2] &),
              TestID -> "AutoList-1D-" <> S <> "-Time"
            ],
            
            "Moment",
            VerificationTest[
              OBJ[S, 2][timeList],
              Map[OBJ[S, 2], timeList],
              SameTest -> (Chop[#1] == Chop[#2] &),
              TestID -> "AutoList-1D-" <> S <> "-Time-Moment"
            ],
            
            "CrossMoment",
            VerificationTest[
              OBJ[S, 2, 1][timeList],
              Map[OBJ[S, 2, 1], timeList],
              SameTest -> (Chop[#1] == Chop[#2] &),
              TestID -> "AutoList-1D-" <> S <> "-Time-CrossMoment"
            ],
            
            "Field",
            VerificationTest[
              OBJ[S][spaceList, timeScalar],
              Map[OBJ[S][#, timeScalar] &, spaceList],
              SameTest -> (Chop[#1] == Chop[#2] &),
              TestID -> "AutoList-1D-" <> S <> "-Space"
            ],
            
            "Recursive",
            VerificationTest[
              OBJ[S, 2][spaceList, timeScalar],
              Map[OBJ[S, 2][#, timeScalar] &, spaceList],
              SameTest -> (Chop[#1] == Chop[#2] &),
              TestID -> "AutoList-1D-" <> S <> "-Space-Recursive"
            ],
            
            "Bivariate",
            VerificationTest[
              OBJ[S][spaceList, spaceList2, timeScalar],
              MapThread[OBJ[S][#1, #2, timeScalar] &, {spaceList, spaceList2}],
              SameTest -> (Chop[#1] == Chop[#2] &),
              TestID -> "AutoList-1D-" <> S <> "-Bivariate"
            ],
            
            "ParameterizedTemporal",
            VerificationTest[
              OBJ[S, 1][timeList],
              Map[OBJ[S, 1], timeList],
              SameTest -> (Chop[#1] == Chop[#2] &),
              TestID -> "AutoList-1D-" <> S <> "-Time-Parameterized"
            ],
            
            "ParameterizedBivariate",
            VerificationTest[
              OBJ[S, 1][spaceList, spaceList2, timeScalar],
              MapThread[OBJ[S, 1][#1, #2, timeScalar] &, {spaceList, spaceList2}],
              SameTest -> (Chop[#1] == Chop[#2] &),
              TestID -> "AutoList-1D-" <> S <> "-Bivariate-Parameterized"
            ],
            
            _, 
            Nothing
          ]
        ]]]
      ]
    ]
  ],
  infoDict1D
];

(* ========================================================== *)
(* CLEANUP                                                    *)
(* ========================================================== *)

ClearAll[OBJ, timeList, timeScalar, spaceList, spaceList2, energyList, cumulList, shortKeys, automatedListTests];
