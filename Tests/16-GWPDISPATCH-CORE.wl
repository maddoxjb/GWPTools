(* ::Package:: *)

(* ========================================================================= *)
(* TEST SUITE  : GWPTools (Version 1.0.0)                                    *)
(* FILE        : 16-GWPDISPATCH-CORE.wl                                      *)
(* DESCRIPTION : Verifies Tier-3 object dispatching and property routing.    *)
(* ========================================================================= *)

(* Load the Public API for object-level testing *)
Needs["GWPTools`"]
(* Load the Developer engine so the RHS can evaluate the exact math! *)
Needs["GWPTools`GWPDeveloper`"]

(* ========================================================== *)
(* CORE DISPATCH VERIFICATION ENGINE *)                        
(* Assumes ARG, OPT, and SYS are pre-defined by the caller. *)  
(* ========================================================== *)

(* Capture the clean string name (e.g., "FREE") before modifying SYS *)
sysTag = ToString[SYS];

(* CRITICAL FIX: Force SYS out of the Global namespace into Developer *)
SYS = ToExpression["GWPTools`GWPDeveloper`" <> sysTag];

(* Instantiate the targeted object (Updated to use "Potential" instead of "SYSTEM") *)
STR = "OBJ = GWP[ARG, OPT, \"Potential\" -> SYS]";
Quiet[ToExpression[STR]];

VerificationTest[True, TestID -> "Definition", MetaInformation -> "SYS="<>sysTag]
VerificationTest[Head[OBJ] === GWPObject, TestID -> "GWPDISP-00-DefOBJ-" <> sysTag, MetaInformation -> STR]

reg = GWPTools`Private`$GWPRegistry;

(* ========================================================== *)
(* DYNAMIC VERIFICATION TESTS: EXHAUSTIVE DISPATCHING         *)
(* ========================================================== *)
Scan[
  Function[{row},
    Module[{short, type, testID, STRCMD, head},
      short = row[[2]];
      type = row[[3]];
      testID = "GWPDISP-" <> type <> "-" <> short <> "-" <> sysTag;
      
      (* CRITICAL FIX: Explicitly bind the head to the Developer package *)
      head = ToExpression["GWPTools`GWPDeveloper`GWP" <> short];
      
      (* Verify the Object Dispatcher outputs identical functional structures to the Package.
         Using fully qualified contexts for GWPPARAM to prevent the Read-Time Context Trap. *)
      Switch[type,
        "Static",
        STRCMD = "GWPCMD = GWP" <> short <> "@GWPPARAM[ARG,OPT]";
        ReleaseHold[
          Hold[VerificationTest[OBJ[S] === H[GWPTools`GWPDeveloper`GWPPARAM[ARG, OPT]], True, TestID -> ID, MetaInformation -> M]] /. 
          {S -> short, H -> head, ID -> testID, M -> STRCMD}
        ],
        
        "Temporal",
        STRCMD = "GWPCMD = GWP" <> short <> "@SYS[t]@GWPPARAM[ARG,OPT]";
        ReleaseHold[
          Hold[VerificationTest[OBJ[S][t] === H[SYS[t][GWPTools`GWPDeveloper`GWPPARAM[ARG, OPT]]], True, TestID -> ID, MetaInformation -> M]] /. 
          {S -> short, H -> head, ID -> testID, M -> STRCMD}
        ],
        
        "Field",
        STRCMD = "GWPCMD = GWP" <> short <> "[var]@SYS[t]@GWPPARAM[ARG,OPT]";
        ReleaseHold[
          Hold[VerificationTest[OBJ[S][var, t] === H[var][SYS[t][GWPTools`GWPDeveloper`GWPPARAM[ARG, OPT]]], True, TestID -> ID, MetaInformation -> M]] /. 
          {S -> short, H -> head, ID -> testID, M -> STRCMD}
        ],
        
        "Bivariate",
        STRCMD = "GWPCMD = GWP" <> short <> "[var1,var2]@SYS[t]@GWPPARAM[ARG,OPT]";
        ReleaseHold[
          Hold[VerificationTest[OBJ[S][var1, var2, t] === H[var1, var2][SYS[t][GWPTools`GWPDeveloper`GWPPARAM[ARG, OPT]]], True, TestID -> ID, MetaInformation -> M]] /. 
          {S -> short, H -> head, ID -> testID, M -> STRCMD}
        ],
        
        "Moment",
        STRCMD = "GWPCMD = Table[GWP" <> short <> "[n]@SYS[t]@GWPPARAM[ARG,OPT],{n,0,2}]";
        ReleaseHold[
          Hold[VerificationTest[Table[OBJ[S, n][t], {n, 0, 2}] === Table[H[n][SYS[t][GWPTools`GWPDeveloper`GWPPARAM[ARG, OPT]]], {n, 0, 2}], True, TestID -> ID, MetaInformation -> M]] /. 
          {S -> short, H -> head, ID -> testID, M -> STRCMD}
        ],
        
        "Recursive",
        STRCMD = "GWPCMD = Table[GWP" <> short <> "[n][var]@SYS[t]@GWPPARAM[ARG,OPT],{n,0,2}]";
        ReleaseHold[
          Hold[VerificationTest[Table[OBJ[S, n][var, t], {n, 0, 2}] === Table[H[n][var][SYS[t][GWPTools`GWPDeveloper`GWPPARAM[ARG, OPT]]], {n, 0, 2}], True, TestID -> ID, MetaInformation -> M]] /. 
          {S -> short, H -> head, ID -> testID, M -> STRCMD}
        ],
        
        _, Nothing
      ]
    ]
  ],
  reg
];

(* ========================================================== *)
(* CLEANUP: PREVENT NAMESPACE POLLUTION                       *)
(* ========================================================== *)

(* Clear dynamically generated strings and metadata tags *)
ClearAll[STR, STRCMD, sysTag];

(* Clear the global test object and environment sequences *)
ClearAll[OBJ, ARG, OPT, SYS];

(* Clear the abstract symbolic variables and proxy iterators used in the tests *)
ClearAll[RA, IA, RX, IX, RP, IP, RG, IG, HBAR, MASS, t, n, var, var1, var2];

(* Remove internal routing variables used by the generated wrapper scripts *)
Remove[reg, currentFile, corePath];
