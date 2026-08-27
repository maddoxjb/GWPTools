(* ::Package:: *)

(* ========================================================================= *)
(* TEST SUITE  : GWPTools (Version 1.0.0)                                    *)
(* FILE        : 16-GWPDISPATCH.wl                                           *)
(* DESCRIPTION : Verifies Tier-3 object dispatching and property routing     *)
(*               for both active potentials (FREE) and static wavepackets.   *)
(* ========================================================================= *)

(* Load the Master Test Environment *)
Needs["GWPTools`GWPDiagnostics`"]

(* ========================================================== *)
(* DISPATCH VERIFICATION SETUP                                *)
(* ========================================================== *)

(* Define the abstract symbolic variables for the parameter bus *)
ARG = Sequence[RA + I*IA, RX + I*IX, RP + I*IP, RG + I*IG, "HBAR" -> HBAR, "MASS" -> MASS];
argTag = "Sequence[RA + I*IA, RX + I*IX, RP + I*IP, RG + I*IG, \"HBAR\" -> HBAR, \"MASS\" -> MASS]";

SYS = FREE;
sysTag = "FREE";

(* Instantiate the targeted objects: Dynamic and Static *)
STRD = "OBJD = GWP[ARG, \"Potential\" -> SYS]";
Quiet[ToExpression[STRD]];

STRS = "OBJS = GWP[ARG, \"Potential\" -> None]";
Quiet[ToExpression[STRS]];

VerificationTest[True, TestID -> "Definition", MetaInformation -> "ARG=" <> argTag]
VerificationTest[Head[OBJD] === GWPObject, TestID -> "GWPDISP-00-DefOBJ-" <> sysTag, MetaInformation -> STRD]
VerificationTest[Head[OBJS] === GWPObject, TestID -> "GWPDISP-00-DefOBJ-NONE", MetaInformation -> STRS]

reg = GWPTools`Private`$GWPRegistry;

