%% Rafael Lima - q3
% Generated using |publish('q3.m',struct('format','pdf','outputDir','.')|

close all
clear all

syms s z A0 a b Ka T

nA0 = 0.8
na = 0.5
nb = 2
nKa = 2.5
Ts = 0.2

%%
% Transfer Function
G = [-a/A0 0; a/A0 -b/A0]
B1 = [Ka/A0;0]
B2 = [0;1/A0]
C = [1 0]
D = 0

%%
% Define Gain Vector
F1 = sym('F_1')
F2 = sym('F_2')
F = [F1 F2]
syms N

%% Q1a
Ga = G - B1*F
Ba1 = B1*N
Ba2 = B2
Ca = C
Da = D

%%
% Characterist Poly
I = eye(size(Ga));
plantPoly = flip(coeffs(det(z*I-Ga),z))

%%
% Find Desired Poly
desiredPoles = [complex(0.51,0.37),complex(0.51,-0.37)]
desiredPoly = poly(desiredPoles)

% Find Feedback Gain
polyF = (plantPoly-desiredPoly)
[m,v] = equationsToMatrix(polyF(2:end),F);
sF = linsolve(m,v)
nF = double(subs(sF,[A0 a b Ka],[nA0 na nb nKa]))

%%
% Find Closed Loop Transfer Function Expression
sHc = Ca*inv(z*I-Ga)*Ba1

exprLimKp = subs(sHc,z,1)
exprLimKp = subs(exprLimKp,[A0 a b Ka F1 F2],[nA0 na nb nKa nF(1) nF(2)])
nN = double(solve(1 - exprLimKp,N))

%%
% Convert symbolic to TF
nHc = simplifyFraction((subs(sHc,[A0 a b Ka F1 F2 N],[nA0 na nb nKa nF(1) nF(2) nN])),'Expand',true)
[num,den] = numden(nHc)
Hc = zpk(tf(sym2poly(num),sym2poly(den),Ts))

%%
% Check if steady state error is greater then requirements
sysinfo = stepinfo(Hc)
assert( abs( 1 - median([sysinfo.SettlingMin,sysinfo.SettlingMax]) ) < 1e-1,...
       'Error: Stead State error greater then required' )

%%
% Check if closed loops poles match with requirements
pPoles = pole(Hc)
assert( (abs(pPoles(1)-desiredPoles(1)) < 1e-10) && (abs(pPoles(2)-desiredPoles(2)) < 1e-10), ...
       'Error: Wrong Poles')

%%
% Graphical Evaluation
step(Hc)

%%
% Find Steady State error with W(z) = step
sHcw = Ca*inv(z*I-Ga)*Ba2
exprLimErrw = subs(sHcw,z,1)
ErrW = double(subs(exprLimErrw,[A0 a b Ka F1 F2],[nA0 na nb nKa nF(1) nF(2)]))

%%
% Convert symbolic to TF
nHcw = simplifyFraction((subs(sHcw,[A0 a b Ka F1 F2 N],[nA0 na nb nKa nF(1) nF(2) nN])),'Expand',true)
[num,den] = numden(nHcw)
Hw = zpk(tf(sym2poly(num),sym2poly(den),Ts))

%
%nGa = double(subs(Ga,[A0 a b Ka F1 F2],[nA0 na nb nKa nF(1) nF(2)]))
%nBa1 = double(subs(Ba1,[A0 a b Ka],[nA0 na nb nKa]))
%nBa2 = double(subs(Ba2,[A0 a b Ka],[nA0 na nb nKa]))
%nCa = double(subs(Ca,[A0 a b Ka],[nA0 na nb nKa]))



