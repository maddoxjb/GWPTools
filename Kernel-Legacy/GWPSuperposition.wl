(* ::Package:: *)

(* ::Title:: *)
(*GWPSuperposition Package*)


(* ::Section::Closed:: *)
(*GWPDeveloper Usage Registration*)


(* ::Subsection::Closed:: *)
(*BeginPackage*)


(* --- Open GWPDeveloper Package --- *)
BeginPackage["GWPTools`GWPDeveloper`"]


(* ::Subsection::Closed:: *)
(*Usage Statements*)


GWPSSPARAM::usage = "GWPSSPARAM[] returns default superposition parameters.\nGWPSSPARAM[alphaList, xList, pList, gammaList] generates a sequence of parameters for a superposition of two GWPs.";
GWPPARAM12::usage = "GWPPARAM12[param1][param2] generates the cross-term parameter sequence for the overlap of two GWPs.";
GWPSSNORM::usage = "GWPSSNORM[superParam] extracts the normalization constant for the superposition.";

GWPS12::usage = "GWPS12[crossParam] evaluates the complex overlap integral <Psi1|Psi2>.";
GWPRS12::usage = "GWPRS12[crossParam] evaluates the real part of the overlap integral.";
GWPIS12::usage = "GWPIS12[crossParam] evaluates the imaginary part of the overlap integral.";

GWPSSPSIX::usage = "GWPSSPSIX[x][superParam] evaluates the position-space wavefunction for the superposition.\nGWPSSPSIX[n][x][superParam] evaluates the n-th spatial derivative.";
GWPSSCSIX::usage = "GWPSSCSIX[x][superParam] evaluates the complex conjugate position-space wavefunction.\nGWPSSCSIX[n][x][superParam] evaluates the n-th spatial derivative.";
GWPSSRHOX::usage = "GWPSSRHOX[x][superParam] evaluates the probability density for the superposition.\nGWPSSRHOX[n][x][superParam] evaluates the n-th spatial derivative.";
GWPSSCX::usage = "GWPSSCX[x][superParam] evaluates the cumulative distribution function for the superposition.";

GWPSSQPX::usage = "GWPSSQPX[x][superParam] evaluates the quantum potential for the superposition.";
GWPSSQFX::usage = "GWPSSQFX[x][superParam] evaluates the quantum force for the superposition.";

GWPSS::usage = "GWPSS[system][superParam] applies a system dynamics function (like FREE or HARMONIC) to a superposition.";


(* ::Subsection::Closed:: *)
(*End*)


(* --- Close GWPDeveloper Package --- *)
EndPackage[]
$ContextPath = DeleteCases[$ContextPath, "GWPTools`GWPDeveloper`"];


