(* ::Package:: *)

(* ::Title:: *)
(*GWPEngineMC1D Package*)


(* ::Section::Closed:: *)
(*GWPDeveloper Usage Registration*)


(* ::Subsection::Closed:: *)
(*BeginPackage*)


(* --- Hoist Usage Statements into the Developer Context --- *)
Needs["GWPTools`GWPDeveloper`"]
BeginPackage["GWPTools`GWPDeveloper`"]

If[TrueQ[Global`$GWPDebug], Print["[GWPEngineMC1D] BeginPackage GWPDeveloper"]];

Off[General::shdw];


(* ::Subsection::Closed:: *)
(*Usage Statements*)


(* ::Subsubsection::Closed:: *)
(*Parameters*)


(* --- MC1D Parameter Bus & Macros --- *)
GWPMC1DARG::usage = "Sequence macro for MC1D parameters.";
GWPMC1DVAL::usage = "Sequence macro for MC1D evaluated parameters.";

(* --- MC1D Core Functions --- *)
GWPMC1DPARAM::usage = "Generates a sequence of parameters for a multi-component superposition.";
MC1DIndex::usage = "MC1DIndex[i, j, nStates] maps an (i,j) matrix pair to a 1D packed array index.";

(* --- MC1D Parameter Extraction --- *)
GWPMC1DNSTATES::usage = "GWPMC1DNSTATES[param] extracts the total number of component states.";
GWPMC1DPACKEDPARAMS::usage = "GWPMC1DPACKEDPARAMS[param] extracts the 1D packed array of pure state and cross-term parameters.";
GWPMC1DCOEFFS::usage = "GWPMC1DCOEFFS[param] extracts the array of complex weight pairs {Re, Im}.";
GWPMC1DNORM::usage = "GWPMC1DNORM[param] extracts the global normalization constant.";
GWPMC1DNORM2::usage = "GWPMC1DNORM2[param] extracts the squared global normalization constant.";


(* ::Subsubsection::Closed:: *)
(*Properties & UI*)


(* --- MC1D Prototype Properties --- *)
GWPMC1DPSIX::usage = "GWPMC1DPSIX[x][param] evaluates the spatial wavefunction for the multi-component state.";
GWPMC1DCSIX::usage = "GWPMC1DCSIX[x][param] evaluates the complex conjugate spatial wavefunction.";
GWPMC1DRHOX::usage = "GWPMC1DRHOX[x][param] evaluates the spatial probability density.";
GWPMC1DCX::usage = "GWPMC1DCX[x][param] evaluates the cumulative distribution function.";

(* --- UI Builder --- *)
GWPMC1DUI::usage = "GWPMC1DUI[data] generates the formatted visible and hidden grid elements for the frontend MC1D Summary Box.";


(* ::Subsubsection::Closed:: *)
(*Potential Models*)


GWPMC1DEVOLVE::usage = "GWPMC1DEVOLVE[system][param] applies a system dynamics function to a multi-component state.";

(* --- MC1D Potential Models --- *) 
GWPMC1DFREE::usage = "GWPMC1DFREE[t][param] evaluates the free particle parameters for the multi-component state.";
GWPMC1DHO::usage = "GWPMC1DHO[t][param] evaluates the harmonic oscillator parameters for the multi-component state.";


(* ::Subsection::Closed:: *)
(*EndPackage*)


Off[General::shdw];

If[TrueQ[Global`$GWPDebug], Print["[GWPEngineMC1D] EndPackage GWPDeveloper"]];

Quiet[EndPackage[], General::shdw]

(* Scrub the Developer context from the global path immediately *)
$ContextPath = DeleteCases[$ContextPath, "GWPTools`GWPDeveloper`"];


