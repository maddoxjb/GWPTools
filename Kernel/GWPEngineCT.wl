(* ========================================================================= *)
(* Usage Registration (Symbol Hoisting)                                      *)
(* ========================================================================= *)
Needs["GWPTools`GWPDeveloper`"];
BeginPackage["GWPTools`GWPDeveloper`"]

If[TrueQ[Global`$GWPDebug], Print["[GWPEngineCT] BeginPackage GWPDeveloper"]];

(* Suppress shadowing warnings during the silent boot sequence *)
Off[General::shdw];

(* Parameter Bus Macros *)
GWPCTARG::usage = "Macro for Classical Trajectory argument pattern.";
GWPCTVAL::usage = "Macro for Classical Trajectory values.";

(* Constructor *)
GWPCTPARAM::usage = "GWPCTPARAM[x0, p0] generates the Classical Trajectory parameter sequence.";

(* Properties *)
GWPCTRX::usage = "Extracts the classical position.";
GWPCTRP::usage = "Extracts the classical momentum.";
GWPCTKE::usage = "Evaluates the classical kinetic energy.";
GWPCTPE::usage = "Evaluates the classical potential energy.";
GWPCTTE::usage = "Evaluates the classical total energy.";

(* Potentials *)
GWPCTFREE::usage     = "Propagator for a classical free particle.";
GWPCTHARMONIC::usage = "Propagator for a classical harmonic oscillator.";

If[TrueQ[Global`$GWPDebug], Print["[GWPEngineCT] EndPackage GWPDeveloper"]];

Quiet[EndPackage[], General::shdw]
$ContextPath = DeleteCases[$ContextPath, "GWPTools`GWPDeveloper`"];


(* ========================================================================= *)
(* Private Engine Logic & Registration                                       *)
(* ========================================================================= *)
BeginPackage["GWPTools`GWPEngineCT`"];
If[TrueQ[Global`$GWPDebug], Print["[GWPEngineCT] BeginPackage"]];

Begin["`Private`"];
If[TrueQ[Global`$GWPDebug], Print["[GWPEngineCT] Begin Private"]];

Needs["GWPTools`GWPDeveloper`"];
Needs["GWPTools`GWPRegistry`"];

(* --- Parameter Bus Definition --- *)
GWPCTARG = Sequence[RX_, RP_, MASS_, {V0_, V1_, V2_}, INIT_];
GWPCTVAL = Sequence[RX, RP, MASS, {V0, V1, V2}, INIT];

(* --- Constructor Engine --- *)
Options[GWPCTPARAM] = {"MASS" -> 1};

GWPCTPARAM[X0_, P0_, opts : OptionsPattern[]] := Module[{rx, rp, m},
  (* Enforce real-valued coordinates and extract mass *)
  rx = ComplexExpand[Re[X0]];
  rp = ComplexExpand[Re[P0]];
  m  = OptionValue["MASS"];

  (* Output the initialized Parameter Bus *)
  (* Format: {RX, RP, MASS, PECOEFF, INIT} *)
  Sequence @@ {rx, rp, m, {0, 0, 0}, {rx, rp}}
];

(* --- Static Function Definitions --- *)
(* GWPCTARG unpacks the sequence to define the exact signature *)
GWPCTRX[GWPCTARG] = RX;
GWPCTRP[GWPCTARG] = RP;
GWPCTKE[GWPCTARG] = RP^2 / (2 * MASS);
GWPCTPE[GWPCTARG] = V0 + V1 * RX + V2 * RX^2;

(* Passing the bus downstream requires With to inject GWPCTVAL *)
With[{val = GWPCTVAL}, 
  GWPCTTE[GWPCTARG] := GWPCTKE[val] + GWPCTPE[val]
];

(* --- Potential Propagators --- *)
GWPCTFREE[t_][GWPCTARG] := Module[{newRX, newRP, newV},
  newRX = RX + (RP / MASS) * t;
  newRP = RP; 
  newV  = {0, 0, 0}; 
  Sequence @@ {newRX, newRP, MASS, newV, INIT}
];

GWPCTHARMONIC[omega_][t_][GWPCTARG] := Module[{newRX, newRP, newV},
  newRX = RX * Cos[omega * t] + (RP / (MASS * omega)) * Sin[omega * t];
  newRP = RP * Cos[omega * t] - MASS * omega * RX * Sin[omega * t]; 
  newV  = {0, 0, 1/2 * MASS * omega^2}; 
  Sequence @@ {newRX, newRP, MASS, newV, INIT}
];

(* --- Registry Injection --- *)
(* Format: {LongName, ShortKey, DynamicClass, StaticClass, Class, EngineType} *)
$ctReg = {
  {"Position",        "RX", "Temporal", "StaticValue", "Trajectory", "CT"},
  {"Momentum",        "RP", "Temporal", "StaticValue", "Trajectory", "CT"},
  {"KineticEnergy",   "KE", "Temporal", "StaticValue", "Energies",   "CT"},
  {"PotentialEnergy", "PE", "Temporal", "StaticValue", "Energies",   "CT"},
  {"TotalEnergy",     "TE", "Temporal", "StaticValue", "Energies",   "CT"}
};

GWPRegisterExtension[$ctReg];
Clear[$ctReg];

(* Format: {StringName, BackendSymbol, Template, Category} *)
$ctPot = {
  {"Free",     GWPCTFREE,     "\"Free\"",              "Named"},
  {"Harmonic", GWPCTHARMONIC, "{\"Harmonic\", OMEGA}", "Parameterized"}
};

GWPRegisterPotentials[$ctPot, "CT"];
Clear[$ctPot];

If[TrueQ[Global`$GWPDebug], Print["[GWPEngineCT] End Private"]];
End[];

(* Hide internal code for all Developer functions from the ? menu *)
SetAttributes[Evaluate[Names["GWPTools`GWPEngineCT`*"]], {ReadProtected}];

If[TrueQ[Global`$GWPDebug], Print["[GWPEngineCT] EndPackage"]];
EndPackage[];