(* ========================================================== *)
(* DYNAMIC & STATIC VERIFICATION TESTS                        *)
(* ========================================================== *)
Scan[
  Function[{row},
    Module[{short, dynClass, statClass, dynTestID, statTestID, STRCMD, head},
      short = row[[2]];
      dynClass = row[[3]];
      statClass = row[[4]];
      
      dynTestID = "GWPDISP-DYN-" <> dynClass <> "-" <> short;
      statTestID = "GWPDISP-STAT-" <> ToString[statClass] <> "-" <> short;
      
      head = ToExpression["GWP" <> short];
      
      (* ---------------------------------------------------- *)
      (* 1. TEST THE DYNAMIC CLASS ROUTING (Potential Active) *)
      (* ---------------------------------------------------- *)
      Switch[dynClass,
        "Static",
        STRCMD = "GWPCMD = GWP" <> short <> "@GWPPARAM[ARG]";
        ReleaseHold[Hold[VerificationTest[OBJD[S] === H[GWPPARAM[ARG]], True, TestID -> ID, MetaInformation -> M]] /. {S -> short, H -> head, ID -> dynTestID, M -> STRCMD}],
        
        "Temporal",
        STRCMD = "GWPCMD = GWP" <> short <> "@SYS[t]@GWPPARAM[ARG]";
        ReleaseHold[Hold[VerificationTest[OBJD[S][t] === H[SYS[t][GWPPARAM[ARG]]], True, TestID -> ID, MetaInformation -> M]] /. {S -> short, H -> head, ID -> dynTestID, M -> STRCMD}],
        
        "Field",
        STRCMD = "GWPCMD = GWP" <> short <> "[var]@SYS[t]@GWPPARAM[ARG]";
        ReleaseHold[Hold[VerificationTest[OBJD[S][var, t] === H[var][SYS[t][GWPPARAM[ARG]]], True, TestID -> ID, MetaInformation -> M]] /. {S -> short, H -> head, ID -> dynTestID, M -> STRCMD}],
        
        "Bivariate",
        STRCMD = "GWPCMD = GWP" <> short <> "[var1,var2]@SYS[t]@GWPPARAM[ARG]";
        ReleaseHold[Hold[VerificationTest[OBJD[S][var1, var2, t] === H[var1, var2][SYS[t][GWPPARAM[ARG]]], True, TestID -> ID, MetaInformation -> M]] /. {S -> short, H -> head, ID -> dynTestID, M -> STRCMD}],
        
        "Moment",
        STRCMD = "GWPCMD = Table[GWP" <> short <> "[n]@SYS[t]@GWPPARAM[ARG],{n,0,2}]";
        ReleaseHold[Hold[VerificationTest[Table[OBJD[S, n][t], {n, 0, 2}] === Table[H[n][SYS[t][GWPPARAM[ARG]]], {n, 0, 2}], True, TestID -> ID, MetaInformation -> M]] /. {S -> short, H -> head, ID -> dynTestID, M -> STRCMD}],
        
        "CrossMoment",
        STRCMD = "GWPCMD = Table[GWP" <> short <> "[m,n]@SYS[t]@GWPPARAM[ARG],{m,0,1},{n,0,1}]";
        ReleaseHold[Hold[VerificationTest[Table[OBJD[S, m, n][t], {m, 0, 1}, {n, 0, 1}] === Table[H[m, n][SYS[t][GWPPARAM[ARG]]], {m, 0, 1}, {n, 0, 1}], True, TestID -> ID, MetaInformation -> M]] /. {S -> short, H -> head, ID -> dynTestID, M -> STRCMD}],
        
        "Recursive",
        STRCMD = "GWPCMD = Table[GWP" <> short <> "[n][var]@SYS[t]@GWPPARAM[ARG],{n,0,2}]";
        ReleaseHold[Hold[VerificationTest[Table[OBJD[S, n][var, t], {n, 0, 2}] === Table[H[n][var][SYS[t][GWPPARAM[ARG]]], {n, 0, 2}], True, TestID -> ID, MetaInformation -> M]] /. {S -> short, H -> head, ID -> dynTestID, M -> STRCMD}],
        
        _, Nothing
      ];

      (* ---------------------------------------------------- *)
      (* 2. TEST THE STATIC CLASS ROUTING (Potential -> None) *)
      (* ---------------------------------------------------- *)
      Switch[statClass,
        "Static" | "StaticValue" | "StaticCrossMoment",
        STRCMD = "GWPCMD = GWP" <> short <> "@GWPPARAM[ARG]";
        ReleaseHold[Hold[VerificationTest[OBJS[S] === H[GWPPARAM[ARG]], True, TestID -> ID, MetaInformation -> M]] /. {S -> short, H -> head, ID -> statTestID, M -> STRCMD}],
        
        "Spatial",
        STRCMD = "GWPCMD = GWP" <> short <> "[var]@GWPPARAM[ARG]";
        ReleaseHold[Hold[VerificationTest[OBJS[S][var] === H[var][GWPPARAM[ARG]], True, TestID -> ID, MetaInformation -> M]] /. {S -> short, H -> head, ID -> statTestID, M -> STRCMD}],
        
        "RecursiveSpatial",
        STRCMD = "GWPCMD = Table[GWP" <> short <> "[n][var]@GWPPARAM[ARG],{n,0,2}]";
        ReleaseHold[Hold[VerificationTest[Table[OBJS[S, n][var], {n, 0, 2}] === Table[H[n][var][GWPPARAM[ARG]], {n, 0, 2}], True, TestID -> ID, MetaInformation -> M]] /. {S -> short, H -> head, ID -> statTestID, M -> STRCMD}],
        
        "BivariateSpatial",
        STRCMD = "GWPCMD = GWP" <> short <> "[var1,var2]@GWPPARAM[ARG]";
        ReleaseHold[Hold[VerificationTest[OBJS[S][var1, var2] === H[var1, var2][GWPPARAM[ARG]], True, TestID -> ID, MetaInformation -> M]] /. {S -> short, H -> head, ID -> statTestID, M -> STRCMD}],
        
        "StaticMoment",
        STRCMD = "GWPCMD = Table[GWP" <> short <> "[n]@GWPPARAM[ARG],{n,0,2}]";
        ReleaseHold[Hold[VerificationTest[Table[OBJS[S, n], {n, 0, 2}] === Table[H[n][GWPPARAM[ARG]], {n, 0, 2}], True, TestID -> ID, MetaInformation -> M]] /. {S -> short, H -> head, ID -> statTestID, M -> STRCMD}],
        
        None,
        STRCMD = "EXPECTED FALLBACK = $Failed (GWPObject::reqpot)";
        ReleaseHold[Hold[VerificationTest[OBJS[S], $Failed, {GWPObject::reqpot}, TestID -> ID, MetaInformation -> M]] /. {S -> short, ID -> statTestID, M -> STRCMD}],
        
        _, Nothing
      ];
    ]
  ],
  reg
];

(* ========================================================== *)
(* CLEANUP: PREVENT NAMESPACE POLLUTION                       *)
(* ========================================================== *)

ClearAll[STRD, STRS, STRCMD, sysTag, argTag];
ClearAll[OBJD, OBJS, ARG, SYS];
ClearAll[RA, IA, RX, IX, RP, IP, RG, IG, HBAR, MASS, t, n, m, var, var1, var2];
Remove[reg];
