%% Rafael Lima - q2
% Generated using |publish('q2.m',struct('format','pdf','outputDir','.')|

close all
clear all

syms s z T a b

pretty(partfrac(1/((s+a)*s^2)))

%%
% Plant Specs
Ts = 0.2
G = tf(10,[1 0.8 0])

%%
% ZOH Discretization
Gz = c2d(G,Ts,'zoh')

%%
% Convert TF to symbolic
[num den] = tfdata(Gz,'v')
sGz = poly2sym(num,z)/poly2sym(den,z)

%%
% Define Gain Vector
F1 = sym('F_1')
F2 = sym('F_2')
F = [F1 F2]

%%
% Apply Feedback
sys = ss(Gz)
Ao = sys.A - sys.B*F
Bo = sys.B
Co = sys.C
Do = sys.D

%%
% Characterist Poly
I = eye(size(Ao));
plantPoly = flip(coeffs(det(z*I-Ao),z))

%%
% Find Desired Poly
desiredPoles = [complex(0.8,0.25),complex(0.8,-0.25)]
desiredPoly = poly(desiredPoles)

%%
% Find Feedback Gain
polyF = (plantPoly-desiredPoly)
[m,v] = equationsToMatrix(polyF(2:end),F);
nF = linsolve(m,v)


