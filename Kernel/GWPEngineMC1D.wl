(* ::Package:: *)

Get["GWPTools`GWPDeveloper`"]
BeginPackage["GWPTools`GWPDeveloper`"]

(* --- MC1D Parameter Bus & Macros --- *)
GWPMC1DARG::usage = "Sequence macro for MC1D parameters.";
GWPMC1DVAL::usage = "Sequence macro for MC1D evaluated parameters.";
(*
(* --- MC1D Parameter Bus Variables --- *)
NSTATES::usage = "Internal MC1D parameter: The total number of component wavepackets.";
PACKEDPARAMS::usage = "Internal MC1D parameter: A 1D packed list containing parameter sequences for the pure states and upper-triangle cross-terms.";
COEFFS::usage = "Internal MC1D parameter: A list of {Re, Im} pairs representing the complex weights of each component.";
NORM::usage = "Internal MC1D parameter: The global normalization constant for the multi-component state.";
NORM2::usage = "Internal MC1D parameter: The squared global normalization constant.";
*)
(* --- MC1D Core Functions --- *)
GWPMC1DPARAM::usage = "Generates a sequence of parameters for a multi-component superposition.";
MC1DIndex::usage = "MC1DIndex[i, j, nStates] maps an (i,j) matrix pair to a 1D packed array index.";

(* --- MC1D Prototype Properties --- *)
GWPMC1DPSIX::usage = "Evaluates the spatial wavefunction for the multi-component state.";
GWPMC1DCSIX::usage = "Evaluates the complex conjugate spatial wavefunction.";
GWPMC1DRHOX::usage = "Evaluates the spatial probability density.";
GWPMC1DCX::usage = "Evaluates the cumulative distribution function.";
GWPMC1DEVOLVE::usage = "Applies a system dynamics function to a multi-component state.";

(* --- MC1D Potential Models --- *) 
GWPMC1DFREE::usage = "Free particle parameters.";
GWPMC1DHO::usage = "Harmonic oscillator parameters.";

EndPackage[]
$ContextPath = DeleteCases[$ContextPath, "GWPTools`GWPDeveloper`"];


BeginPackage["GWPTools`GWPEngineMC1D`"]

Begin["`Private`"]
Needs["GWPTools`GWPEngine1D`"];
Needs["GWPTools`GWPEngineSS1D`"];

(* ALWAYS LOAD THESE LAST *)
Needs["GWPTools`GWPDeveloper`"];
Needs["GWPTools`GWPRegistry`"];


(* --- Sequence Macros --- *)
GWPMC1DARG = Sequence[NSTATES_, PACKEDPARAMS_, COEFFS_, NORM_, NORM2_];
GWPMC1DVAL = Sequence[NSTATES, PACKEDPARAMS, COEFFS, NORM, NORM2];

(* --- Internal Indexing Helper --- *)
MC1DIndex[i_Integer, j_Integer, n_Integer] := (i - 1)*n - (i*(i - 1))/2 + j;

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

  (* 3. Enforce strictly positive physical constants (assuming GWP1DScalarQ is available) *)
  If[!GWP1DScalarQ[h] || TrueQ[h <= 0], Message[GWPMC1DPARAM::posval, "HBAR", h]; Return[$Failed]];
  If[!GWP1DScalarQ[m] || TrueQ[m <= 0], Message[GWPMC1DPARAM::posval, "MASS", m]; Return[$Failed]];

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
  GWPMC1DBUILD[actAA, actXX, actPP, actGG, h, m, c]
];

(* --- The Core Constructor (Mimicking GWPSS1D486) --- *)
GWPMC1DBUILD[AA_, XX_, PP_, GG_, HBAR_, MASS_, CC_] := Module[
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


GWPMC1DEVOLVE[system_][GWPMC1DARG] := Module[{newPacked},
    (* Wrap the system evaluation in { } to prevent Sequence flattening *)
    newPacked = Table[
      {system @@ PACKEDPARAMS[[k]]}, 
      {k, 1, Length[PACKEDPARAMS]}
    ];
    Sequence @@ {NSTATES, newPacked, COEFFS, NORM, NORM2}
];


With[{VAL = GWPMC1DVAL},
  GWPMC1DFREE[t_][GWPMC1DARG] := GWPMC1DEVOLVE[GWP1DFREE[t]][VAL];
  GWPMC1DHO[t_][GWPMC1DARG]   := GWPMC1DEVOLVE[GWP1DHO[t]][VAL];
];


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

GWPMC1DPSIX[x_][arg___] /; !MatchQ[Unevaluated[GWPMC1DPSIX[x]], GWPMC1DPSIX[_Integer]] := GWPMC1DPSIX[0][x][arg];
GWPMC1DCSIX[x_][arg___] /; !MatchQ[Unevaluated[GWPMC1DCSIX[x]], GWPMC1DCSIX[_Integer]] := GWPMC1DCSIX[0][x][arg];
GWPMC1DRHOX[x_][arg___] /; !MatchQ[Unevaluated[GWPMC1DRHOX[x]], GWPMC1DRHOX[_Integer]] := GWPMC1DRHOX[0][x][arg];


GWPMC1DCX[x_][GWPMC1DARG] := Module[
  {diagSum, crossSum, idx, rcI, icI, rcJ, icJ, c12, c21},
  
  diagSum = Sum[
    (COEFFS[[i, 1]]^2 + COEFFS[[i, 2]]^2) * (GWP1DCX[x] @@ PACKEDPARAMS[[MC1DIndex[i, i, NSTATES]]]),
    {i, 1, NSTATES}
  ];
  
  crossSum = Sum[
    idx = MC1DIndex[i, j, NSTATES];
    rcI = COEFFS[[i, 1]]; icI = COEFFS[[i, 2]];
    rcJ = COEFFS[[j, 1]]; icJ = COEFFS[[j, 2]];
    
    c12 = GWP1DC12[x] @@ PACKEDPARAMS[[idx]];
    c21 = GWP1DC21[x] @@ PACKEDPARAMS[[idx]];
    
    (* ci^* cj * c12 + ci cj^* * c21 *)
    (rcI - I*icI)*(rcJ + I*icJ)*c12 + (rcI + I*icI)*(rcJ - I*icJ)*c21
  , {i, 1, NSTATES - 1}, {j, i + 1, NSTATES}];
  
  NORM2 * (diagSum + crossSum)
];


(* --- Unified Potential Registry Chunk --- *)
(* Format: {StringName, BackendSymbol, Template, Category} *)
$potentialsMC1D = {
  {"Free", GWPMC1DFREE, "\"Free\"", "Named"},
  {"HO",   GWPMC1DHO,   "\"HO\"",   "Named"}
};

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

GWPTools`GWPRegistry`GWPRegisterPotentials[$potentialsMC1D, "MC1D"];
GWPTools`GWPRegistry`GWPRegisterExtension[$regMC1D];


End[];

SetAttributes[Evaluate[Names["GWPTools`GWPEngineMC1D`*"]], {ReadProtected}];

EndPackage[]
