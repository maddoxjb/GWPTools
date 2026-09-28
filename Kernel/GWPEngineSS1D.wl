(* ::Package:: *)

(* ::Title:: *)
(*GWPEngineSS1D Package*)


(* ::Section:: *)
(*GWPDeveloper Usage Registration*)


(* ::Subsection:: *)
(*BeginPackage*)


Needs["GWPTools`GWPDeveloper`"]
BeginPackage["GWPTools`GWPDeveloper`"]


If[TrueQ[Global`$GWPDebug], Print["[GWPEngineSS1D] BeginPackage GWPDeveloper"]];

Off[General::shdw];


(* ::Subsection::Closed:: *)
(*Usage Statements*)


(* ::Subsubsection::Closed:: *)
(*Parameters*)


(* --- SS1D Parameter Bus & Macros --- *)
GWPSS1DARG::usage = "Sequence macro for SS1D parameters.";
GWPSS1DVAL::usage = "Sequence macro for SS1D evaluated parameters.";
(*
PARAM11::usage = "Internal SS1D state 1 parameters.";
PARAM22::usage = "Internal SS1D state 2 parameters.";
PARAM12::usage = "Internal SS1D cross-term parameters.";
RC::usage = "Real superposition coefficient.";
IC::usage = "Imaginary superposition coefficient.";
NORM::usage = "Superposition normalization.";
NORM2::usage = "Squared superposition normalization.";
*)
(* --- SS1D Core Functions --- *)
GWPSS1DPARAM::usage = "GWPSS1DPARAM[] returns default superposition parameters.\nGWPSS1DPARAM[alphaList, xList, pList, gammaList] generates a sequence of parameters for a superposition of two GWPs.";
GWP1DPARAM12::usage = "GWP1DPARAM12[param1][param2] generates the cross-term parameter sequence for the overlap of two GWPs.";
GWPSS1DNORM::usage = "GWPSS1DNORM[superParam] extracts the normalization constant for the superposition.";


(* ::Subsubsection::Closed:: *)
(*Prototype Properties*)


GWP1DS12::usage = "GWP1DS12[crossParam] evaluates the complex overlap integral <Psi1|Psi2>.";
GWP1DRS12::usage = "GWP1DRS12[crossParam] evaluates the real part of the overlap integral.";
GWP1DIS12::usage = "GWP1DIS12[crossParam] evaluates the imaginary part of the overlap integral.";

GWPSS1DPSIX::usage = "GWPSS1DPSIX[x][superParam] evaluates the position-space wavefunction for the superposition.\nGWPSS1DPSIX[n][x][superParam] evaluates the n-th spatial derivative.";
GWPSS1DCSIX::usage = "GWPSS1DCSIX[x][superParam] evaluates the complex conjugate position-space wavefunction.\nGWPSS1DCSIX[n][x][superParam] evaluates the n-th spatial derivative.";
GWPSS1DRHOX::usage = "GWPSS1DRHOX[x][superParam] evaluates the probability density for the superposition.\nGWPSS1DRHOX[n][x][superParam] evaluates the n-th spatial derivative.";
GWPSS1DCX::usage = "GWPSS1DCX[x][superParam] evaluates the cumulative distribution function for the superposition.";



(* ::Subsubsection::Closed:: *)
(*Potential Models*)


GWPSS1DEVOLVE::usage = "GWPSS1DEVOLVE[system][superParam] applies a system dynamics function to a superposition.";

(* --- SS1D Potential Models --- *) 
GWPSS1DFREE::usage = "GWPSS1DFREE[t][param] evaluates the free particle parameters.";
GWPSS1DHO::usage = "GWPSS1DHO[t][param] evaluates the standard harmonic oscillator parameters.";
GWPSS1DLINEAR::usage = "GWPSS1DLINEAR[k][t][param] evaluates the linear potential parameters.";
GWPSS1DHARMONIC::usage = "GWPSS1DHARMONIC[omega][t][param] evaluates the harmonic oscillator parameters.";
GWPSS1DPARABOLIC::usage = "GWPSS1DPARABOLIC[omega][t][param] evaluates the parabolic barrier parameters.";
GWPSS1DFHOLIN::usage = "GWPSS1DFHOLIN[omega, A][t][param] evaluates the linear-driven harmonic oscillator parameters.";
GWPSS1DFHORES::usage = "GWPSS1DFHORES[omega, A][t][param] evaluates the resonant-driven harmonic oscillator parameters.";
GWPSS1DFHONON::usage = "GWPSS1DFHONON[omega, A, omega1][t][param] evaluates the non-resonant-driven harmonic oscillator parameters.";


(* ::Subsection::Closed:: *)
(*End*)


Off[General::shdw];

If[TrueQ[Global`$GWPDebug], Print["[GWPEngineSS1D] EndPackage GWPDeveloper"]];

