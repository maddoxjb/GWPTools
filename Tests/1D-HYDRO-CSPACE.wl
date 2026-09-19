(* ::Package:: *)

(* ========================================================================= *)
(* TEST SUITE  : GWPTools (Version 1.0.0)                                    *)
(* FILE        : 1D-HYDRO-CSPACE.wl                                          *)
(* DESCRIPTION : Tests BohmianTrajectories section of GWPHydrodynamics1D.wl  *)
(* ========================================================================= *)

(* Load the Master Test Environment *)
Needs["GWPTools`GWPDiagnostics`"]

(* ========================================================== *)
(* DEFINITIONS AND CONFIGURATION                              *)
(* ========================================================== *)

(* Save the user's current global assumptions before modifying them *)
$userAssumptions = $Assumptions;

(* Optimized Parameter Sequence injecting {V0,V1,V2} to prevent zero-variance singularities in PE correlations *)
ToExpression[DEF01 = "PAR=Sequence[RA,IA,RX,RP,RG,IG,E^(IG/HBAR)*(2/Pi)^(1/4)*RA^(1/4),HBAR,MASS,{V0,V1,V2},{RA,IA,RX,0,RP,0,RG,IG}]"];

(* Evaluates and sets the global assumptions natively *)
ToExpression[DEF02 = "$Assumptions=GWP1DASSUMPTIONS[PAR,\"Position\"->x,\"Momentum\"->p,\"Cumulative\"->c]"];

ToExpression[STR01 = "XC0=GWP1DXC[0][c][PAR]"];
ToExpression[STR02 = "PC0=GWP1DPC[0][c][PAR]"];

(* ========================================================== *)
(* C-SPACE (TRAJECTORY INVERSION) VERIFICATION TESTS          *)
(* ========================================================== *)

VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF01]
VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF02]

(* ---------------------------------------------------------- *)
(* 1. Position-Space Trajectory Inversion                     *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[XC0 - Quiet@First@SolveValues[GWP1DCX[x][PAR] == c, x, Assumptions -> None]] == 0,
  TestID -> "GWP1DXC-01-Inversion", MetaInformation -> STR01
]
VerificationTest[
  And @@ Table[Simplify[GWP1DXC[n][c][PAR] - D[XC0, {c, n}]] == 0, {n, 0, 6}],
  TestID -> "GWP1DXC-02-Derivatives"
]

(* ---------------------------------------------------------- *)
(* 2. Momentum-Space Trajectory Inversion                     *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[PC0 - Quiet@First@SolveValues[GWP1DCP[p][PAR] == c, p, Assumptions -> None]] == 0,
  TestID -> "GWP1DPC-01-Inversion", MetaInformation -> STR02
]
VerificationTest[
  And @@ Table[Simplify[GWP1DPC[n][c][PAR] - D[PC0, {c, n}]] == 0, {n, 0, 6}],
  TestID -> "GWP1DPC-02-Derivatives"
]

(* ---------------------------------------------------------- *)
(* 3. Hydrodynamic C-Space Mappings                           *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWP1DRHOC[c][PAR] - GWP1DRHOX[XC0][PAR]] == 0,
  TestID -> "GWP1DRHOC-01-Mapping"
]
VerificationTest[
  Simplify[GWP1DJC[c][PAR] - GWP1DJX[XC0][PAR]] == 0,
  TestID -> "GWP1DJC-01-Mapping"
]
VerificationTest[
  Simplify[GWP1DAC[c][PAR] - GWP1DAX[XC0][PAR]] == 0,
  TestID -> "GWP1DAC-01-Mapping"
]
VerificationTest[
  Simplify[GWP1DSC[c][PAR] - GWP1DSX[XC0][PAR]] == 0,
  TestID -> "GWP1DSC-01-Mapping"
]
VerificationTest[
  Simplify[GWP1DVC[c][PAR] - GWP1DVX[XC0][PAR]] == 0,
  TestID -> "GWP1DVC-01-Mapping"
]
VerificationTest[
  Simplify[GWP1DOVC[c][PAR] - GWP1DOVX[XC0][PAR]] == 0,
  TestID -> "GWP1DOVC-01-Mapping"
]
VerificationTest[
  Simplify[GWP1DQSC[c][PAR] - GWP1DQSX[XC0][PAR]] == 0,
  TestID -> "GWP1DQSC-01-Mapping"
]
VerificationTest[
  Simplify[GWP1DQPC[c][PAR] - GWP1DQPX[XC0][PAR]] == 0,
  TestID -> "GWP1DQPC-01-Mapping"
]
VerificationTest[
  Simplify[GWP1DQFC[c][PAR] - GWP1DQFX[XC0][PAR]] == 0,
  TestID -> "GWP1DQFC-01-Mapping"
]