(* ::Section::Closed:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPEngineMC1D`                                     *)
(* DESCRIPTION : The core mathematical engine for 1D generalized             *)
(*               superposition of Gaussian wavepackets.                      *)
(* ========================================================================= *)

(* --- Open the Actual Engine Package --- *)
BeginPackage["GWPTools`GWPEngineMC1D`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPEngineMC1D] BeginPackage"]];

Begin["`Private`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPEngineMC1D] Begin Private"]];

Needs["GWPTools`GWPEngine1D`"];
Needs["GWPTools`GWPEngineSS1D`"];
Needs["GWPTools`GWPDeveloper`"];
Needs["GWPTools`GWPRegistry`"];


(* ::Section::Closed:: *)
(*Parameters*)


(* ::Subsection::Closed:: *)
(*GWPMC1DARG/GWPMC1DVAL*)


(* --- Sequence Macros --- *)
GWPMC1DARG = Sequence[NSTATES_, PACKEDPARAMS_, COEFFS_, NORM_, NORM2_];
GWPMC1DVAL = Sequence[NSTATES, PACKEDPARAMS, COEFFS, NORM, NORM2];

(* --- Internal Indexing Helper --- *)
MC1DIndex[i_Integer, j_Integer, n_Integer] := (i - 1)*n - (i*(i - 1))/2 + j;


(* ::Subsection::Closed:: *)
(*GWPMC1DPARAM*)


(* --- Options and Messages --- *)
Options[GWPMC1DPARAM] = {"HBAR" -> 1, "MASS" -> 1, "C" -> {1}};

GWPMC1DPARAM::posval = "The value of `1` (`2`) must be a strictly positive scalar.";
GWPMC1DPARAM::arglen = "Parameter lists (AA, XX, PP, GG) must have the same length.";

(* --- Parameter Generator --- *)
GWPMC1DPARAM[
  AA : Except[_Rule | _RuleDelayed] : {1, 1}, 
  XX : Except[_Rule | _RuleDelayed] : Automatic, 
  PP : Except[_Rule | _RuleDelayed] : Automatic, 
  GG : Except[_Rule | _RuleDelayed] : Automatic, 
  opts : OptionsPattern[]
] := Module[{h, m, c, invalidOpts, actAA, actXX, actPP, actGG, n},
  
  (* 1. Catch Unknown Options *)
  invalidOpts = FilterRules[{opts}, Except[Options[GWPMC1DPARAM]]];
  If[Length[invalidOpts] > 0,
    Message[General::optx, First[First[invalidOpts]], HoldForm[GWPMC1DPARAM]];
    Return[$Failed]
  ];

  (* 2. Extract Option Values *)  
  h = OptionValue["HBAR"];
  m = OptionValue["MASS"];
  c = OptionValue["C"];

  (* 3. Enforce strictly positive physical constants *)
  If[!GWPScalarQ[h] || TrueQ[h <= 0], Message[GWPMC1DPARAM::posval, "HBAR", h]; Return[$Failed]];
  If[!GWPScalarQ[m] || TrueQ[m <= 0], Message[GWPMC1DPARAM::posval, "MASS", m]; Return[$Failed]];

  (* 4. Standardize Lists and Resolve Automatics *)
  actAA = Flatten[{AA}];
  n = Length[actAA];
  
  (* If XX is omitted, mimic the legacy default behavior *)
  actXX = If[XX === Automatic, 
            If[n == 2 && actAA === {1, 1}, {-1, 1}, ConstantArray[0, n]], 
            Flatten[{XX}]];
            
  actPP = If[PP === Automatic, ConstantArray[0, n], Flatten[{PP}]];
  actGG = If[GG === Automatic, ConstantArray[0, n], Flatten[{GG}]];

  (* 5. Enforce array length matching *)
  If[Length[actXX] != n || Length[actPP] != n || Length[actGG] != n,
    Message[GWPMC1DPARAM::arglen]; Return[$Failed]
  ];

  (* 6. Proceed to internal engine builder *)
  GWPMC1D486[actAA, actXX, actPP, actGG, h, m, c]
];


(* ::Subsection::Closed:: *)
(*GWPMC1D486*)


(* --- The Core Constructor --- *)
GWPMC1D486[AA_, XX_, PP_, GG_, HBAR_, MASS_, CC_] := Module[
  {nStates, rawDiags, packedParams, paddedCC, coeffPairs, norm, norm2, rcI, icI, rcJ, icJ, rs12, is12, overlapSum, idx},
  
  nStates = Length[AA];
  
  (* 1. Safety padding for coefficients: handles scalars or short lists automatically *)
  paddedCC = PadRight[Flatten[{CC}], nStates, 1];
  
  (* 2. Build the pure states, wrapped in Lists to prevent Sequence flattening *)
  rawDiags = Table[
    {GWP1DPARAM[AA[[i]], XX[[i]], PP[[i]], GG[[i]], "HBAR" -> HBAR, "MASS" -> MASS]},
    {i, 1, nStates}
  ];
  
  If[MemberQ[rawDiags, {$Failed}], Return[$Failed]];
  
  (* 3. Build the packed 1D array of parameter lists *)
  packedParams = Flatten[
    Table[
      If[i == j, 
        rawDiags[[i]], 
        {GWP1DPARAM12[Sequence @@ rawDiags[[i]]][Sequence @@ rawDiags[[j]]]}
      ], 
      {i, 1, nStates}, {j, i, nStates}
    ], 
    1
  ];
  
  (* 4. Process Coefficients into {Real, Imaginary} pairs *)
  coeffPairs = Map[{Re[#], Im[#]} &, ComplexExpand[paddedCC]];
  
  (* 5. Calculate Normalization *)
  overlapSum = 0;
  
  overlapSum += Sum[coeffPairs[[i, 1]]^2 + coeffPairs[[i, 2]]^2, {i, 1, nStates}];
  
  Do[
    idx = MC1DIndex[i, j, nStates];
    rcI = coeffPairs[[i, 1]]; icI = coeffPairs[[i, 2]];
    rcJ = coeffPairs[[j, 1]]; icJ = coeffPairs[[j, 2]];
    
    rs12 = GWP1DRS12[Sequence @@ packedParams[[idx]]];
    is12 = GWP1DIS12[Sequence @@ packedParams[[idx]]];
    
    overlapSum += 2 * ((rcI*rcJ + icI*icJ)*rs12 - (rcI*icJ - icI*rcJ)*is12);
  , {i, 1, nStates - 1}, {j, i + 1, nStates}];
  
  norm2 = 1 / overlapSum;
  norm = Sqrt[norm2];
  
  Sequence @@ {nStates, packedParams, coeffPairs, norm, norm2}
];


(* ::Subsection::Closed:: *)
(*Parameter Extractors*)


(* --- GWPMC1D Parameter Extraction ---*)
GWPMC1DNSTATES[GWPMC1DARG] = NSTATES;
GWPMC1DPACKEDPARAMS[GWPMC1DARG] = PACKEDPARAMS;
GWPMC1DCOEFFS[GWPMC1DARG] = COEFFS;
GWPMC1DNORM[GWPMC1DARG] = NORM;
GWPMC1DNORM2[GWPMC1DARG] = NORM2;


(* ::Section::Closed:: *)
(*Potential Models*)


GWPMC1DEVOLVE[system_][GWPMC1DARG] := Module[{newDiags, newPacked},
    (* 1. Evolve ONLY the pure diagonal states *)
    newDiags = Table[
      {system @@ PACKEDPARAMS[[MC1DIndex[i, i, NSTATES]]]}, 
      {i, 1, NSTATES}
    ];
    
    (* 2. Dynamically rebuild the cross-terms from the evolved states *)
    newPacked = Flatten[
      Table[
        If[i == j, 
          newDiags[[i]], 
          {GWP1DPARAM12[Sequence @@ newDiags[[i]]][Sequence @@ newDiags[[j]]]}
        ], 
        {i, 1, NSTATES}, {j, i, NSTATES}
      ], 
      1
    ];
    
    Sequence @@ {NSTATES, newPacked, COEFFS, NORM, NORM2}
];

With[{VAL = GWPMC1DVAL},
  GWPMC1DFREE[t_][GWPMC1DARG] := GWPMC1DEVOLVE[GWP1DFREE[t]][VAL];
  GWPMC1DHO[t_][GWPMC1DARG]   := GWPMC1DEVOLVE[GWP1DHO[t]][VAL];
];


(* ::Section::Closed:: *)
(*Properties*)


GWPMC1DPSIX[n_Integer][x_][GWPMC1DARG] := NORM * Sum[
  (COEFFS[[i, 1]] + I*COEFFS[[i, 2]]) * (GWP1DPSIX[n][x] @@ PACKEDPARAMS[[MC1DIndex[i, i, NSTATES]]]), 
  {i, 1, NSTATES}
];

GWPMC1DCSIX[n_Integer][x_][GWPMC1DARG] := NORM * Sum[
  (COEFFS[[i, 1]] - I*COEFFS[[i, 2]]) * (GWP1DCSIX[n][x] @@ PACKEDPARAMS[[MC1DIndex[i, i, NSTATES]]]), 
  {i, 1, NSTATES}
];

GWPMC1DRHOX[n_Integer:0][x_][GWPMC1DARG] := Module[
  {diagSum, crossSum, idx, rcI, icI, rcJ, icJ, rcIJ, icIJ, psiIJ, cpsiIJ, realIJ, imagIJ},
  
  diagSum = Sum[
    (COEFFS[[i, 1]]^2 + COEFFS[[i, 2]]^2) * (GWP1DRHOX[n][x] @@ PACKEDPARAMS[[MC1DIndex[i, i, NSTATES]]]),
    {i, 1, NSTATES}
  ];
  
  crossSum = Sum[
    idx = MC1DIndex[i, j, NSTATES];
    rcI = COEFFS[[i, 1]]; icI = COEFFS[[i, 2]];
    rcJ = COEFFS[[j, 1]]; icJ = COEFFS[[j, 2]];
    
    (* Re and Im parts of ci^* cj without using Conjugate *)
    rcIJ = rcI*rcJ + icI*icJ;
    icIJ = rcI*icJ - icI*rcJ;
    
    psiIJ  = GWP1DPSIX[n][x] @@ PACKEDPARAMS[[idx]];
    cpsiIJ = GWP1DCSIX[n][x] @@ PACKEDPARAMS[[idx]];
    realIJ = (psiIJ + cpsiIJ) / 2;
    imagIJ = (psiIJ - cpsiIJ) / (2 * I);
    
    2 * rcIJ * realIJ - 2 * icIJ * imagIJ
  , {i, 1, NSTATES - 1}, {j, i + 1, NSTATES}];
  
  NORM2 * (diagSum + crossSum)
];

(* Fallback: Route spatial coordinate queries to the 0th derivative *)
GWPMC1DPSIX[x_][arg1_, arg2_, rest___] := GWPMC1DPSIX[0][x][arg1, arg2, rest];
GWPMC1DCSIX[x_][arg1_, arg2_, rest___] := GWPMC1DCSIX[0][x][arg1, arg2, rest];
GWPMC1DRHOX[x_][arg1_, arg2_, rest___] := GWPMC1DRHOX[0][x][arg1, arg2, rest];


GWPMC1DCX[x_][GWPMC1DARG] := Module[
  {diagSum, crossSum, idx, rcI, icI, rcJ, icJ, rcIJ, icIJ, c12, c21},
  
  diagSum = Sum[
    (COEFFS[[i, 1]]^2 + COEFFS[[i, 2]]^2) * (GWP1DCX[x] @@ PACKEDPARAMS[[MC1DIndex[i, i, NSTATES]]]),
    {i, 1, NSTATES}
  ];
  
  crossSum = Sum[
    idx = MC1DIndex[i, j, NSTATES];
    rcI = COEFFS[[i, 1]]; icI = COEFFS[[i, 2]];
    rcJ = COEFFS[[j, 1]]; icJ = COEFFS[[j, 2]];
    
    (* Re and Im parts of ci^* cj without using Conjugate *)
    rcIJ = rcI*rcJ + icI*icJ;
    icIJ = rcI*icJ - icI*rcJ;
    
    c12 = GWP1DC12[x] @@ PACKEDPARAMS[[idx]];
    c21 = GWP1DC21[x] @@ PACKEDPARAMS[[idx]];
    
    (* ci^* cj * c12 + ci cj^* * c21 *)
    (rcIJ + I*icIJ) * c12 + (rcIJ - I*icIJ) * c21
  , {i, 1, NSTATES - 1}, {j, i + 1, NSTATES}];
  
  NORM2 * (diagSum + crossSum)
];


(* ::Section::Closed:: *)
(*GWPObject Registration*)


(* ::Subsection::Closed:: *)
(*Potential Model Resolution*)


(* --- Unified Potential Registry Chunk --- *)
(* Format: {StringName, BackendSymbol, Template, Category} *)
$potentialsMC1D = {
  {"Free", GWPMC1DFREE, "\"Free\"", "Named"},
  {"HO",   GWPMC1DHO,   "\"HO\"",   "Named"}
};

GWPTools`GWPRegistry`GWPRegisterPotentials[$potentialsMC1D, "MC1D"];
Clear[$potentialsMC1D];


(* ::Subsection::Closed:: *)
(*Property Resolution and Dispatch*)


$regStaticMC1D = Join[#, {"StaticParameters", "MC1D"}] & /@ {
  {"Normalization", "NORM", "Static", "StaticValue"}
};

$regWaveMC1D = Join[#, {"Wavefunctions", "MC1D"}] & /@ {
  {"WavefunctionX",          "PSIX", "Recursive", "RecursiveSpatial"},
  {"ConjugateWavefunctionX", "CSIX", "Recursive", "RecursiveSpatial"}
};

$regProbMC1D = Join[#, {"Probabilities", "MC1D"}] & /@ {
  {"DensityX",                "RHOX", "Recursive", "RecursiveSpatial"},
  {"CumulativeDistributionX", "CX",   "Field",     "Spatial"}
};

$regMC1D = Join[$regStaticMC1D, $regWaveMC1D, $regProbMC1D];
Clear[$regStaticMC1D, $regWaveMC1D, $regProbMC1D];

GWPTools`GWPRegistry`GWPRegisterExtension[$regMC1D];
Clear[$regMC1D];


(* ::Subsection::Closed:: *)
(*User Interface Builder*)


(* ========================================================================= *)
(* FRONT-END FORMATTING (UI Builder)                                         *)
(* ========================================================================= *)

$GWPMC1DLogo=Graphics[{
Opacity[0.2],Darker@Blue,
Polygon[{{-1,0},Sequence@@Table[{x,0.8 Exp[-20 (x+0.5)^2]},{x,-1,1,0.05}],{1,0}}],
Polygon[{{-1,0},Sequence@@Table[{x,1.0 Exp[-15 x^2]},{x,-1,1,0.025}],{1,0}}],
Polygon[{{-1,0},Sequence@@Table[{x,0.6 Exp[-30 (x-0.5)^2]},{x,-1,1,0.025}],{1,0}}],
Darker@Cyan,Opacity[1],Thickness[0.025],
Line[Table[{x,0.8 Exp[-20 (x+0.5)^2]},{x,-1,1,0.025}]],
Line[Table[{x,1.0 Exp[-15 x^2]},{x,-1,1,0.025}]],
Line[Table[{x,0.6 Exp[-30 (x-0.5)^2]},{x,-1,1,0.025}]],
Opacity[1],Thickness[0.04],Darker@Blue,Line[Table[{x,0.8 Exp[-20 (x+0.5)^2]+1.0 Exp[-15 x^2]+0.6 Exp[-30 (x-0.5)^2]},{x,-1,1,0.025}]]
},ImageSize->32,PlotRange->{{-1,1},{-0.1,1.1}},AspectRatio->1];

GWPTools`GWPDeveloper`GWPMC1DUI[data_] := Module[
  {potDisplay, paramsList, nStates, visible, hidden},
  
  potDisplay = data["Potential"];
  paramsList = data["Parameters"];
  
  If[Length[paramsList] >= 5,
    nStates = paramsList[[1]];
  ,
    nStates = "?";
  ];
  
  visible = {Grid[{
    {Style["System Attributes", Bold], Style["Values", Bold]},
    {"Component States: ", nStates},
    {"Potential: ", potDisplay}
  }, Alignment -> Left]};
  
  hidden = {Grid[{
    {"Type: ", "Multi-Component Superposition"}
  }, Alignment -> Left]};
  
  {$GWPMC1DLogo, visible, hidden}
];


(* ::Section::Closed:: *)
(*End*)


(* --- End "GWPTools`GWPEngineMC1D`Private`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPEngineMC1D] End Private"]];
End[]

(* Hide internal code for all Developer functions from the ? menu *)
SetAttributes[Evaluate[Names["GWPTools`GWPEngineMC1D`*"]], {ReadProtected}];

(* --- End "GWPTools`GWPEngineMC1D`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPEngineMC1D] EndPackage"]];
EndPackage[]
