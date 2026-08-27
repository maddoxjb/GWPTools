(* ::Package:: *)

(* ========================================================================= *)
(* TEST SUITE  : GWPTools (Version 1.0.0)                                    *)
(* FILE        : 17-GWPCOORDINATES.wl                                        *)
(* DESCRIPTION : Automated List-Threading and Vectorization Equivalence      *)
(*               Suite using GWPObject ShortKeys.                            *)
(* ========================================================================= *)

(* Load the Master Test Environment *)
Needs["GWPTools`GWPDiagnostics`"]

(* ========================================================== *)
(* INITIALIZATION                                             *)
(* ========================================================== *)

OBJ = GWP[1/4, 0, 1, 0, "Potential" -> "HO"];

timeList   = {0.1, 1.0, 2.5};
timeScalar = 1.0;
spaceList  = {-1.0, 0.0, 1.0};
spaceList2 = {0.0, 1.0, 2.0};
energyList = {0.1, 1.5, 3.0};
cumulList  = {0.1, 0.5, 0.9}; (* Strictly 0 < c < 1 *) 

(* Grab the shortkeys directly from the object *)
shortKeys = OBJ["ShortKeys"];

(* ========================================================== *)
(* DYNAMIC AUTOMATED TESTS                                    *)
(* ========================================================== *)

automatedListTests = Flatten @ Map[
  Function[{short},
    Module[{dynamicClass},
      
      (* Extract the class signature from Tier-1 Introspection *)
      dynamicClass = OBJ["PropertyInformation", short]["DynamicClass"];
      
      (* 1. Skip constants that cause false dimension mismatches *)
      If[MemberQ[{"PECOEFF", "PEX", "FEX"}, short],
        Nothing
        
      (* 2. Intercept Energy Domain *)
      , If[short == "RHOE",
        VerificationTest[
          OBJ[short][energyList, timeScalar],
          Map[OBJ[short][#, timeScalar] &, energyList],
          SameTest -> (Chop[#1] == Chop[#2] &),
          TestID -> "AutoList-RHOE-Energy"
        ]
        
      (* 3. Intercept C-Space Domain *)
      , If[StringEndsQ[short, "C"] && MemberQ[{"Field", "Recursive"}, dynamicClass],
        VerificationTest[
          If[dynamicClass == "Recursive", 
            OBJ[short, 2][cumulList, timeScalar], 
            OBJ[short][cumulList, timeScalar]
          ],
          If[dynamicClass == "Recursive", 
            Map[OBJ[short, 2][#, timeScalar] &, cumulList], 
            Map[OBJ[short][#, timeScalar] &, cumulList]
          ],
          SameTest -> (Chop[#1] == Chop[#2] &),
          TestID -> "AutoList-" <> short <> "-Cumul"
        ]
        
      (* 4. Standard Dispatcher *)
      , Switch[dynamicClass,
          "Temporal",
          VerificationTest[
            OBJ[short][timeList],
            Map[OBJ[short], timeList],
            SameTest -> (Chop[#1] == Chop[#2] &),
            TestID -> "AutoList-" <> short <> "-Time"
          ],
          
          "Moment",
          VerificationTest[
            OBJ[short, 2][timeList],
            Map[OBJ[short, 2], timeList],
            SameTest -> (Chop[#1] == Chop[#2] &),
            TestID -> "AutoList-" <> short <> "-Time-Moment"
          ],
          
          "CrossMoment",
          VerificationTest[
            OBJ[short, 2, 1][timeList],
            Map[OBJ[short, 2, 1], timeList],
            SameTest -> (Chop[#1] == Chop[#2] &),
            TestID -> "AutoList-" <> short <> "-Time-CrossMoment"
          ],
          
          "Field",
          VerificationTest[
            OBJ[short][spaceList, timeScalar],
            Map[OBJ[short][#, timeScalar] &, spaceList],
            SameTest -> (Chop[#1] == Chop[#2] &),
            TestID -> "AutoList-" <> short <> "-Space"
          ],
          
          "Recursive",
          VerificationTest[
            OBJ[short, 2][spaceList, timeScalar],
            Map[OBJ[short, 2][#, timeScalar] &, spaceList],
            SameTest -> (Chop[#1] == Chop[#2] &),
            TestID -> "AutoList-" <> short <> "-Space-Recursive"
          ],
          
          "Bivariate",
          VerificationTest[
            OBJ[short][spaceList, spaceList2, timeScalar],
            MapThread[OBJ[short][#1, #2, timeScalar] &, {spaceList, spaceList2}],
            SameTest -> (Chop[#1] == Chop[#2] &),
            TestID -> "AutoList-" <> short <> "-Bivariate"
          ],
          
          _, 
          Nothing
        ]
      ]]]
    ]
  ],
  shortKeys
];

(* ========================================================== *)
(* CLEANUP                                                    *)
(* ========================================================== *)

ClearAll[OBJ, timeList, timeScalar, spaceList, spaceList2, energyList, cumulList, shortKeys, automatedListTests];