(* ::Section::Closed:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPSuperposition`                                  *)
(* DESCRIPTION : Superposition of GWPs for the GWPTools framework.           *)
(* ========================================================================= *)

(* IMPORTANT: Do NOT include a second-argument array here! *)
BeginPackage["GWPTools`GWPSuperposition`"]

Begin["`Private`"]

(* LOAD DEPENDENCIES INTERNALLY *)
(* These will be available for compilation, but automatically erased from *)
(* the user's $ContextPath when EndPackage[] is called at the bottom.   *)
Needs["GWPTools`GWPDeveloper`"];
Needs["GWPTools`GWPEngine`"];


(* --- Sequence Macros --- *)
GWPSSARG=Sequence[PARAM11_,PARAM22_,PARAM12_,RC_,IC_,NORM_,NORM2_];
GWPSSVAL=Sequence[PARAM11,PARAM22,PARAM12,RC,IC,NORM,NORM2];


(* ::Section::Closed:: *)
(*Parameters*)


Options[GWPSSPARAM] = {"HBAR" -> 1, "MASS" -> 1, "C" -> 1};


GWPSSPARAM[OptionsPattern[]]:=GWPSS486[{1,1},{-1,1},{0,0},{0,0},OptionValue@"HBAR",OptionValue@"MASS",OptionValue@"C"];
GWPSSPARAM[AA_,OptionsPattern[]]:=GWPSS486[AA,{-1,1},{0,0},{0,0},OptionValue@"HBAR",OptionValue@"MASS",OptionValue@"C"];
GWPSSPARAM[AA_,XX_,OptionsPattern[]]:=GWPSS486[AA,XX,{0,0},{0,0},OptionValue@"HBAR",OptionValue@"MASS",OptionValue@"C"];
GWPSSPARAM[AA_,XX_,PP_,OptionsPattern[]]:=GWPSS486[AA,XX,PP,{0,0},OptionValue@"HBAR",OptionValue@"MASS",OptionValue@"C"];
GWPSSPARAM[AA_,XX_,PP_,GG_,OptionsPattern[]]:=GWPSS486[AA,XX,PP,GG,OptionValue@"HBAR",OptionValue@"MASS",OptionValue@"C"];


GWPSS486[AA_,XX_,PP_,GG_,HBAR_,MASS_,CC_]:=Module[{PARAM11,PARAM22,PARAM12,S12,S21,NORM,NORM2,RC,IC,RS12,IS12},
PARAM11=GWPPARAM[AA[[1]],XX[[1]],PP[[1]],GG[[1]],"HBAR"->HBAR,"MASS"->MASS];
PARAM22=GWPPARAM[AA[[2]],XX[[2]],PP[[2]],GG[[2]],"HBAR"->HBAR,"MASS"->MASS];
PARAM12=GWPPARAM12[PARAM11][PARAM22];
{RC,IC}=ComplexExpand@ReIm@CC;
RS12=GWPRS12[PARAM12];
IS12=GWPIS12[PARAM12];
NORM=1/Sqrt[1+(RC^2+IC^2)+2(RC*RS12-IC*IS12)];
NORM2=1/(1+(RC^2+IC^2)+2(RC*RS12-IC*IS12));
Sequence@@{{PARAM11},{PARAM22},{PARAM12},RC,IC,NORM,NORM2}];


(* GWP PRODUCT *)
GWPPARAM12[RA1_,IA1_,RX1_,RP1_,RG1_,IG1_,NORM1_,HBAR_,MASS_,extra___][RA2_,IA2_,RX2_,RP2_,RG2_,IG2_,NORM2_,___]=Sequence@@{RA1 + RA2, -IA1 + IA2, (RA1*RX1 + RA2*RX2)/(RA1 + RA2), 
 (RA2*(-RP1 + RP2 + 2*HBAR*IA1*(-RX1 + RX2)) + RA1*(-RP1 + RP2 + 2*HBAR*IA2*(-RX1 + RX2)))/
  (RA1 + RA2), (RA1*RA2*(-2*RG1 + 2*RG2 + (RP1 + RP2)*(RX1 - RX2)) + 
   RA2^2*(-RG1 + RG2 + (RP1 + HBAR*IA1*(RX1 - RX2))*(RX1 - RX2)) - 
   RA1^2*(RG1 - RG2 - (RX1 - RX2)*(RP2 + HBAR*IA2*(-RX1 + RX2))))/(RA1 + RA2)^2, 
 IG1 + IG2 + (HBAR*RA1*RA2*(RX1 - RX2)^2)/(RA1 + RA2), NORM1*NORM2, HBAR, MASS, extra};


GWPSSNORM[GWPSSARG]=NORM;


(* ::Section::Closed:: *)
(*Overlap integral*)


GWPS12[GWPARG]=NORM*(E^((-4*HBAR*IG+(4*I)*HBAR*RG+(I*RP^2)/(IA-I*RA))/(4*HBAR^2))*Sqrt[Pi])/Sqrt[I*IA+RA];
GWPS21[GWPARG]=NORM*(E^((-4*HBAR*IG+(-4*I)*HBAR*RG+(-I*RP^2)/(IA+I*RA))/(4*HBAR^2))*Sqrt[Pi])/Sqrt[-I*IA+RA];
GWPRS12[GWPARG]=NORM*(Sqrt[Pi]*Cos[((4*HBAR*RG + (IA*RP^2)/(IA^2 + RA^2))/HBAR^2 - 2*ArcTan[RA,IA])/4])/(E^((4*HBAR*IG + (RA*RP^2)/(IA^2 + RA^2))/(4*HBAR^2))*(IA^2 + RA^2)^(1/4));
GWPIS12[GWPARG]=NORM*(Sqrt[Pi]*Sin[((4*HBAR*RG + (IA*RP^2)/(IA^2 + RA^2))/HBAR^2 - 2*ArcTan[RA,IA])/4])/(E^((4*HBAR*IG + (RA*RP^2)/(IA^2 + RA^2))/(4*HBAR^2))*(IA^2 + RA^2)^(1/4));


(* ::Section::Closed:: *)
(*Wavefunction and density*)


(* --- Position-Space Wavefunction for Superpositions --- *)
GWPSSPSIX[n_Integer][x_][GWPSSARG] := 
  NORM * ((GWPPSIX[n][x] @@ PARAM11) + (RC + I*IC) * (GWPPSIX[n][x] @@ PARAM22));

(* Fallback: Route GWPSSPSIX[x][...] to the 0th derivative *)
GWPSSPSIX[x_][arg___] /; !MatchQ[Unevaluated[GWPSSPSIX[x]], GWPSSPSIX[_Integer]] := 
  GWPSSPSIX[0][x][arg];


(* --- Position-Space Complex Conjugate Wavefunction for Superpositions --- *)
GWPSSCSIX[n_Integer][x_][GWPSSARG] := 
  NORM * ((GWPCSIX[n][x] @@ PARAM11) + (RC - I*IC) * (GWPCSIX[n][x] @@ PARAM22));

(* Fallback: Route GWPSSCSIX[x][...] to the 0th derivative *)
GWPSSCSIX[x_][arg___] /; !MatchQ[Unevaluated[GWPSSCSIX[x]], GWPSSCSIX[_Integer]] := 
  GWPSSCSIX[0][x][arg];


GWPSSRHOX[n_Integer:0][x_][GWPSSARG] := Module[{psi12, cpsi12, real12, imag12},
  
  (* Evaluate the complex cross-terms (inherits arbitrary 'n' derivatives natively) *)
  psi12  = GWPPSIX[n][x] @@ PARAM12;
  cpsi12 = GWPCSIX[n][x] @@ PARAM12;
  
  (* Algebraically isolate the real and imaginary components *)
  real12 = (psi12 + cpsi12) / 2;
  imag12 = (psi12 - cpsi12) / (2 * I);
  
  (* Assemble the final superposition density *)
  NORM2 * (
    (GWPRHOX[n][x] @@ PARAM11) + 
    (RC^2 + IC^2) * (GWPRHOX[n][x] @@ PARAM22) + 
    2 * RC * real12 - 
    2 * IC * imag12
  )
];

(* Fallback: Route un-ordered calls to the 0th derivative *)
GWPSSRHOX[x_][arg___] /; !MatchQ[Unevaluated[GWPSSRHOX[x]], GWPSSRHOX[_Integer]] := GWPSSRHOX[0][x][arg];


GWPSSFUN[fun_][GWPSSARG]:={fun@@PARAM11,fun@@PARAM22,fun@@PARAM12};
GWPSSFUN[fun_,11][GWPSSARG]:=fun@@PARAM11;
GWPSSFUN[fun_,22][GWPSSARG]:=fun@@PARAM22;
GWPSSFUN[fun_,12][GWPSSARG]:=fun@@PARAM12;


(* ::Section::Closed:: *)
(*Cumulative distribution function*)


GWPSSCX[x_][GWPSSARG]:=Module[{C11,C22,C12,C21,RC12,IC12},
C11=GWPCX[x]@@PARAM11;
C22=GWPCX[x]@@PARAM22;
C12=GWPC12[x]@@PARAM12;
C21=GWPC21[x]@@PARAM12;
NORM^2*(C11+(RC^2+IC^2)*C22+(RC+I*IC)*C12+(RC-I*IC)*C21)
];


GWPC12[x_][GWPARG]:=(NORM*Sqrt[Pi])/(2*E^((4*HBAR*(IG - I*RG) + RP^2/(I*IA + RA))/(4*HBAR^2))*Sqrt[I*IA + RA])*(1+Erf[((-1/2*I)*RP)/(HBAR*Sqrt[I*IA + RA]) + Sqrt[I*IA + RA]*(-RX + x)]);
GWPC21[x_][GWPARG]:=(NORM*Sqrt[Pi])/(2*E^((4*HBAR*(IG + I*RG) + RP^2/(-I*IA + RA))/(4*HBAR^2))*Sqrt[-I*IA + RA])*(1+Erf[((1/2*I)*RP)/(HBAR*Sqrt[-I*IA + RA]) + Sqrt[-I*IA + RA]*(-RX + x)]);


(* 
(* THE FOLLOWING IS EQUIVALENT TO THE ABOVE *)
(* SAVE IT JUST IN CASE *)
GWPSSCX[x_][GWPSSARG]:=Module[{C11,C22,C12,C21,RC12,IC12},
C11=GWPCX[x]@@PARAM11;
C22=GWPCX[x]@@PARAM22;
RC12=GWPRC12[x]@@PARAM12;
IC12=GWPIC12[x]@@PARAM12;
NORM2*(C11+(RC^2+IC^2)*C22+2*(RC*RC12-IC*IC12))
];
GWPRC12[x_][GWPARG]:=Module[{RZA,IZA,RZB,IZB,RC12},
RZA=GWPC12RZA[x][RA, IA, RX, RP, RG, IG, NORM, HBAR, MASS, PECOEFF, INIT];
IZA=GWPC12IZA[x][RA, IA, RX, RP, RG, IG, NORM, HBAR, MASS, PECOEFF, INIT];
RZB=GWPC12RZB[x][RA, IA, RX, RP, RG, IG, NORM, HBAR, MASS, PECOEFF, INIT];
IZB=GWPC12IZB[x][RA, IA, RX, RP, RG, IG, NORM, HBAR, MASS, PECOEFF, INIT];
RZA*RZB-IZA*IZB];
GWPIC12[x_][GWPARG]:=Module[{RZA,IZA,RZB,IZB,IC12},
RZA=GWPC12RZA[x][RA, IA, RX, RP, RG, IG, NORM, HBAR, MASS, PECOEFF, INIT];
IZA=GWPC12IZA[x][RA, IA, RX, RP, RG, IG, NORM, HBAR, MASS, PECOEFF, INIT];
RZB=GWPC12RZB[x][RA, IA, RX, RP, RG, IG, NORM, HBAR, MASS, PECOEFF, INIT];
IZB=GWPC12IZB[x][RA, IA, RX, RP, RG, IG, NORM, HBAR, MASS, PECOEFF, INIT];
RZA*IZB+IZA*RZB];
GWPC12RZA[x_][GWPARG]:=Module[{},(NORM*Sqrt[Pi]*Cos[((4*HBAR*RG+(IA*RP^2)/(IA^2+RA^2))/HBAR^2-2*ArcTan[RA,IA])/4])/(2*E^((4*HBAR*IG+(RA*RP^2)/(IA^2+RA^2))/(4*HBAR^2))*(IA^2+RA^2)^(1/4))];
GWPC12IZA[x_][GWPARG]:=Module[{},(NORM*Sqrt[Pi]*Sin[((4*HBAR*RG+(IA*RP^2)/(IA^2+RA^2))/HBAR^2-2*ArcTan[RA,IA])/4])/(2*E^((4*HBAR*IG+(RA*RP^2)/(IA^2+RA^2))/(4*HBAR^2))*(IA^2+RA^2)^(1/4))];
GWPC12RZB[x_][GWPARG]:=Module[{},1+Re[Erf[((-1/2*I)*RP)/(HBAR*Sqrt[I*IA + RA]) + Sqrt[I*IA + RA]*(-RX + x)]]];
GWPC12IZB[x_][GWPARG]:=Module[{},Im[Erf[((-1/2*I)*RP)/(HBAR*Sqrt[I*IA + RA]) + Sqrt[I*IA + RA]*(-RX + x)]]];
*)


(* ::Section::Closed:: *)
(*Quantum potential and force*)


QPFAC[GWPARG]=HBAR^2/(4*MASS);


GWPSSQPX[x_][GWPSSARG]:=Module[{FAC,RHO0,RHO1,RHO2},
FAC=-QPFAC@@PARAM11;
RHO0=GWPSSRHOX[0][x][PARAM11,PARAM22,PARAM12,RC,IC,NORM,NORM2];
RHO1=GWPSSRHOX[1][x][PARAM11,PARAM22,PARAM12,RC,IC,NORM,NORM2];
RHO2=GWPSSRHOX[2][x][PARAM11,PARAM22,PARAM12,RC,IC,NORM,NORM2];
FAC*(RHO2/RHO0-1/2*(RHO1/RHO0)^2)];


GWPSSQFX[x_][GWPSSARG]:=Module[{FAC,RHO0,RHO1,RHO2,RHO3},
FAC=QPFAC@@PARAM11;
RHO0=GWPSSRHOX[0][x][PARAM11,PARAM22,PARAM12,RC,IC,NORM,NORM2];
RHO1=GWPSSRHOX[1][x][PARAM11,PARAM22,PARAM12,RC,IC,NORM,NORM2];
RHO2=GWPSSRHOX[2][x][PARAM11,PARAM22,PARAM12,RC,IC,NORM,NORM2];
RHO3=GWPSSRHOX[3][x][PARAM11,PARAM22,PARAM12,RC,IC,NORM,NORM2];
FAC*(RHO3/RHO0-2*RHO1*RHO2/RHO0^2+(RHO1/RHO0)^3)];


(* ::Section::Closed:: *)
(*System*)


GWPSS[system_][GWPSSARG]:=Module[{SYSTEM11,SYSTEM22,SYSTEM12},
(*
SYSTEM11=SequenceSimplify@(system@@PARAM11);
SYSTEM22=SequenceSimplify@(system@@PARAM22);
SYSTEM12=SequenceSimplify@(GWPPARAM12[SYSTEM11][SYSTEM22]);
*)
SYSTEM11=(system@@PARAM11);
SYSTEM22=(system@@PARAM22);
SYSTEM12=(GWPPARAM12[SYSTEM11][SYSTEM22]);
Sequence@@{{SYSTEM11},{SYSTEM22},{SYSTEM12},RC,IC,NORM,NORM2}];


(* ::Section::Closed:: *)
(*GWPObject Registry*)


$regSuper = Append[#, "Superposition"] & /@ {
};


(* Export the combined chunk to the package context so GWPTools can find it *)
GWPTools`GWPSuperposition`$GWPSuperRegistry = Join[$regSuper];


(* The Hook: Dynamically inject this registry into the Object *)
If[TrueQ[GWPTools`Private`$DispatcherActive],
  GWPTools`Private`GWPRegisterExtension[GWPTools`GWPSuperposition`$GWPSuperRegistry]
];


(* ::Section::Closed:: *)
(*End*)


(* --- End "GWPTools`GWPSuperposition`Private`" --- *)
End[];

(* Hide internal code from the ? menu *)
SetAttributes[Evaluate[Names["GWPTools`GWPSuperposition`*"]], {ReadProtected}];

(* --- End "GWPTools`GWPSuperposition`" --- *)
EndPackage[]
