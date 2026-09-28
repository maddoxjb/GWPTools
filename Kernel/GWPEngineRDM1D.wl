(* ::Package:: *)

(* ::Package:: *)
(**)


Needs["GWPTools`GWPDeveloper`"]
BeginPackage["GWPTools`GWPDeveloper`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPEngineRDM1D] BeginPackage GWPDeveloper"]];

Off[General::shdw];


GWPRDM1DARG::usage = "Sequence macro for RDM1D parameters.";
GWPRDM1DVAL::usage = "Sequence macro for RDM1D evaluated parameters.";
GWPRDM1DPARAM::usage = "Generates a sequence of parameters for a Gaussian Reduced Density Matrix.";
GWPRDM1D486::usage = "Internal engine for parsing RDM inputs.";


(* --- GWPRDM1D Parameter Extraction --- *)
GWPRDM1DRA::usage = "GWPRDM1DRA[param] extracts the real shape parameter.";
GWPRDM1DIA::usage = "GWPRDM1DIA[param] extracts the imaginary shape parameter.";
GWPRDM1DRX::usage = "GWPRDM1DRX[param] extracts the position center.";
GWPRDM1DRP::usage = "GWPRDM1DRP[param] extracts the momentum center.";
GWPRDM1DRG::usage = "GWPRDM1DRG[param] extracts the real phase parameter.";
GWPRDM1DIG::usage = "GWPRDM1DIG[param] extracts the imaginary phase parameter.";
GWPRDM1DTHETA::usage = "GWPRDM1DTHETA[param] extracts the thermal decoherence parameter.";
GWPRDM1DNORM::usage = "GWPRDM1DNORM[param] extracts the normalization constant.";
GWPRDM1DMASS::usage = "GWPRDM1DMASS[param] extracts the mass.";
GWPRDM1DHBAR::usage = "GWPRDM1DHBAR[param] extracts the reduced Planck constant.";
GWPRDM1DPECOEFF::usage = "GWPRDM1DPECOEFF[param] extracts the external potential coefficients.";
GWPRDM1DINPUT::usage = "GWPRDM1DINPUT[param] extracts the input parameters.";
GWPRDM1DINIT::usage = "GWPRDM1DINIT[param] extracts the processed initial parameters.";


(* --- RDM1D Potential Models --- *)
GWPRDM1DFREE::usage = "GWPRDM1DFREE[t][param] evaluates the free particle parameters for the reduced density matrix.";

GWPRDM1DHARMONIC::usage = "GWPRDM1DHARMONIC[omega][t][param] evaluates the harmonic oscillator parameters for the reduced density matrix.";

GWPRDM1DFREECL::usage = "GWPRDM1DFREECL[gamma, kT][t][param] evaluates the free particle parameters under Caldeira-Leggett thermal decoherence.";

GWPRDM1DHARMONICCL::usage = "GWPRDM1DHARMONICCL[omega, gamma, kT][t][param] evaluates the harmonic oscillator parameters under Caldeira-Leggett thermal decoherence.";

GWPRDM1DRHOXX::usage = "Evaluates the spatial density matrix rho(x, y).";
GWPRDM1DRHOX::usage = "Evaluates the diagonal probability density rho(x, x).";

