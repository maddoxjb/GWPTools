(* ::Package:: *)

(* ::Title:: *)
(*GWPDeveloper Package*)


(* ::Section::Closed:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPDeveloper`                                      *)
(* DESCRIPTION : The master namespace bridge and global developer utilities. *)
(*               Houses the universal parameter dictionary and usage tables. *)
(* ========================================================================= *)
BeginPackage["GWPTools`GWPDeveloper`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPDeveloper] BeginPackage"]];

(* Suppress parse-time shadowing warnings for same-cell evaluations *)
Off[General::shdw];


(* ::Section::Closed:: *)
(*Usage Statements*)


(* ========================================================================= *)
(* UNIVERSAL PARAMETER DICTIONARY                                            *)
(* ------------------------------------------------------------------------- *)
(* These usage statements hoist the Parameter Bus internal symbols into the  *)
(* GWPDeveloper context. This guarantees that all engines and extensions     *)
(* share the exact same variable spaces for pattern matching.                *)
(* ========================================================================= *)

(* --- Core Physical Constants --- *)
NORM::usage = "NORM universal parameter representing the global normalization constant.";
NORM2::usage = "NORM2 universal parameter representing the squared global normalization constant.";
HBAR::usage = "HBAR universal parameter representing the reduced Planck constant.";
MASS::usage = "MASS universal parameter representing the mass of the particle.";
INIT::usage = "INIT universal metadata cache storing time-origin parameters.";

(* --- Phase Space & Shape Variables (1D, 2D, RDM) --- *)
RA::usage = "RA parameter representing the real part of the shape parameter.";
IA::usage = "IA parameter representing the imaginary part of the shape parameter.";
RX::usage = "RX parameter representing the real x-position center.";
IX::usage = "IX parameter representing the imaginary x-position center.";
RP::usage = "RP parameter representing the real p-momentum center.";
IP::usage = "IP parameter representing the imaginary p-momentum center.";
RG::usage = "RG parameter representing the spatially-independent real phase.";
IG::usage = "IG parameter representing the spatially-independent imaginary phase.";

RAXX::usage = "RAXX parameter representing the real xx-component of the width matrix.";
IAXX::usage = "IAXX parameter representing the imaginary xx-component of the width matrix.";
RAYY::usage = "RAYY parameter representing the real yy-component of the width matrix.";
IAYY::usage = "IAYY parameter representing the imaginary yy-component of the width matrix.";
RAXY::usage = "RAXY parameter representing the real xy-component of the cross-coupled width.";
IAXY::usage = "IAXY parameter representing the imaginary xy-component of the cross-coupled width.";
RY::usage = "RY parameter representing the real y-position center.";
IY::usage = "IY parameter representing the imaginary y-position center.";
RPX::usage = "RPX parameter representing the real x-momentum of the wavepacket.";
IPX::usage = "IPX parameter representing the imaginary x-momentum of the wavepacket.";
RPY::usage = "RPY parameter representing the real y-momentum of the wavepacket.";
IPY::usage = "IPY parameter representing the imaginary y-momentum of the wavepacket.";

THETA::usage = "THETA parameter representing the real-valued thermal decoherence width (RDM).";

(* --- Superposition & Multi-State Architecture --- *)
NSTATES::usage = "NSTATES state-tracking parameter representing the total number of component wavepackets.";
PACKEDPARAMS::usage = "PACKEDPARAMS is a packed list containing parameter sequences for pure states and cross-terms.";
PARAM11::usage = "PARAM11 sub-sequence containing the state 1 parameters for an SS1D superposition.";
PARAM22::usage = "PARAM22 sub-sequence containing the state 2 parameters for an SS1D superposition.";
PARAM12::usage = "PARAM12 sub-sequence containing the cross-term parameters for an SS1D superposition.";
RC::usage = "RC parameter representing the real component of a superposition coefficient.";
IC::usage = "IC parameter representing the imaginary component of a superposition coefficient.";
COEFFS::usage = "COEFFS is a parameter array containing complex weight pairs for multi-component states.";

(* --- External Potential Coefficients --- *)
V0::usage = "V0 1D potential coefficient (constant term).";
V1::usage = "V1 1D potential coefficient (x term).";
V2::usage = "V2 1D potential coefficient (x^2 term).";
V00::usage = "V00 2D potential coefficient (constant term).";
V10::usage = "V10 2D potential coefficient (x term).";
V01::usage = "V01 2D potential coefficient (y term).";
V20::usage = "V20 2D potential coefficient (x^2 term).";
V02::usage = "V02 2D potential coefficient (y^2 term).";
V11::usage = "V11 2D potential coefficient (xy term).";

(* ========================================================================= *)
(* DEVELOPER UTILITIES                                                       *)
(* ========================================================================= *)
GWPUsageTable::usage = "GWPUsageTable[{sym1, sym2, ...}] formats the usage statements of the specified symbols into a Dataset.\n" <>
  "GWPUsageTable[..., opts] accepts standard Grid options.";
  
GWPScalarQ::usage = "GWPScalarQ[exp] returns True if exp is a scalar symbol or number.";


(* ::Section::Closed:: *)
(*Private*)


(* Restore the global message state immediately *)
On[General::shdw];
(* --- Private --- *)
Begin["`Private`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPDeveloper] Begin Private"]];


(* ::Section::Closed:: *)
(*Developer Utilities*)


(* --- Usage Table Utility --- *)
Options[GWPUsageTable] = Options[Grid];

GWPUsageTable[symbs_List, opts : OptionsPattern[]] := 
  Module[{gridOpts, header, rows, maxDescWidth = 425}, 
   gridOpts = FilterRules[{opts}, Options[Grid]];
   header = {Text[Style["Signature", Bold, 14]], 
     Text[Style["Description", Bold, 14]]};
   rows = 
    Flatten[Map[
      Function[sym, 
       Module[{rawUsage, symName, match}, 
        rawUsage = Quiet[Information[sym, "Usage"]];
        symName = ToString[sym];
        If[StringQ[rawUsage], 
         Map[Function[line, 
           match = StringCases[line, 
             RegularExpression[
               "^(" <> symName <> "(?:\\[.*?\\])?)\\s+(.*)$"] -> {"$1", 
               "$2"}];
            
           If[Length[match] > 0,
            (* Found a match *)
            {Text[match[[1, 1]]], 
             Pane[Text[
               Style[StringReplace[StringTrim[match[[1, 2]]], 
                 StartOfString ~~ c_ :> ToUpperCase[c]], 
                TextAlignment -> Left, LineIndent -> 0]], 
              ImageSize -> {UpTo[maxDescWidth], Automatic}]}, 
            
            (* No match (continuation line) *)
            {Text[""], 
             Pane[Text[
               Style[StringReplace[StringTrim[line], 
                 StartOfString ~~ c_ :> ToUpperCase[c]], 
                TextAlignment -> Left, LineIndent -> 0]], 
              ImageSize -> {UpTo[maxDescWidth], Automatic}]}]], 
          StringSplit[rawUsage, "\n"]], 
         
         (* No usage string found *)
         {{Text[symName], 
           Text[Style["No usage string defined.", Gray, Italic]]}}]]],
       symbs], 1];
        
   Grid[Prepend[rows, header], Alignment -> {Left, Top}, 
    (* Let both columns size automatically to their contents *)
    ItemSize -> Automatic, Spacings -> {2, 1.5}, 
    Frame -> True, Dividers -> All, 
    Background -> {None, {1 -> GrayLevel[0.95]}}, 
    Sequence @@ gridOpts]];


GWPScalarQ[val_] := FreeQ[val, List];


(* ::Section::Closed:: *)
(*End*)


(* --- End "GWPTools`GWPDeveloper`Private`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPDeveloper] End Private"]];
End[]

(* Hide internal code for all Developer functions from the ? menu *)
SetAttributes[Evaluate[Names["GWPTools`GWPDeveloper`*"]], {ReadProtected}];

(* --- End "GWPTools`GWPDeveloper`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPDeveloper] EndPackage"]];
Quiet[EndPackage[], General::shdw]