Quiet[EndPackage[], General::shdw]

(* Scrub the Developer context from the global path immediately *)
$ContextPath = DeleteCases[$ContextPath, "GWPTools`GWPDeveloper`"];


(* ::Section:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPEngineSS1D`                                     *)
(* DESCRIPTION : 1D Superposition of GWPs for the GWPTools framework.        *)
(* ========================================================================= *)
BeginPackage["GWPTools`GWPEngineSS1D`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPEngineSS1D] BeginPackage"]];
Begin["`Private`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPEngineSS1D] Begin Private"]];
(* LOAD DEPENDENCIES INTERNALLY *)
Needs["GWPTools`GWPEngine1D`"];

(* ALWAYS LOAD THESE LAST *)
Needs["GWPTools`GWPDeveloper`"];
Needs["GWPTools`GWPRegistry`"];


(* ::Section::Closed:: *)
(*Parameters*)


(* --- Sequence Macros --- *)
GWPSS1DARG = Sequence[PARAM11_, PARAM22_, PARAM12_, RC_, IC_, NORM_, NORM2_];
GWPSS1DVAL = Sequence[PARAM11, PARAM22, PARAM12, RC, IC, NORM, NORM2];


Options[GWPSS1DPARAM] = {"HBAR" -> 1, "MASS" -> 1, "C" -> 1};

GWPSS1DPARAM[OptionsPattern[]] := GWPSS1D486[{1,1}, {-1,1}, {0,0}, {0,0}, OptionValue["HBAR"], OptionValue["MASS"], OptionValue["C"]];
GWPSS1DPARAM[AA_, OptionsPattern[]] := GWPSS1D486[AA, {-1,1}, {0,0}, {0,0}, OptionValue["HBAR"], OptionValue["MASS"], OptionValue["C"]];
GWPSS1DPARAM[AA_, XX_, OptionsPattern[]] := GWPSS1D486[AA, XX, {0,0}, {0,0}, OptionValue["HBAR"], OptionValue["MASS"], OptionValue["C"]];
GWPSS1DPARAM[AA_, XX_, PP_, OptionsPattern[]] := GWPSS1D486[AA, XX, PP, {0,0}, OptionValue["HBAR"], OptionValue["MASS"], OptionValue["C"]];
GWPSS1DPARAM[AA_, XX_, PP_, GG_, OptionsPattern[]] := GWPSS1D486[AA, XX, PP, GG, OptionValue["HBAR"], OptionValue["MASS"], OptionValue["C"]];


GWPSS1D486[AA_, XX_, PP_, GG_, HBAR_, MASS_, CC_] := Module[
  {PARAM11, PARAM22, PARAM12, NORM, NORM2, RC, IC, RS12, IS12},
  
  PARAM11 = GWP1DPARAM[AA[[1]], XX[[1]], PP[[1]], GG[[1]], "HBAR" -> HBAR, "MASS" -> MASS];
  PARAM22 = GWP1DPARAM[AA[[2]], XX[[2]], PP[[2]], GG[[2]], "HBAR" -> HBAR, "MASS" -> MASS];
  
  If[PARAM11 === $Failed || PARAM22 === $Failed, Return[$Failed]];
  
  PARAM12 = GWP1DPARAM12[PARAM11][PARAM22];
  {RC, IC} = ComplexExpand @ ReIm @ CC;
  
  RS12 = GWP1DRS12[PARAM12];
  IS12 = GWP1DIS12[PARAM12];
  
  NORM = 1 / Sqrt[1 + (RC^2 + IC^2) + 2*(RC*RS12 - IC*IS12)];
  NORM2 = 1 / (1 + (RC^2 + IC^2) + 2*(RC*RS12 - IC*IS12));
  
  Sequence @@ {{PARAM11}, {PARAM22}, {PARAM12}, RC, IC, NORM, NORM2}
];

(* GWP PRODUCT (Cross-Term Parameter Sequence Generator) *)
GWP1DPARAM12[RA1_, IA1_, RX1_, RP1_, RG1_, IG1_, NORM1_, HBAR_, MASS_, extra___][RA2_, IA2_, RX2_, RP2_, RG2_, IG2_, NORM2_, ___] := 
  Sequence @@ {
    RA1 + RA2, 
    -IA1 + IA2, 
    (RA1*RX1 + RA2*RX2)/(RA1 + RA2), 
    (RA2*(-RP1 + RP2 + 2*HBAR*IA1*(-RX1 + RX2)) + RA1*(-RP1 + RP2 + 2*HBAR*IA2*(-RX1 + RX2)))/(RA1 + RA2), 
    (RA1*RA2*(-2*RG1 + 2*RG2 + (RP1 + RP2)*(RX1 - RX2)) + RA2^2*(-RG1 + RG2 + (RP1 + HBAR*IA1*(RX1 - RX2))*(RX1 - RX2)) - RA1^2*(RG1 - RG2 - (RX1 - RX2)*(RP2 + HBAR*IA2*(-RX1 + RX2))))/(RA1 + RA2)^2, 
    IG1 + IG2 + (HBAR*RA1*RA2*(RX1 - RX2)^2)/(RA1 + RA2), 
    NORM1*NORM2, 
    HBAR, 
    MASS, 
    extra
  };

GWPSS1DNORM[GWPSS1DARG] = NORM;


(* ::Section::Closed:: *)
(*Potential Models*)


(* Central Wrapper that evolves the sub-states and reconstructs the cross-term *)
GWPSS1DEVOLVE[system_][GWPSS1DARG] := Module[{SYSTEM11, SYSTEM22, SYSTEM12},
    SYSTEM11 = system @@ PARAM11;
    SYSTEM22 = system @@ PARAM22;
    SYSTEM12 = GWP1DPARAM12[SYSTEM11][SYSTEM22];
    Sequence @@ {{SYSTEM11}, {SYSTEM22}, {SYSTEM12}, RC, IC, NORM, NORM2}
    ];

With[{VAL = GWPSS1DVAL},
  (* SS1D Potential Math Definitions (Directly Wrapping 1D Potentials) *)
  GWPSS1DFREE[t_][GWPSS1DARG] := GWPSS1DEVOLVE[GWP1DFREE[t]][VAL];
  GWPSS1DHO[t_][GWPSS1DARG]   := GWPSS1DEVOLVE[GWP1DHO[t]][VAL];
  GWPSS1DLINEAR[FK_:1][t_][GWPSS1DARG] := GWPSS1DEVOLVE[GWP1DLINEAR[FK][t]][VAL];
  GWPSS1DHARMONIC[OMEGA_:1][t_][GWPSS1DARG] := GWPSS1DEVOLVE[GWP1DHARMONIC[OMEGA][t]][VAL];
  GWPSS1DPARABOLIC[OMEGA_:1][t_][GWPSS1DARG] := GWPSS1DEVOLVE[GWP1DPARABOLIC[OMEGA][t]][VAL];
  GWPSS1DFHOLIN[OMEGA_:1, FA_:1/10][t_][GWPSS1DARG] := GWPSS1DEVOLVE[GWP1DFHOLIN[OMEGA, FA][t]][VAL];
  GWPSS1DFHORES[OMEGA_:1, FA_:1/10][t_][GWPSS1DARG] := GWPSS1DEVOLVE[GWP1DFHORES[OMEGA, FA][t]][VAL];
  GWPSS1DFHONON[OMEGA_:1, FA_:1/10, OMEGA1_:2][t_][GWPSS1DARG] := GWPSS1DEVOLVE[GWP1DFHONON[OMEGA, FA, OMEGA1][t]][VAL];
];


(* ::Section::Closed:: *)
(*Overlap integral*)


(* Evaluates on the 1D cross-term sequence GWP1DARG (PARAM12) *)
GWP1DS12[GWP1DARG] = NORM*(E^((-4*HBAR*IG+(4*I)*HBAR*RG+(I*RP^2)/(IA-I*RA))/(4*HBAR^2))*Sqrt[Pi])/Sqrt[I*IA+RA];
GWP1DRS12[GWP1DARG] = NORM*(Sqrt[Pi]*Cos[((4*HBAR*RG + (IA*RP^2)/(IA^2 + RA^2))/HBAR^2 - 2*ArcTan[RA,IA])/4])/(E^((4*HBAR*IG + (RA*RP^2)/(IA^2 + RA^2))/(4*HBAR^2))*(IA^2 + RA^2)^(1/4));
GWP1DIS12[GWP1DARG] = NORM*(Sqrt[Pi]*Sin[((4*HBAR*RG + (IA*RP^2)/(IA^2 + RA^2))/HBAR^2 - 2*ArcTan[RA,IA])/4])/(E^((4*HBAR*IG + (RA*RP^2)/(IA^2 + RA^2))/(4*HBAR^2))*(IA^2 + RA^2)^(1/4));


(* ::Section::Closed:: *)
(*Wavefunction and density*)


GWPSS1DPSIX[n_Integer][x_][GWPSS1DARG] := NORM * ((GWP1DPSIX[n][x] @@ PARAM11) + (RC + I*IC) * (GWP1DPSIX[n][x] @@ PARAM22));
GWPSS1DCSIX[n_Integer][x_][GWPSS1DARG] := NORM * ((GWP1DCSIX[n][x] @@ PARAM11) + (RC - I*IC) * (GWP1DCSIX[n][x] @@ PARAM22));

GWPSS1DRHOX[n_Integer:0][x_][GWPSS1DARG] := Module[{psi12, cpsi12, real12, imag12},
    psi12  = GWP1DPSIX[n][x] @@ PARAM12;
    cpsi12 = GWP1DCSIX[n][x] @@ PARAM12;
    real12 = (psi12 + cpsi12) / 2;
    imag12 = (psi12 - cpsi12) / (2 * I);
    
    NORM2 * (
      (GWP1DRHOX[n][x] @@ PARAM11) + 
      (RC^2 + IC^2) * (GWP1DRHOX[n][x] @@ PARAM22) + 
      2 * RC * real12 - 
      2 * IC * imag12
    )
];

GWPSS1DPSIX[x_][arg___] /; !MatchQ[Unevaluated[GWPSS1DPSIX[x]], GWPSS1DPSIX[_Integer]] := GWPSS1DPSIX[0][x][arg];
GWPSS1DCSIX[x_][arg___] /; !MatchQ[Unevaluated[GWPSS1DCSIX[x]], GWPSS1DCSIX[_Integer]] := GWPSS1DCSIX[0][x][arg];
GWPSS1DRHOX[x_][arg___] /; !MatchQ[Unevaluated[GWPSS1DRHOX[x]], GWPSS1DRHOX[_Integer]] := GWPSS1DRHOX[0][x][arg];


(* ::Section::Closed:: *)
(*Cumulative distribution function*)


GWPSS1DCX[x_][GWPSS1DARG] := Module[{C11, C22, C12, C21},
    C11 = GWP1DCX[x] @@ PARAM11;
    C22 = GWP1DCX[x] @@ PARAM22;
    C12 = GWP1DC12[x] @@ PARAM12;
    C21 = GWP1DC21[x] @@ PARAM12;
    NORM^2*(C11 + (RC^2 + IC^2)*C22 + (RC + I*IC)*C12 + (RC - I*IC)*C21)
];

GWP1DC12[x_][GWP1DARG] := (NORM*Sqrt[Pi])/(2*E^((4*HBAR*(IG - I*RG) + RP^2/(I*IA + RA))/(4*HBAR^2))*Sqrt[I*IA + RA])*(1+Erf[((-1/2*I)*RP)/(HBAR*Sqrt[I*IA + RA]) + Sqrt[I*IA + RA]*(-RX + x)]);
GWP1DC21[x_][GWP1DARG] := (NORM*Sqrt[Pi])/(2*E^((4*HBAR*(IG + I*RG) + RP^2/(-I*IA + RA))/(4*HBAR^2))*Sqrt[-I*IA + RA])*(1+Erf[((1/2*I)*RP)/(HBAR*Sqrt[-I*IA + RA]) + Sqrt[-I*IA + RA]*(-RX + x)]);



(* ::Section::Closed:: *)
(*GWPObject Registration*)


(* ::Subsection::Closed:: *)
(*Potential Model Resolution*)


(* --- Unified Potential Registry Chunk --- *)
(* Format: {StringName, BackendSymbol, Template, Category} *)
$potentialsSS1D = {
  {"Free",                GWPSS1DFREE,      "\"Free\"",                                     "Named"},
  {"HO",                  GWPSS1DHO,        "\"HO\"",                                       "Named"},
  {"Linear",              GWPSS1DLINEAR,    "{\"Linear\", FK}",                             "Parameterized"},
  {"Harmonic",            GWPSS1DHARMONIC,  "{\"Harmonic\", OMEGA}",                        "Parameterized"},
  {"ParabolicBarrier",    GWPSS1DPARABOLIC, "{\"ParabolicBarrier\", OMEGA}",                "Parameterized"},
  {"LinearForcedHO",      GWPSS1DFHOLIN,    "{\"LinearForcedHO\", OMEGA, AK}",              "Parameterized"},
  {"ResonantForcedHO",    GWPSS1DFHORES,    "{\"ResonantForcedHO\", OMEGA, AK}",            "Parameterized"},
  {"NonResonantForcedHO", GWPSS1DFHONON,    "{\"NonResonantForcedHO\", OMEGA, AK, OMEGA1}", "Parameterized"}
};


(* ::Subsection::Closed:: *)
(*Property Resolution and Dispatch*)


$regStaticSS1D = Join[#, {"StaticParameters", "SS1D"}] & /@ {
  {"Normalization", "NORM", "Static", "StaticValue"}
};

$regWaveSS1D = Join[#, {"Wavefunctions", "SS1D"}] & /@ {
  {"WavefunctionX",          "PSIX", "Recursive", "RecursiveSpatial"},
  {"ConjugateWavefunctionX", "CSIX", "Recursive", "RecursiveSpatial"}
};

$regProbSS1D = Join[#, {"Probabilities", "SS1D"}] & /@ {
  {"DensityX",                "RHOX", "Recursive", "RecursiveSpatial"},
  {"CumulativeDistributionX", "CX",   "Field",     "Spatial"}
};


(* --- Registry Assembly --- *)
$regSS1D = Join[$regStaticSS1D, $regWaveSS1D, $regProbSS1D];
Clear[$regStaticSS1D, $regWaveSS1D, $regProbSS1D];


(* ::Subsection::Closed:: *)
(*Register Potentials and Properties*)


GWPTools`GWPRegistry`GWPRegisterPotentials[$potentialsSS1D, "SS1D"];
GWPTools`GWPRegistry`GWPRegisterExtension[$regSS1D];


(* ::Subsection::Closed:: *)
(*User Interface Builder*)


$GWPSS1DLogo = Graphics[{
    Opacity[0.2], Purple, FilledCurve[BezierCurve[{{-1, 0}, {-0.5, 0}, {-0.2, 1}, {0, 1}, {0.2, 1}, {0.5, 0}, {1, 0}}]],
    Opacity[1], Thickness[0.08], Purple, Line[Table[{x, Exp[-4(x-0.2)^2] + Exp[-4(x+0.2)^2]}, {x, -1, 1, 0.05}]],
    Thickness[0.04], Darker[Cyan], Line[Table[{x, 0.3 Sin[20 x] Exp[-4 x^2] - 0.1}, {x, -0.8, 0.8, 0.02}]]
}, ImageSize -> 32, PlotRange -> {{-1.1, 1.1}, {-0.3, 1.5}}];

GWPTools`GWPDeveloper`GWPSS1DUI[data_] := Module[
  {potDisplay, paramsList, h, m, rc, ic, visible, hidden},
  
  potDisplay = data["Potential"];
  paramsList = data["Parameters"];
  
  If[Length[paramsList] >= 7,
    rc = paramsList[[4]]; ic = paramsList[[5]];
    h = paramsList[[1, 8]]; m = paramsList[[1, 9]];
  ,
    rc = "?"; ic = "?"; h = "?"; m = "?";
  ];
  
  visible = {Grid[{
    {Style["System Attributes", Bold], Style["Values", Bold]},
    {"Coeff (Re): ", rc},
    {"Coeff (Im): ", ic},
    {"Potential: ", potDisplay}
  }, Alignment -> Left]};
  
  hidden = {Grid[{
    {"Mass: ", m},
    {"HBar: ", h}
  }, Alignment -> Left]};
  
  {$GWPSS1DLogo, visible, hidden}
];



(* ::Section::Closed:: *)
(*End*)


(* --- End "GWPTools`GWPEngineSS1D`Private`" --- *)

If[TrueQ[Global`$GWPDebug], Print["[GWPEngineSS1D] End Private"]];
End[]

(* Hide internal code for all Developer functions from the ? menu *)
SetAttributes[Evaluate[Names["GWPTools`GWPEngineSS1D`*"]], {ReadProtected}];

(* --- End "GWPTools`GWPEngineSS1D`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPEngineSS1D] EndPackage"]];
EndPackage[]
