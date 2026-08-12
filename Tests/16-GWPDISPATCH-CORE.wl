(* ::Package:: *)

(* ::Package:: *)
(**)


(* ========================================================== *)
(* CORE DISPATCH VERIFICATION ENGINE *)                        
(*  Assumes ARG, OPT, and SYS are pre-defined by the caller. *)  
(* ========================================================== *)

sysTag = ToString[SYS];

(* Instantiate the targeted object *)
STR = "OBJ = GWP[ARG, OPT, \"SYSTEM\" -> SYS]";
Quiet[ToExpression[STR]];

VerificationTest[True, TestID -> "Definition", MetaInformation -> "SYS="<>sysTag]
VerificationTest[Head[OBJ] === GWPObject, TestID -> "GWPDISP-00-DefOBJ-" <> sysTag, MetaInformation -> STR]

reg = GWPTools`Private`$GWPRegistry;

(* ========================================================== *)
(* DYNAMIC VERIFICATION TESTS: EXHAUSTIVE DISPATCHING         *)
(* ========================================================== *)
Scan[
  Function[{row},
    Module[{short, type, testID, STR, funcSym},
      short = row[[2]];
      type = row[[3]];
      testID = "GWPDISP-" <> type <> "-" <> short <> "-" <> sysTag;
      
      (* Generate the symbol to mock (e.g., GWPPSIX) *)
      funcSym = Symbol["GWP" <> short];
      
      (* Use Hold/ReleaseHold to inject the symbol into Block dynamically. 
         This entirely bypasses the Front-End red syntax highlighting error. *)
      ReleaseHold[
        Hold[
          Block[{MOCK},
            Switch[type,
              "Static",
              STR = "GWPCMD = GWP" <> short <> "@GWPPARAM[ARG,OPT]";
              Quiet[ToExpression[STR]];
              With[{s = short},
                VerificationTest[OBJ[s] === GWPCMD, TestID -> testID, MetaInformation -> STR]
              ],
              
              "Temporal",
              STR = "GWPCMD = GWP" <> short <> "@SYS[t]@GWPPARAM[ARG,OPT]";
              Quiet[ToExpression[STR]];
              With[{s = short},
                VerificationTest[OBJ[s][t] === GWPCMD, TestID -> testID, MetaInformation -> STR]
              ],
              
              "Field",
              STR = "GWPCMD = GWP" <> short <> "[var]@SYS[t]@GWPPARAM[ARG,OPT]";
              Quiet[ToExpression[STR]];
              With[{s = short},
                VerificationTest[OBJ[s][var, t] === GWPCMD, TestID -> testID, MetaInformation -> STR]
              ],
              
              "Bivariate",
              STR = "GWPCMD = GWP" <> short <> "[var1,var2]@SYS[t]@GWPPARAM[ARG,OPT]";
              Quiet[ToExpression[STR]];
              With[{s = short},
                VerificationTest[OBJ[s][var1, var2, t] === GWPCMD, TestID -> testID, MetaInformation -> STR]
              ],
              
              "Moment",
              STR = "GWPCMD = Table[GWP" <> short <> "[n]@SYS[t]@GWPPARAM[ARG,OPT],{n,0,6}]";
              Quiet[ToExpression[STR]];
              With[{s = short},
                VerificationTest[Table[OBJ[s, n][t], {n, 0, 6}] === GWPCMD, TestID -> testID, MetaInformation -> STR]
              ],
              
              "Recursive",
              STR = "GWPCMD = Table[GWP" <> short <> "[n][var]@SYS[t]@GWPPARAM[ARG,OPT],{n,0,6}]";
              Quiet[ToExpression[STR]];
              With[{s = short},
                VerificationTest[Table[OBJ[s, n][var, t], {n, 0, 6}] === GWPCMD, TestID -> testID, MetaInformation -> STR]
              ],
              
              _, Nothing
            ]
          ]
        ] /. MOCK -> funcSym
      ]
    ]
  ],
  reg
];

(* ========================================================== *)
(* CLEANUP: PREVENT NAMESPACE POLLUTION                       *)
(* ========================================================== *)

(* Clear dynamically generated strings and metadata tags *)
ClearAll[STR, sysTag];

(* Clear the global test object, command targets, and environment sequences *)
ClearAll[OBJ, GWPCMD, ARG, OPT, SYS];

(* Clear the abstract symbolic variables and proxy iterators used in the tests *)
ClearAll[RA, IA, RX, IX, RP, IP, RG, IG, HBAR, MASS, t, n, var, var1, var2];

(* Remove internal routing variables used by the generated wrapper scripts *)
Remove[reg, currentFile, corePath];