Off[General::shdw];
If[TrueQ[Global`$GWPDebug], Print["[GWPEngineRDM1D] EndPackage GWPDeveloper"]];
Quiet[EndPackage[], General::shdw]

$ContextPath = DeleteCases[$ContextPath, "GWPTools`GWPDeveloper`"];

BeginPackage["GWPTools`GWPEngineRDM1D`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPEngineRDM1D] BeginPackage"]];

Begin["`Private`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPEngineRDM1D] Begin Private"]];

Needs["GWPTools`GWPDeveloper`"];
Needs["GWPTools`GWPRegistry`"];

(* --- 1. The 12-Element Parameter Bus --- *)
GWPRDM1DARG = Sequence[RA_, IA_, RX_, RP_, RG_, IG_, THETA_, NORM_, HBAR_, MASS_, {V0_, V1_, V2_}, INIT_];
GWPRDM1DVAL = Sequence[RA,  IA,  RX,  RP,  RG,  IG,  THETA,  NORM,  HBAR,  MASS,  {V0,  V1,  V2},  INIT];

Options[GWPRDM1DPARAM] = {"HBAR" -> 1, "MASS" -> 1};

GWPRDM1DPARAM[
  AA_: 1/4, XX_: 0, PP_: 0, GG_: 0, TT_: 0, 
  opts: OptionsPattern[]
] := Module[{h, m},
  h = OptionValue["HBAR"];
  m = OptionValue["MASS"];
  GWPRDM1D486[AA, XX, PP, GG, TT, h, m]
];

GWPRDM1D486[A1_, X1_, P1_, G1_, T1_, HBAR_, MASS_] := Module[{
  RA1, IA1, RX1, RP1, RG1, IG1, THETA1, NORM1, PECOEFF, INIT1, PARAM
},
  (* Simplified parsing for prototype *)
  {RA1, IA1} = ComplexExpand[ReIm[A1]];
  {RX1, RP1} = {X1, P1};
  {RG1, IG1} = ComplexExpand[ReIm[G1]];
  THETA1 = T1;
  NORM1 = 1; (* RDM normalization is enforced by RG *)
  PECOEFF = {0, 0, 0};
  INIT1 = {RA1, IA1, RX1, RP1, RG1, IG1, THETA1};

  PARAM = Sequence @@ {RA1, IA1, RX1, RP1, RG1, IG1, THETA1, NORM1, HBAR, MASS, PECOEFF, INIT1};
  PARAM
];


(* --- GWPRDM1D Parameter Extraction ---*)
GWPRDM1DRA[GWPRDM1DARG] = RA;
GWPRDM1DIA[GWPRDM1DARG] = IA;
GWPRDM1DRX[GWPRDM1DARG] = RX;
GWPRDM1DRP[GWPRDM1DARG] = RP;
GWPRDM1DRG[GWPRDM1DARG] = RG;
GWPRDM1DIG[GWPRDM1DARG] = IG;
GWPRDM1DTHETA[GWPRDM1DARG] = THETA;
GWPRDM1DNORM[GWPRDM1DARG] = NORM;
GWPRDM1DMASS[GWPRDM1DARG] = MASS;
GWPRDM1DHBAR[GWPRDM1DARG] = HBAR;
GWPRDM1DPECOEFF[GWPRDM1DARG] = {V0, V1, V2};
GWPRDM1DINPUT[GWPRDM1DARG] = INIT;
GWPRDM1DINIT[GWPRDM1DARG] = {RA, IA, RX, RP, RG, IG, THETA};

(* --- 2. Density Matrices --- *)
GWPRDM1DRHOXX[x_, y_][GWPRDM1DARG] := Exp[-RA*(x - RX)^2 - RA*(y - RX)^2 - THETA*(x - y)^2 + I/HBAR * RP*(x - y) + I*IA*(x - RX)^2 - I*IA*(y - RX)^2 + 2*RG];

GWPRDM1DRHOX[x_][GWPRDM1DARG] := Exp[-2*RA*(x - RX)^2 + 2*RG];

(* --- 3. Pure State Fallbacks --- *)
GWPRDM1DFREE[t_][GWPRDM1DARG] = Module[
  {SXX0, SXP0, SPP0, SXXT, SXPT, SPPT, RXT, RPT, RAT, IAT, THETAT, RGT},
  
  RXT = RX + (RP / MASS) * t;
  RPT = RP;
  
  (* Step A: Map Initial Shape to Variances *)
  SXX0 = 1 / (4 * RA);
  SXP0 = (HBAR * IA) / (2 * RA);
  SPP0 = HBAR^2 * (2 * THETA + RA + IA^2 / RA);
  
  (* Step B: Propagate *)
  SXXT = SXX0 + (2 * SXP0 * t) / MASS + (SPP0 * t^2) / MASS^2;
  SXPT = SXP0 + (SPP0 * t) / MASS;
  SPPT = SPP0;
  
  (* Step C: Map Variances Back to Shape *)
  RAT = 1 / (4 * SXXT);
  IAT = SXPT / (2 * HBAR * SXXT);
  THETAT = (SXXT * SPPT - SXPT^2) / (2 * HBAR^2 * SXXT) - 1 / (8 * SXXT);
  
  (* Enforce Trace = 1 *)
  RGT = 1/4 * Log[2 * RAT / Pi];
  
  Sequence @@ {RAT, IAT, RXT, RPT, RGT, IG, THETAT, NORM, HBAR, MASS, {0, 0, 0}, INIT}
];

GWPRDM1DHARMONIC[OMEGA_][t_][GWPRDM1DARG] = Module[
  {SXX0, SXP0, SPP0, SXXT, SXPT, SPPT, RXT, RPT, RAT, IAT, THETAT, RGT},
  
  (* Step A: Map Initial Shape to Variances *)
  SXX0 = 1 / (4 * RA);
  SXP0 = (HBAR * IA) / (2 * RA);
  SPP0 = HBAR^2 * (2 * THETA + RA + IA^2 / RA);
  
  (* Step B: Propagate *)
  SXXT = SXX0 * Cos[OMEGA * t]^2 + (SPP0 * Sin[OMEGA * t]^2) / (MASS^2 * OMEGA^2) + (SXP0 * Sin[2 * OMEGA * t]) / (MASS * OMEGA);
  SXPT = SXP0 * Cos[2 * OMEGA * t] + ((SPP0 - MASS^2 * OMEGA^2 * SXX0) * Sin[2 * OMEGA * t]) / (2 * MASS * OMEGA);
  SPPT = SPP0 * Cos[OMEGA * t]^2 + MASS^2 * OMEGA^2 * SXX0 * Sin[OMEGA * t]^2 - MASS * OMEGA * SXP0 * Sin[2 * OMEGA * t];
  
  (* Step C: Map Variances Back to Shape *)
  RAT = 1 / (4 * SXXT);
  IAT = SXPT / (2 * HBAR * SXXT);
  RXT = RX * Cos[OMEGA * t] + (RP / (MASS * OMEGA)) * Sin[OMEGA * t];
  RPT = RP * Cos[OMEGA * t] - MASS * OMEGA * RX * Sin[OMEGA * t];
  
  RGT = 1/4 * Log[2 * RAT / Pi];
  THETAT = (SXXT * SPPT - SXPT^2) / (2 * HBAR^2 * SXXT) - 1 / (8 * SXXT);
  
  Sequence @@ {RAT, IAT, RXT, RPT, RGT, IG, THETAT, NORM, HBAR, MASS, {0, 0, MASS*OMEGA^2/2}, INIT}
];

(* --- 4. Caldeira-Leggett Dissipative Flavors --- *)
GWPRDM1DFREECL[GAMMA_, KT_][t_][GWPRDM1DARG] = Module[
  {DD, SXX0, SXP0, SPP0, SXXT, SXPT, SPPT, RXT, RPT, RAT, IAT, THETAT, RGT},
  
  (* Step A: Map Initial Shape to Variances *)
  SXX0 = 1 / (4 * RA);
  SXP0 = (HBAR * IA) / (2 * RA);
  SPP0 = HBAR^2 * (2 * THETA + RA + IA^2 / RA);
  
  (* Step B: Propagate *)
  DD = 2 * MASS * GAMMA * KT;
  SXXT = (-DD + 2*GAMMA*SPP0 + 4*E^(GAMMA*t)*(DD - GAMMA*(SPP0 + GAMMA*MASS*SXP0)) + E^(2*GAMMA*t)*(2*GAMMA*(SPP0 + GAMMA*MASS*(2*SXP0 + GAMMA*MASS*SXX0)) + DD*(-3 + 2*GAMMA*t)))/(2*E^(2*GAMMA*t)*GAMMA^3*MASS^2);
  SXPT = (DD*(-1 + E^(GAMMA*t))^2 - 2*GAMMA*SPP0 + 2*E^(GAMMA*t)*GAMMA*(SPP0 + GAMMA*MASS*SXP0))/(2*E^(2*GAMMA*t)*GAMMA^2*MASS);
  SPPT = (DD*(-1 + E^(2*GAMMA*t)) + 2*GAMMA*SPP0)/(2*E^(2*GAMMA*t)*GAMMA);
  
  (* Step C: Map Variances Back to Shape *)
  RAT = 1 / (4 * SXXT);
  IAT = SXPT / (2 * HBAR * SXXT);
  RXT = (RP - RP/E^(GAMMA*t) + GAMMA*MASS*RX)/(GAMMA*MASS);
  RPT = RP/E^(GAMMA*t);
  
  RGT = 1/4 * Log[2 * RAT / Pi];
  THETAT = (SXXT * SPPT - SXPT^2) / (2 * HBAR^2 * SXXT) - 1 / (8 * SXXT);  
  
  Sequence @@ {RAT, IAT, RXT, RPT, RGT, IG, THETAT, NORM, HBAR, MASS, {0, 0, 0}, INIT}
];

GWPRDM1DHARMONICCL[OMEGA_, GAMMA_, KT_][t_][GWPRDM1DARG] := Module[
  {DD, SXX0, SXP0, SPP0, SXXT, SXPT, SPPT, OMEGA1, RAT, IAT, RXT, RPT, RGT, THETAT},  
  
  (* Step A: Map Initial Shape to Variances *)
  SXX0 = 1 / (4 * RA);
  SXP0 = (HBAR * IA) / (2 * RA);
  SPP0 = HBAR^2 * (2 * THETA + RA + IA^2 / RA);
  
  (* Step B: Analytical Dispatcher *)
  DD = 2 * MASS * GAMMA * KT;
  
  Which[
      (* Underdamped *)
      GAMMA < 2 * OMEGA,
      (
        OMEGA1 = Sqrt[4 * OMEGA^2 - GAMMA^2];   
        SXXT = (DD*E^(GAMMA*t)*OMEGA1^2 + 4*OMEGA^2*(-DD + GAMMA*(SPP0 + GAMMA*MASS*SXP0 + MASS^2*OMEGA^2*SXX0)) + GAMMA*(DD*GAMMA + 2*OMEGA^2*(-2*(SPP0 + GAMMA*MASS*SXP0) - MASS^2*(GAMMA^2 - 2*OMEGA^2)*SXX0))*Cos[OMEGA1*t] + GAMMA*OMEGA1*(-DD + 2*MASS*OMEGA^2*(2*SXP0 + GAMMA*MASS*SXX0))*Sin[OMEGA1*t])/(2*E^(GAMMA*t)*GAMMA*MASS^2*OMEGA^2*OMEGA1^2);     
        SXPT = (DD - GAMMA*(SPP0 + GAMMA*MASS*SXP0 + MASS^2*OMEGA^2*SXX0) + (-DD + GAMMA*SPP0 + 4*MASS*OMEGA^2*SXP0 + GAMMA*MASS^2*OMEGA^2*SXX0)*Cos[OMEGA1*t] + OMEGA1*(SPP0 - MASS^2*OMEGA^2*SXX0)*Sin[OMEGA1*t])/(E^(GAMMA*t)*MASS*OMEGA1^2);      
        SPPT = (DD*E^(GAMMA*t)*OMEGA1^2 + 4*OMEGA^2*(-DD + GAMMA*(SPP0 + GAMMA*MASS*SXP0 + MASS^2*OMEGA^2*SXX0)) + GAMMA*(DD*GAMMA - 2*GAMMA^2*SPP0 + 4*OMEGA^2*SPP0 - 4*GAMMA*MASS*OMEGA^2*SXP0 - 4*MASS^2*OMEGA^4*SXX0)*Cos[OMEGA1*t] + GAMMA*OMEGA1*(DD - 2*GAMMA*SPP0 - 4*MASS*OMEGA^2*SXP0)*Sin[OMEGA1*t])/(2*E^(GAMMA*t)*GAMMA*OMEGA1^2);
        RXT = (RX*Cos[(OMEGA1*t)/2] + ((2*RP + GAMMA*MASS*RX)*Sin[(OMEGA1*t)/2])/(MASS*OMEGA1))/E^((GAMMA*t)/2);
        RPT = (RP*Cos[(OMEGA1*t)/2] - ((GAMMA*RP + 2*MASS*OMEGA^2*RX)*Sin[(OMEGA1*t)/2])/OMEGA1)/E^((GAMMA*t)/2);
      ),
      
      (* Overdamped *)
      GAMMA > 2 * OMEGA,
      (
        OMEGA1 = Sqrt[GAMMA^2 - 4*OMEGA^2];
        SXXT = (DD*E^(GAMMA*t)*OMEGA1^2 - 4*OMEGA^2*(-DD + GAMMA*(SPP0 + MASS*(GAMMA*SXP0 + MASS*OMEGA^2*SXX0))) + GAMMA*(-(DD*GAMMA) + 2*OMEGA^2*(2*(SPP0 + GAMMA*MASS*SXP0) + MASS^2*(GAMMA^2 - 2*OMEGA^2)*SXX0))*Cosh[OMEGA1*t] + GAMMA*OMEGA1*(-DD + 2*MASS*OMEGA^2*(2*SXP0 + GAMMA*MASS*SXX0))*Sinh[OMEGA1*t])/(2*E^(GAMMA*t)*GAMMA*MASS^2*OMEGA^2*OMEGA1^2);
        SXPT = (-DD + GAMMA*(SPP0 + GAMMA*MASS*SXP0 + MASS^2*OMEGA^2*SXX0) + (DD - 4*MASS*OMEGA^2*SXP0 - GAMMA*(SPP0 + MASS^2*OMEGA^2*SXX0))*Cosh[OMEGA1*t] + OMEGA1*(SPP0 - MASS^2*OMEGA^2*SXX0)*Sinh[OMEGA1*t])/(E^(GAMMA*t)*MASS*OMEGA1^2);
        SPPT = (DD*E^(GAMMA*t)*OMEGA1^2 - 4*OMEGA^2*(-DD + GAMMA*(SPP0 + GAMMA*MASS*SXP0 + MASS^2*OMEGA^2*SXX0)) + GAMMA*(-(DD*GAMMA) + 2*GAMMA^2*SPP0 - 4*OMEGA^2*SPP0 + 4*GAMMA*MASS*OMEGA^2*SXP0 + 4*MASS^2*OMEGA^4*SXX0)*Cosh[OMEGA1*t] + GAMMA*OMEGA1*(DD - 2*GAMMA*SPP0 - 4*MASS*OMEGA^2*SXP0)*Sinh[OMEGA1*t])/(2*E^(GAMMA*t)*GAMMA*OMEGA1^2);
        RXT = (RX*Cosh[(OMEGA1*t)/2] + ((2*RP + GAMMA*MASS*RX)*Sinh[(OMEGA1*t)/2])/(MASS*OMEGA1))/E^((GAMMA*t)/2);
        RPT = (RP*Cosh[(OMEGA1*t)/2] - ((GAMMA*RP + 2*MASS*OMEGA^2*RX)*Sinh[(OMEGA1*t)/2])/OMEGA1)/E^((GAMMA*t)/2);
      ),
      
      (* Critically damped *) 
      GAMMA == 2 * OMEGA,
      (
        SXXT = (DD*(-1 + E^(2*OMEGA*t) - 2*OMEGA*t*(1 + OMEGA*t)) + 4*OMEGA^3*(SPP0*t^2 + 2*MASS*SXP0*t*(1 + OMEGA*t) + SXX0*(MASS + MASS*OMEGA*t)^2))/(4*E^(2*OMEGA*t)*MASS^2*OMEGA^3);
        SXPT = (2*MASS*SXP0 + 2*(SPP0 - MASS^2*OMEGA^2*SXX0)*t + (DD - 2*OMEGA*(SPP0 + MASS*OMEGA*(2*SXP0 + MASS*OMEGA*SXX0)))*t^2)/(2*E^(2*OMEGA*t)*MASS);
        SPPT = (DD*(-1 + E^(2*OMEGA*t) - 2*OMEGA*t*(-1 + OMEGA*t)) + 4*OMEGA*(SPP0*(-1 + OMEGA*t)^2 + MASS*OMEGA^2*t*(-2*SXP0 + OMEGA*(2*SXP0 + MASS*OMEGA*SXX0)*t)))/(4*E^(2*OMEGA*t)*OMEGA);    
        RXT = (RP*t + MASS*(RX + OMEGA*RX*t))/(E^(OMEGA*t)*MASS);
        RPT = (RP - OMEGA*(RP + MASS*OMEGA*RX)*t)/E^(OMEGA*t);
      )
  ];

  (* Step C: Map Variances Back to Shape *)
  RAT = 1 / (4 * SXXT);
  IAT = SXPT / (2 * HBAR * SXXT);
  RGT = 1/4 * Log[2 * RAT / Pi];  
  THETAT = (SXXT * SPPT - SXPT^2) / (2 * HBAR^2 * SXXT) - 1 / (8 * SXXT);  
  
  Sequence @@ {RAT, IAT, RXT, RPT, RGT, IG, THETAT, NORM, HBAR, MASS, {0, 0, MASS*OMEGA^2/2}, INIT}
];


(* --- Property Registration --- *)
$regStaticRDM1D = Join[#, {"StaticParameters", "RDM1D"}] & /@ {
  {"Normalization",         "NORM",  "Static", "Static"},
  {"ReducedPlanckConstant", "HBAR",  "Static", "Static"},
  {"Mass",                  "MASS",  "Static", "Static"},
  {"InputParameters",       "INPUT", "Static", "Static"},
  {"InitialParameters",     "INIT",  "Static", "Static"}
};

$regDynamicRDM1D = Join[#, {"DynamicParameters", "RDM1D"}] & /@ {
  {"RealShape",             "RA",      "Temporal", "StaticValue"},
  {"ImaginaryShape",        "IA",      "Temporal", "StaticValue"},
  {"PositionCenter",        "RX",      "Temporal", "StaticValue"},
  {"MomentumCenter",        "RP",      "Temporal", "StaticValue"},
  {"RealPhase",             "RG",      "Temporal", "StaticValue"},
  {"ImaginaryPhase",        "IG",      "Temporal", "StaticValue"},
  {"Decoherence",           "THETA",   "Temporal", "StaticValue"},
  
  {"PotentialCoefficients", "PECOEFF", "Temporal", None} 
};

$regProbRDM1D = Join[#, {"Probabilities", "RDM1D"}] & /@ {
  {"DensityMatrixXX", "RHOXX", "Bivariate", "BivariateSpatial"},
  {"DensityX",        "RHOX",  "Field",     "Spatial"}
};

(* --- Registry Assembly --- *)
$regRDM1D = Join[$regStaticRDM1D, $regDynamicRDM1D, $regProbRDM1D];
Clear[$regStaticRDM1D, $regDynamicRDM1D, $regProbRDM1D];

(* --- Unified Potential Registry Chunk --- *)
(* Format: {StringName, BackendSymbol, Template, Category} *)
$potentialsRDM1D = {
  {"Free",       GWPRDM1DFREE,       "\"Free\"",                           "Named"},
  {"Harmonic",   GWPRDM1DHARMONIC,   "{\"Harmonic\", OMEGA}",              "Parameterized"},
  {"FreeCL",     GWPRDM1DFREECL,     "{\"FreeCL\", GAMMA, KT}",            "Parameterized"},
  {"HarmonicCL", GWPRDM1DHARMONICCL, "{\"HarmonicCL\", OMEGA, GAMMA, KT}", "Parameterized"}
};

GWPTools`GWPRegistry`GWPRegisterPotentials[$potentialsRDM1D, "RDM1D"];
GWPTools`GWPRegistry`GWPRegisterExtension[$regRDM1D];



(* --- End "GWPTools`GWPEngineRDM1D`Private`" --- *)

If[TrueQ[Global`$GWPDebug], Print["[GWPEngineRDM1D] End Private"]];
End[]

(* Hide internal code for all Developer functions from the ? menu *)
SetAttributes[Evaluate[Names["GWPTools`GWPEngineRDM1D`*"]], {ReadProtected}];

(* --- End "GWPTools`GWPEngineRDM1D`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPEngineRDM1D] EndPackage"]];
EndPackage[]
