(* ::Package:: *)

(* ========================================================================= *)
(* PACKAGE     : GWPTools`                                                   *)
(* DESCRIPTION : The Master Paclet Loader (Facade). Orchestrates the boot    *)
(*               sequence for the core registries, dispatchers, and engines. *)
(* ========================================================================= *)

Quiet[Remove["Global`GWP"]];

BeginPackage["GWPTools`"]

If[TrueQ[Global`$GWPDebug], Print["[GWPTools] Initiating Master Boot Sequence..."]];

(* 1. Boot the Database *)
If[TrueQ[Global`$GWPDebug], Print["[GWPTools] Loading GWPTools`GWPRegistry`..."]];
Needs["GWPTools`GWPRegistry`"];

(* 2. Boot the Dispatcher *)
If[TrueQ[Global`$GWPDebug], Print["[GWPTools] Loading GWPTools`GWPDispatcher`..."]];
Needs["GWPTools`GWPDispatcher`"];

(* 3. Boot Stable Math Engines *)
If[TrueQ[Global`$GWPDebug], Print["[GWPTools] Loading GWPTools`GWPEngine1D`..."]];
Needs["GWPTools`GWPEngine1D`"];

If[TrueQ[Global`$GWPDebug], Print["[GWPTools] Master Boot Sequence Complete."]];

EndPackage[]
