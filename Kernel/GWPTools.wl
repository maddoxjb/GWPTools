(* ::Package:: *)

(* ========================================================================= *)
(* PACKAGE     : GWPTools`                                                   *)
(* DESCRIPTION : The Master Paclet Loader (Facade). Orchestrates the boot    *)
(*               sequence for the core registries, dispatchers, and engines. *)
(* ========================================================================= *)

Quiet[Remove["Global`GWP"]];

BeginPackage["GWPTools`"]

(* 1. Boot the Database *)
Needs["GWPTools`GWPRegistry`"];

(* 2. Boot the Dispatcher *)
Needs["GWPTools`GWPDispatcher`"];

(* 3. Boot Stable Math Engines *)
Needs["GWPTools`GWPEngine1D`"];

EndPackage[]
