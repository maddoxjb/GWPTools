(* ::Package:: *)

(* ::Title:: *)
(*GWPTools Package*)


(* ::Section::Closed:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools                                                    *)
(* VERSION     : 1.0.0                                                       *)
(* AUTHOR      : Jeremy B. Maddox                                            *)
(* COPYRIGHT   : (c) 2026 Jeremy B. Maddox                                   *)
(* LICENSE     : MIT License (See LICENSE file in root directory)            *)
(* REPOSITORY  : https://github.com/maddoxjb/GWPTools                        *)
(* CITATION    : If you use this software, please cite the companion paper:  *)
(*               [Citation details to be added]                              *)
(* DESCRIPTION : An advanced analytical framework for generalized single     *)
(*               Gaussian Wavepackets (GWPs). Provides exact evaluation of   *)
(*               kinematics, dual-basis hydrodynamics, Bohmian trajectories, *)
(*               and energy density partitioning via a polymorphic API.      *)
(* ========================================================================= *)


(* --- Define Context --- *)
BeginPackage["GWPTools`", {"GWPTools`GWPDeveloper`"}]


(* ::Section::Closed:: *)
(*Usage Statements*)


(* --- GWP and GWPObject Usage Statements --- *)
GWP::usage = "GWP[...] returns a GWPObject representing a generalized Gaussian wavepacket.";

GWPObject::usage = "GWPObject[...] represents a generalized Gaussian wavepacket obtained by GWP."


(* ::Section::Closed:: *)
(*Private*)


Begin["`Private`"]


(* --- Package Environment Setup --- *)
(* Capture the installation directory of the package at load time. *)
(* The '2' tells it to step up one level from the 'Kernel' folder to the package root. *)
$PackageDirectory = Quiet[
  If[$InputFileName =!= "", 
    DirectoryName[$InputFileName, 2], 
    NotebookDirectory[]
  ]
];


(* ::Section:: *)
(*GWP and GWPObject*)


(* ::Subsection::Closed:: *)
(*About*)


(* ========================================================================= *)
(* API INTERFACE & DISPATCH ENGINE                                           *)
(* ------------------------------------------------------------------------- *)
(* This section forms the user-facing bridge to the underlying physics       *)
(* engine. It defines the wavepacket constructor (GWP), the immutable data   *)
(* structure (GWPObject), and the polymorphic evaluation architecture.       *)
(*                                                                           *)
(* ARCHITECTURAL TIERS:                                                      *)
(* 1. Constructor : Validates options, safely builds the core parameter      *)
(*                  sequence, and assembles the GWPObject.                   *)
(* 2. Tier-1      : Introspection layer. Handles queries for package metadata,*)
(*                  property dictionaries, and class structures. Maintains   *)
(*                  strict parity between GWP and GWPObject.                 *)
(* 3. Tier-2      : The Main Dispatcher. Intercepts queries to a constructed *)
(*                  object, returning metadata in O(1) time and routing      *)
(*                  valid physics property requests to Tier-3.               *)
(* 4. Tier-3      : Signature Evaluator. Uses the Master Registry to map     *)
(*                  short-keys to raw package functions, dynamically wrapping*)
(*                  them in the correct functional form (e.g., Function[t]). *)
(* ========================================================================= *)


(* ::Subsection:: *)
(*Potential Model Resolution*)


(* --- Potential Model Resolution & Dispatch --- *)
(* This section defines the external potential energy models available to    *)
(* the GWPObject and dictates how user inputs are validated and routed.      *)
(*                                                                           *)
(* - $GWPPotentialModels     : A reference list of the raw internal          *)
(*                             signatures (e.g., "HO", "LINEAR[FK]").        *)
(* - $GWPPotentialNames      : An Association mapping human-readable strings *)
(*                             (e.g., "HarmonicOscillator") to their         *)
(*                             internal package counterparts.                *)
(* - $GWPPotentialSignatures : A strictly typed pattern registry             *)
(*                             (e.g., FREE | HO | LINEAR[_]) used by the     *)
(*                             Core Constructor to instantly validate inputs.*)
(*                                                                           *)
(* RESOLUTION FLOW:                                                          *)
(* When a user evaluates GWP["Potential" -> sys]:                            *)
(* 1. If sys is a known string name (e.g., "FreeParticle"), it maps directly *)
(*    to the underlying package function (e.g., FREE).                       *)
(* 2. If sys is a direct mathematical signature (e.g., "LINEAR[2]"), it      *)
(*    validates against the pattern registry and passes it directly to the   *)
(*    physics engine.                                                        *)


(* --- Potential Model Signatures --- *)
$GWPPotentialModels = {
   "FREE", 
   "HO", 
   "LINEAR[FK]", 
   "HARMONIC[OMEGA]", 
   "PARABOLIC[OMEGA]", 
   "FHOLIN[OMEGA, AK]", 
   "FHORES[OMEGA, AK]", 
   "FHONON[OMEGA, AK, OMEGA1]"
};

(* --- Named Potentials with Predefined Parameters --- *)
$GWPPotentialNames = <|
   "FreeParticle" -> FREE,
   "HarmonicOscillator" -> HO,
   "LinearPotential" -> LINEAR[1]
|>;

(* --- Internal Pattern Registry for Validation --- *)
$GWPPotentialSignatures = FREE | HO | LINEAR[_] | HARMONIC[_] | PARABOLIC[_] | FHOLIN[_, _] | FHORES[_, _] | FHONON[_, _, _];


(* ::Subsection::Closed:: *)
(*Core Constructor*)


(* --- Error Messages --- *)
GWP::badsum = "The summary mode `1` is not recognized. Valid modes are Automatic, \"PhaseSpace\", \"Energy\", or None.";
GWP::badpot = "The potential `1` is not recognized. Evaluate GWP[\"PotentialNames\"] or GWP[\"PotentialModels\"] for valid options.";

(* --- Core GWPObject Constructor --- *)
Options[GWP] = {
  "Potential" -> "FreeParticle", 
  "HBAR" -> 1, 
  "MASS" -> 1,
  "Summary" -> Automatic
};

(* Condition strictly prevents the constructor from eating string API queries *)
GWP[initialParams___, opts : OptionsPattern[]] /; !MatchQ[First[{initialParams}, Null], _String] := 
  Module[{params, rawSys, finalSys, h, m, sumMode, invalidOpts},
    
    (* Catch Unknown Options *)
    invalidOpts = FilterRules[{opts}, Except[Options[GWP]]];
    If[Length[invalidOpts] > 0,
      Message[General::optx, First[First[invalidOpts]], HoldForm[GWP]];
      Return[$Failed]
    ];
    
    (* Extract Option Values *)
    h = OptionValue["HBAR"];
    m = OptionValue["MASS"];   
    rawSys = OptionValue["Potential"];
    sumMode = OptionValue["Summary"];
    
    (* Validate the "Summary" Option *)
    If[!MemberQ[{Automatic, "PhaseSpace", "Energy", None}, sumMode],
      Message[GWP::badsum, sumMode];
      Return[$Failed]
    ];
    
    (* Validate the "Potential" Option *)
    If[StringQ[rawSys],
      (* Validate String Names *)
      If[!KeyExistsQ[$GWPPotentialNames, rawSys],
        Message[GWP::badpot, rawSys];
        Return[$Failed]
      ],
      (* Validate the Potential Model Signature *)
      If[!MatchQ[rawSys, $GWPPotentialSignatures],
        Message[GWP::badpot, rawSys];
        Return[$Failed]
      ]
    ];
    
    (* Assign final potential *)
    finalSys = Lookup[$GWPPotentialNames, rawSys, rawSys];    
    
    (* Call GWPPARAM and safely catch any cascading failures *)
    params = If[{initialParams} === {Automatic} || {initialParams} === {}, 
       GWPPARAM["HBAR" -> h, "MASS" -> m], 
       GWPPARAM[initialParams, "HBAR" -> h, "MASS" -> m]
    ];
    
    If[params === $Failed, Return[$Failed]];
    
    (* Construct the Object *)
    GWPObject[<|
      "Parameters" -> {params}, 
      "Potential" -> finalSys, 
      "Created" -> Now,
      "Summary" -> sumMode
    |>]
];


(* ::Subsection::Closed:: *)
(*Property Resolution and Dispatch*)


(* --- Master Registry: Property Resolution & Dispatch Mapping --- *)
(* This registry defines the properties accessible via the GWPObject.        *)
(* Each entry follows the exact format:                                      *)
(* {"LongName", "ShortKey", "DispatchType", "PropertyClass"}                 *)
(*                                                                           *)
(* - "LongName"      : The human-readable string used in obj["LongName"].    *)
(* - "ShortKey"      : Maps to the underlying package function ("GWP" <> key).*)
(* - "DispatchType"  : Dictates how the Dispatcher formats the output function*)
(*                     (Assigned via internal cSTATIC, cFIELD, etc. constants)*)
(* - "PropertyClass" : The programmatic group name (e.g., "HydrodynamicsX"). *)
(*                                                                           *)
(* SIGNATURE LEGEND:                                                         *)
(* * Static    (cSTATIC)     : f[params]         -> Evaluated instantly          *)
(* * Temporal  (cTEMP)       : f[params]         -> Returns Function[t]          *)
(* * Field     (cFIELD)      : f[var][params]    -> Returns Function[{var, t}]   *)
(* * Recursive (cREC)        : f[n][var][params] -> Returns Function[{var, t}]   *)
(* * Moment    (cMOM)        : f[n][params]      -> Returns Function[t]          *)
(* * CrossMoment (cCROSSMOM) : f[m,n][params]-> Returns Function[t]              *)
(* * Bivariate (cBIV)        : f[v1, v2][params] -> Returns Function[{v1, v2, t}]*)


(* ::Subsubsection::Closed:: *)
(*StaticParameters*)


$regStatic = Append[#, "StaticParameters"] & /@ {
    {"Normalization",         "NORM",        cSTATIC},
    {"ReducedPlanckConstant", "HBAR",        cSTATIC},
    {"Mass",                  "MASS",        cSTATIC},
    {"InputParameters",       "INPUT",       cSTATIC},
    {"InitialParameters",     "INIT",        cSTATIC},
    {"Assumptions",           "ASSUMPTIONS", cSTATIC}
  };


(* ::Subsubsection::Closed:: *)
(*DynamicParameters*)


$regDynamic = Append[#, "DynamicParameters"] & /@ {
  {"RealShape",             "RA",      cTEMP},
  {"ImaginaryShape",        "IA",      cTEMP},
  {"PositionCenter",        "RX",      cTEMP},
  {"MomentumCenter",        "RP",      cTEMP},
  {"RealPhase",             "RG",      cTEMP},
  {"ImaginaryPhase",        "IG",      cTEMP},
  {"PotentialCoefficients", "PECOEFF", cTEMP} 
};


(*
   {"RealShapeTimeDerivative", "RATD", cTEMP},
   {"ImaginaryShapeTimeDerivative", "IATD", cTEMP},
   {"PositionCenterTimeDerivative", "RXTD", cTEMP},
   {"MomentumCenterTimeDerivative", "RPTD", cTEMP},
   {"RealPhaseTimeDerivative", "RGTD", cTEMP},
   {"ImaginaryPhaseTimeDerivative", "IGTD", cTEMP}
*)


(* ::Subsubsection::Closed:: *)
(*Wavefunctions*)


$regWave = Append[#, "Wavefunctions"] & /@ {
  {"WavefunctionX",          "PSIX", cREC},
  {"ConjugateWavefunctionX", "CSIX", cREC},
  {"WavefunctionP",          "PSIP", cREC},
  {"ConjugateWavefunctionP", "CSIP", cREC},
  {"RealWavefunctionX",      "RSIX", cFIELD},
  {"ImaginaryWavefunctionX", "ISIX", cFIELD},
  {"RealWavefunctionP",      "RSIP", cFIELD},
  {"ImaginaryWavefunctionP", "ISIP", cFIELD}
};


(* ::Subsubsection::Closed:: *)
(*Probabilities*)


$regProb = Append[#, "Probabilities"] & /@ {
  (* Probability Density Functions (PDF) *)
  {"DensityX",                  "RHOX",  cREC},
  {"DensityP",                  "RHOP",  cREC},
  {"DensityE",                  "RHOE",  cFIELD},
  
  (* Cumulative Distribution Functions (CDF) *)
  {"CumulativeDistributionX",   "CX",    cFIELD},
  {"CumulativeDistributionP",   "CP",    cFIELD},
  {"CumulativeDistributionE",   "CE",    cFIELD},
  
  (* Definite Probabilities *)
  {"ProbabilityX",              "PROBX", cBIV},
  {"ProbabilityP",              "PROBP", cBIV},
  {"ProbabilityE",              "PROBE", cBIV}
};


(* ::Subsubsection::Closed:: *)
(*ExpectationValues*)


$regExp = Append[#, "ExpectationValues"] & /@ {
  (* Standard Expectations *)
  {"PositionExpectation",                "EX",    cMOM},
  {"MomentumExpectation",                "EP",    cMOM},
  {"PositionUncertainty",                "UX",    cTEMP},
  {"MomentumUncertainty",                "UP",    cTEMP},
  {"PositionMomentumProductExpectation", "EXP",   cCROSSMOM}, 
  {"MomentumPositionProductExpectation", "EPX",   cCROSSMOM}, 
  {"PositionMomentumCovariance",         "COVXP", cTEMP}, 
  {"PositionMomentumCorrelation",        "CORXP", cTEMP},
  
  (* Force Observables *)
  {"ForceExpectation",                   "EF1",   cTEMP},
  {"ForceSquaredExpectation",            "EF2",   cTEMP},
  {"ForceUncertainty",                   "UF",    cTEMP},
  
  (* Information Theory / Statistical Expectations *)
  {"FisherInformationX",                 "EFIX",  cTEMP},
  {"FisherInformationP",                 "EFIP",  cTEMP}
};


(* ::Subsubsection::Closed:: *)
(*Energies*)


$regEng = Append[#, "Energies"] & /@ {
  (* Energy Expectation *)
  {"KineticEnergyExpectation",                   "EKE",    cMOM},  
  {"PotentialEnergyExpectation",                 "EPE",    cMOM},  
  {"TotalEnergyExpectation",                     "ETE",    cMOM},
  
  (* Energy Uncertainty *)
  {"KineticEnergyUncertainty",                   "UKE",     cTEMP},
  {"PotentialEnergyUncertainty",                 "UPE",     cTEMP},  
  {"TotalEnergyUncertainty",                     "UTE",     cTEMP},
  
  (* Cross Terms (Kinetic & Potential) *)
  {"KineticPotentialEnergyProductExpectation",   "EKEPE",   cCROSSMOM}, 
  {"PotentialKineticEnergyProductExpectation",   "EPEKE",   cCROSSMOM}, 
  {"KineticPotentialEnergyCovariance",           "COVKEPE", cTEMP}, 
  {"KineticPotentialEnergyCorrelation",          "CORKEPE", cTEMP},
  
  (* Hydrodynamic Energy Decompositions *)
  {"InternalKineticEnergyExpectation",           "EIKE",    cTEMP},
  {"ConvectiveKineticEnergyExpectation",         "ECKE",    cTEMP},
  {"InternalPotentialEnergyExpectation",         "EIPE",    cTEMP},
  {"ConvectivePotentialEnergyExpectation",       "ECPE",    cTEMP}
};


(* ::Subsubsection::Closed:: *)
(*HydrodynamicsX*)


$regHydroX = Append[#, "HydrodynamicsX"] & /@ {
  {"AmplitudeX",                "AX",   cFIELD},
  {"PhaseX",                    "SX",   cFIELD},
  {"MomentumFieldX",            "PX",   cFIELD},
  {"VelocityX",                 "VX",   cFIELD},
  {"OsmoticVelocityX",          "OVX",  cFIELD},
  {"CurrentX",                  "JX",   cFIELD},
  
  (* The classical vs quantum potentials *)
  {"QuantumPotentialX",         "QPX",  cFIELD},
  {"QuantumForceX",             "QFX",  cFIELD},
  {"ExternalPotentialX",        "PEX",  cREC},
  {"ExternalForceX",            "FEX",  cREC},
  {"QuantumStressX",            "QSX",  cFIELD},
  
  {"FisherInformationDensityX", "FIX",  cFIELD},
  {"ConvectiveKineticDensityX", "CKEX", cFIELD},
  {"InternalKineticDensityX",   "IKEX", cFIELD},
  {"TotalKineticDensityX",      "TKEX", cFIELD},
  {"TotalPotentialDensityX",    "TPEX", cFIELD},
  {"TotalEnergyDensityX",       "TEDX", cFIELD}
};


(* ::Subsubsection::Closed:: *)
(*HydrodynamicsP*)


$regHydroP = Append[#, "HydrodynamicsP"] & /@ {
  {"AmplitudeP",                  "AP",   cFIELD},
  {"PhaseP",                      "SP",   cFIELD},
  {"PositionFieldP",              "XP",   cFIELD},
  {"ForceFlowP",                  "VP",   cFIELD},
  {"OsmoticFlowP",                "OVP",  cFIELD},
  {"CurrentP",                    "JP",   cFIELD},
  {"QuantumPotentialP",           "QPP",  cFIELD},
  {"QuantumForceP",               "QFP",  cFIELD},
  {"QuantumStressP",              "QSP",  cFIELD},
  
  {"FisherInformationDensityP",   "FIP",  cFIELD},
  {"ConvectivePotentialDensityP", "CPEP", cFIELD},
  {"InternalPotentialDensityP",   "IPEP", cFIELD},
  {"TotalPotentialDensityP",      "TPEP", cFIELD},
  {"TotalKineticDensityP",        "TKEP", cFIELD},
  {"TotalEnergyDensityP",         "TEDP", cFIELD}
};


(* ::Subsubsection::Closed:: *)
(*BohmianTrajectories*)


$regTraj = Append[#, "BohmianTrajectories"] & /@ {
  {"TrajectoryField",             "XC",   cREC},
  {"MomentumTrajectoryField",     "PC",   cREC},
  
  (* Core C-Space Fields *)
  {"AmplitudeC",                  "AC",   cFIELD},
  {"PhaseC",                      "SC",   cFIELD},
  {"DensityC",                    "RHOC", cFIELD},
  {"VelocityC",                   "VC",   cFIELD},
  {"OsmoticVelocityC",            "OVC",  cFIELD},
  {"CurrentC",                    "JC",   cFIELD},
  
  (* Forces & Potentials *)
  {"QuantumPotentialC",           "QPC",  cFIELD},
  {"QuantumForceC",               "QFC",  cFIELD},
  {"ExternalPotentialC",          "PEC",  cREC},   
  {"ExternalForceC",              "FEC",  cREC},   
  {"QuantumStressC",              "QSC",  cFIELD},
  
  (* C-Space Energy & Information Densities *)
  {"FisherInformationDensityC",   "FIC",  cFIELD},
  {"ConvectiveKineticDensityC",   "CKEC", cFIELD},
  {"InternalKineticDensityC",     "IKEC", cFIELD},
  {"TotalKineticDensityC",        "TKEC", cFIELD},
  {"TotalPotentialDensityC",      "TPEC", cFIELD},
  {"TotalEnergyDensityC",         "TEDC", cFIELD}
};


(* ::Subsubsection::Closed:: *)
(*Registry Assembly*)


(* Registry Assembly *)

$GWPRegistry = Join[
  $regStatic, $regDynamic, 
  $regWave, $regProb,
  $regExp, $regEng, 
  $regHydroX, $regHydroP, $regTraj
] /. {
  cSTATIC   -> "Static",
  cTEMP     -> "Temporal",
  cFIELD    -> "Field",
  cREC      -> "Recursive",
  cMOM      -> "Moment",
  cCROSSMOM -> "CrossMoment",
  cBIV      -> "Bivariate"
};

Clear[$regStatic, $regDynamic, $regWave, $regProb, $regExp, $regEng, $regHydroX, $regHydroP, $regTraj];


(* ::Subsection::Closed:: *)
(*Map Builders*)


(* --- Map Builders and Type Verification --- *)
$GWPLongToShort = Association[#1 -> #2 & @@@ $GWPRegistry];
$GWPShortToLong = Association[#2 -> #1 & @@@ $GWPRegistry];
$GWPTypeMap     = Association[#2 -> #3 & @@@ $GWPRegistry];

$GWPStructureClasses = GroupBy[$GWPRegistry, #[[3]] &, Map[#[[1]] &]];
$GWPPropertyClasses  = GroupBy[$GWPRegistry, #[[4]] &, Map[#[[1]] &]];
$GWPAllClasses       = Join[$GWPStructureClasses, $GWPPropertyClasses];

(* --- Signatures Registry --- *)
$GWPSignatures = <|
  "Static"      -> "f[params]",
  "Temporal"    -> "f[params] -> Function[t]",
  "Field"       -> "f[var][params] -> Function[{var, t}]",
  "Recursive"   -> "f[n][var][params] -> Function[{var, t}]",
  "Moment"      -> "f[n][params] -> Function[t]",
  "CrossMoment" -> "f[m, n][params] -> Function[t]",
  "Bivariate"   -> "f[v1, v2][params] -> Function[{v1, v2, t}]"
|>;

(* --- Comprehensive Property Record --- *)
$GWPInformation = Association[
  #[[1]] -> <|
    "ShortKey"       -> #[[2]],
    "StructureClass" -> #[[3]],
    "PropertyClass"  -> #[[4]],
    "Signature"      -> $GWPSignatures[#[[3]]]
  |> & /@ $GWPRegistry
];

(* --- Comprehensive Class Record --- *)
$GWPClassInformation = Association @ KeyValueMap[
  Function[{className, props},
    Module[{isStruct = KeyExistsQ[$GWPStructureClasses, className]},
      className -> <|
        "ClassType" -> If[isStruct, "StructureClass", "PropertyClass"],
        "PropertyCount" -> Length[props],
        If[isStruct,
          "Signature" -> $GWPSignatures[className],
          "ContainedStructures" -> Sort[DeleteDuplicates[Lookup[$GWPInformation, props][[All, "StructureClass"]]]]
        ],
        "Properties" -> props,
        "ShortKeys"  -> Lookup[$GWPLongToShort, props]
      |>
    ]
  ],
  $GWPAllClasses
];

GWPTypeQ[key_, type_] := (Lookup[$GWPTypeMap, key, None] === type);


(* ::Subsection::Closed:: *)
(*Front-End Formatting*)


(* --- Object Formatting --- *)
$GWPLogo = Graphics[{
    Opacity[0.2], Blue, FilledCurve[BezierCurve[{{-1, 0}, {-0.5, 0}, {-0.2, 1}, {0, 1}, {0.2, 1}, {0.5, 0}, {1, 0}}]],
    Opacity[1], Thickness[0.08], Blue, Line[Table[{x, Exp[-4 x^2]}, {x, -1, 1, 0.05}]],
    Thickness[0.04], Darker[Cyan], Line[Table[{x, 0.2 Sin[15 x] Exp[-4 x^2] - 0.1}, {x, -0.8, 0.8, 0.02}]]
  }, ImageSize -> 32, PlotRange -> {{-1.1, 1.1}, {-0.3, 1.1}}];

GWPObject /: MakeBoxes[obj : GWPObject[data_?AssociationQ], format_] := Module[
  {params, pot, assum, init, h, m, initial, x1, p1, ux, up, covxp, phasespace, ecke, eike, eke, ecpe, eipe, epe, ete, energies, mode},
  
  (* Safely extract the raw parameter Sequence *)
  params = pot[0]@@data["Parameters"];
  pot = data["Potential"];

  assum = GWPASSUMPTIONS[params];
 
  (* InitialParameters info *)
  init = InputForm@GWPINPUT[params];
  m    = GWPMASS[params];
  h    = GWPHBAR[params];
  initial = {
        {Style["Input Parameters",Bold],Style["Values",Bold]},   
        {"Parameters: ", init},
        {"Potential: ", pot}, 
        {"Mass: ", m}, 
        {"HBar: ", h}
      };
      
  (* PhaseSpace info *)
  x1 = InputForm@GWPRX[params];
  p1 = InputForm@GWPRP[params];  
  ux  = InputForm@Simplify[GWPUX[params],assum];
  up  = InputForm@Simplify[GWPUP[params],assum];
  covxp  = InputForm@Simplify[GWPCOVXP[params],assum];  
  phasespace={ 
        {Style["Phase space",Bold],Style["Values",Bold]},   
        {"Position center: ", x1}, 
        {"Momentum center: ", p1},
        {"Position uncertainty: ", ux}, 
        {"Momentum uncertainty: ", up},
        {"Covariance: ", covxp}
      };
         
  (* Energies info *)    
  eike = InputForm@Simplify[GWPEIKE[params], assum];  
  ecke = InputForm@Simplify[GWPECKE[params], assum];  
  eke  = InputForm@Simplify[GWPEKE1[params], assum];
  eipe = InputForm@Simplify[GWPEIPE[params], assum];  
  ecpe = InputForm@Simplify[GWPECPE[params], assum];  
  epe  = InputForm@Simplify[GWPEPE1[params], assum];
  ete  = InputForm@Simplify[GWPETE1[params], assum];  
  energies = {
      {Style["Energies",Bold],Style["Values",Bold]},   
      {"Classical KE: ", ecke},
      {"Classical PE: ", ecpe},
      {"Internal KE: ", eike},
      {"Internal PE: ", eipe},
      {"Total KE: ", eke},
      {"Total PE: ", epe},
      {"Total Energy: ", ete}
  };
  
  (* Determine the requested UI mode *)
  mode = Lookup[data, "Summary", Automatic];
  
  Switch[mode,    
	(* None Mode: Bypasses UI entirely. Returns a raw, lightweight string. *)
    None,
    ToBoxes["GWPObject[\[Ellipsis]]", format],
    (* PhaseSpace Mode: Kinematics exposed, inputs hidden *)
    "PhaseSpace",
    BoxForm`ArrangeSummaryBox["GWPObject", obj, $GWPLogo, phasespace, initial, format],
    (* KineticEnergy Mode: Kinetic energy exposed, inputs hidden *)
    "Energy",
    BoxForm`ArrangeSummaryBox["GWPObject", obj, $GWPLogo, energies, initial, format],            
    (* Automatic / Fallback: Inputs and Energy exposed, Kinematics hidden *)
    _,
    BoxForm`ArrangeSummaryBox["GWPObject", obj, $GWPLogo, initial, {}, format]
  ]
];


(* ::Subsection::Closed:: *)
(*Tier-1 Static Introspection*)


(* --- Introspection Error Messages --- *)
GWP::badquery = "The query `1` is invalid or does not support the argument `2`.";
GWPObject::invalidprop = "`1` is not a valid property, class, or data key. Try obj[\"Properties\"] or obj[\"Classes\"].";

(* --- GWPObject Introspection --- *)
GWPObject[data_]["Properties"]          := Sort[Join[Keys[data], Keys[$GWPLongToShort]]];
GWPObject[data_]["ShortKeys"]           := Sort[Values[$GWPLongToShort]];
GWPObject[data_]["PropertyRules"]       := $GWPLongToShort;
GWPObject[data_]["Classes"]             := Sort[Keys[$GWPAllClasses]];
GWPObject[data_]["PropertyClasses"]     := Sort[Keys[$GWPPropertyClasses]];
GWPObject[data_]["StructureClasses"]    := Sort[Keys[$GWPStructureClasses]];
GWPObject[data_]["Signatures"]          := $GWPSignatures;
GWPObject[data_]["PotentialModels"]     := $GWPPotentialModels;
GWPObject[data_]["PotentialNames"]      := Sort[Keys[$GWPPotentialNames]];
GWPObject[data_]["PropertyInformation"] := $GWPInformation;
GWPObject[data_]["ClassInformation"]    := $GWPClassInformation;

(* --- GWP Package-Level Introspection (Parity) --- *)
GWP["Properties"]          := Sort[Keys[$GWPLongToShort]];
GWP["ShortKeys"]           := Sort[Values[$GWPLongToShort]];
GWP["PropertyRules"]       := $GWPLongToShort;
GWP["Classes"]             := Sort[Keys[$GWPAllClasses]];
GWP["PropertyClasses"]     := Sort[Keys[$GWPPropertyClasses]];
GWP["StructureClasses"]    := Sort[Keys[$GWPStructureClasses]];
GWP["Signatures"]          := $GWPSignatures;
GWP["PotentialModels"]     := $GWPPotentialModels; 
GWP["PotentialNames"]      := Sort[Keys[$GWPPotentialNames]];
GWP["PropertyInformation"] := $GWPInformation;
GWP["ClassInformation"]    := $GWPClassInformation;

(* --- 1-Argument Class and Property Pass-Through (GWP Parity) --- *)
GWP::invalidquery = "`1` is not a recognized introspection query, class, or property. Try GWP[\"Properties\"] or GWP[\"Classes\"].";

GWP[query_String] := 
  Which[
    (* 1. Is it a Class request? *)
    KeyExistsQ[$GWPAllClasses, query],
    Sort[$GWPAllClasses[query]],
    
    (* 2. Is it a registered Property? -> Evaluate with default wavepacket *)
    KeyExistsQ[$GWPLongToShort, query] || KeyExistsQ[$GWPTypeMap, query],
    GWP[][query],
    
    (* 3. Fallback: Invalid query *)
    True,
    Message[GWP::invalidquery, query];
    $Failed
  ];


(* ::Subsection::Closed:: *)
(*Tier-1 Filtered Introspection*)


(* --- GWPObject Filtered Introspection --- *)
GWPObject[data_]["PropertyRules", class_String] /; KeyExistsQ[$GWPAllClasses, class] := 
  Association @@ FilterRules[Normal @ $GWPLongToShort, $GWPAllClasses[class]];
  
GWPObject[data_]["ShortKeys", class_String] /; KeyExistsQ[$GWPAllClasses, class] := 
  Sort[Values[FilterRules[Normal @ $GWPLongToShort, $GWPAllClasses[class]]]];
  
GWPObject[data_]["Signatures", class_String] /; KeyExistsQ[$GWPSignatures, class] := 
  $GWPSignatures[class];
  
GWPObject[data_]["ClassInformation", class_String] /; KeyExistsQ[$GWPAllClasses, class] := 
  $GWPClassInformation[class];

(* PropertyInformation routing (Class vs Property) *)
GWPObject[data_]["PropertyInformation", class_String] /; KeyExistsQ[$GWPAllClasses, class] := 
  KeyTake[$GWPInformation, $GWPAllClasses[class]];
  
GWPObject[data_]["PropertyInformation", prop_String] /; KeyExistsQ[$GWPLongToShort, prop] || KeyExistsQ[$GWPShortToLong, prop] := 
  $GWPInformation[Lookup[$GWPShortToLong, prop, prop]];

(* --- GWP Filtered Introspection (Parity) --- *)
GWP["PropertyRules", class_String] /; KeyExistsQ[$GWPAllClasses, class] := 
  Association @@ FilterRules[Normal @ $GWPLongToShort, $GWPAllClasses[class]];
  
GWP["ShortKeys", class_String] /; KeyExistsQ[$GWPAllClasses, class] := 
  Sort[Values[FilterRules[Normal @ $GWPLongToShort, $GWPAllClasses[class]]]];
  
GWP["Signatures", class_String] /; KeyExistsQ[$GWPSignatures, class] := 
  $GWPSignatures[class];
  
GWP["ClassInformation", class_String] /; KeyExistsQ[$GWPAllClasses, class] := 
  $GWPClassInformation[class];

(* PropertyInformation routing (Class vs Property) *)
GWP["PropertyInformation", class_String] /; KeyExistsQ[$GWPAllClasses, class] := 
  KeyTake[$GWPInformation, $GWPAllClasses[class]];
  
GWP["PropertyInformation", prop_String] /; KeyExistsQ[$GWPLongToShort, prop] || KeyExistsQ[$GWPShortToLong, prop] := 
  $GWPInformation[Lookup[$GWPShortToLong, prop, prop]];

(* --- Catch-All for Invalid 2-Argument Queries --- *)
GWPObject[data_][query_String, arg_String] /; MemberQ[{"PropertyRules", "ShortKeys", "Signatures", "PropertyInformation", "ClassInformation"}, query] := 
  (Message[GWP::badquery, query, arg]; $Failed);
  
GWP[query_String, arg_String] /; MemberQ[{"PropertyRules", "ShortKeys", "Signatures", "PropertyInformation", "ClassInformation"}, query] := 
  (Message[GWP::badquery, query, arg]; $Failed);


(* ::Subsection::Closed:: *)
(*Tier-2 Meta Data and Main Dispatcher*)


(* --- Metadata Retrieval --- *)
(* Instantly returns internal data keys like "Parameters", "Potential", "Summary", "Created" *)
GWPObject[data_][prop_String] /; KeyExistsQ[data, prop] := data[prop];

(* --- The Main Dispatcher --- *)
GWPObject[data_][query_String, args___] := Module[{key},
  Which[
    (* 1. Is it a registered property? *)
    KeyExistsQ[$GWPLongToShort, query] || KeyExistsQ[$GWPTypeMap, query],
    key = Lookup[$GWPLongToShort, query, query];
    GWPPropertyDispatch[key, data, args],
    
    (* 2. Is it a 0-argument property class request? *)
    Length[{args}] == 0 && KeyExistsQ[$GWPAllClasses, query],
    Sort[$GWPAllClasses[query]],
    
    (* 3. Not found *)
    True,
    Message[GWPObject::invalidprop, query];
    $Failed
  ]
];


(* ::Subsection::Closed:: *)
(*Tier-3 GWPObject Dispatch Engine*)


(* --- Error Messages --- *)
GWPObject::badorder = "The requested derivative or moment order `1` must be a non-negative integer.";
GWPObject::badargs = "Invalid arguments provided for property `1`. Check the expected signature for this property class.";

(* --- Signature Dispatching (Tier 3) --- *)

(* --- Static --- *)
GWPPropertyDispatch[key_ /; GWPTypeQ[key, "Static"], data_, opts___] := 
  Symbol["GWP" <> key][Sequence @@ data["Parameters"], opts];

(* --- Recursive --- *)
GWPPropertyDispatch[key_ /; GWPTypeQ[key, "Recursive"], data_, n_Integer : 0] /; n >= 0 := 
  Function[{var, t}, Symbol["GWP" <> key][n][var][data["Potential"][t][Sequence @@ data["Parameters"]]]];

(* --- Moment --- *)
GWPPropertyDispatch[key_ /; GWPTypeQ[key, "Moment"], data_, n_Integer : 1] /; n >= 0 := 
  Function[t, Symbol["GWP" <> key][n][data["Potential"][t][Sequence @@ data["Parameters"]]]];

(* --- CrossMoment --- *)
(* Default to 0 arguments: Routes to the fast, hardcoded 1st-order string *)
GWPPropertyDispatch[key_ /; GWPTypeQ[key, "CrossMoment"], data_] := 
  Function[t, Symbol["GWP" <> key][data["Potential"][t][Sequence @@ data["Parameters"]]]];
(* With m and n arguments: Routes to the arbitrary [m, n] engine *)
GWPPropertyDispatch[key_ /; GWPTypeQ[key, "CrossMoment"], data_, m_Integer, n_Integer] /; m >= 0 && n >= 0 := 
  Function[t, Symbol["GWP" <> key][m, n][data["Potential"][t][Sequence @@ data["Parameters"]]]];

(* --- Field --- *)
GWPPropertyDispatch[key_ /; GWPTypeQ[key, "Field"], data_] := 
  Function[{var, t}, Symbol["GWP" <> key][var][data["Potential"][t][Sequence @@ data["Parameters"]]]];

(* --- Bivariate --- *)
GWPPropertyDispatch[key_ /; GWPTypeQ[key, "Bivariate"], data_] := 
  Function[{v1, v2, t}, Symbol["GWP" <> key][v1, v2][data["Potential"][t][Sequence @@ data["Parameters"]]]];

(* --- Temporal --- *)
GWPPropertyDispatch[key_ /; GWPTypeQ[key, "Temporal"], data_] := 
  Function[t, Symbol["GWP" <> key][data["Potential"][t][Sequence @@ data["Parameters"]]]];

(* --- Fallbacks --- *)
GWPPropertyDispatch[key_ /; (GWPTypeQ[key, "Recursive"] || GWPTypeQ[key, "Moment"]), data_, badArg_Integer ? Negative] := (
  Message[GWPObject::badorder, badArg];
  $Failed
);

GWPPropertyDispatch[key_, data_, badArgs___] := (
  Message[GWPObject::badargs, key];
  $Failed
);


(* ::Section::Closed:: *)
(*End*)


End[]


(* Hide internal code for all Public functions from the ? menu *)
SetAttributes[Evaluate[Names["GWPTools`*"]], {ReadProtected}];


EndPackage[]