(* ---------------------------------------------------------- *)
(* 4. External Potential C-Space Derivatives                  *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWP1DPEC[c][PAR] - GWP1DPEX[XC0][PAR]] == 0,
  TestID -> "GWP1DPEC-01-Mapping"
]
VerificationTest[
  And @@ Table[Simplify[GWP1DPEC[n][c][PAR] - D[GWP1DPEC[0][c][PAR], {c, n}]] == 0, {n, 0, 6}],
  TestID -> "GWP1DPEC-02-Derivatives"
]

(* ---------------------------------------------------------- *)
(* 5. External Force C-Space Derivatives                      *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWP1DFEC[c][PAR] - GWP1DFEX[XC0][PAR]] == 0,
  TestID -> "GWP1DFEC-01-Mapping"
]
VerificationTest[
  And @@ Table[Simplify[GWP1DFEC[n][c][PAR] - D[GWP1DFEC[0][c][PAR], {c, n}]] == 0, {n, 0, 6}],
  TestID -> "GWP1DFEC-02-Derivatives"
]

(* ---------------------------------------------------------- *)
(* 6. Information & Energy Densities in C-Space               *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWP1DFIC[c][PAR] - GWP1DFIX[XC0][PAR]] == 0,
  TestID -> "GWP1DFIC-01-Mapping"
]
VerificationTest[
  Simplify[GWP1DCKEC[c][PAR] - GWP1DCKEX[XC0][PAR]] == 0,
  TestID -> "GWP1DCKEC-01-Mapping"
]
VerificationTest[
  Simplify[GWP1DIKEC[c][PAR] - GWP1DIKEX[XC0][PAR]] == 0,
  TestID -> "GWP1DIKEC-01-Mapping"
]
VerificationTest[
  Simplify[GWP1DTKEC[c][PAR] - GWP1DTKEX[XC0][PAR]] == 0,
  TestID -> "GWP1DTKEC-01-Mapping"
]
VerificationTest[
  Simplify[GWP1DTPEC[c][PAR] - GWP1DTPEX[XC0][PAR]] == 0,
  TestID -> "GWP1DTPEC-01-Mapping"
]
VerificationTest[
  Simplify[GWP1DTEDC[c][PAR] - GWP1DTEDX[XC0][PAR]] == 0,
  TestID -> "GWP1DTEDC-01-Mapping"
]

(* ========================================================== *)
(* CLEANUP: PREVENT NAMESPACE POLLUTION                       *)
(* ========================================================== *)

(* Restore the user's exact original assumptions *)
$Assumptions = $userAssumptions;
Remove[$userAssumptions];

(* Clear dynamically generated strings so MetaInformation renders properly *)
ClearAll["DEF*"];
ClearAll["STR*"];

(* Clear the parameter sequence and trajectory inversion variables *)
ClearAll[PAR, XC0, PC0];

(* Clear the abstract symbolic variables, coordinates, and iterators used in the tests *)
ClearAll[RA, IA, RX, RP, RG, IG, HBAR, MASS, V0, V1, V2, x, p, c, n];
