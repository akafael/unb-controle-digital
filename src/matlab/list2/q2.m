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
[Gnum Gden] = tfdata(Gz,'v')
sGz = poly2sym(Gnum,z)/poly2sym(Gden,z)

%%
% Find Desired Poly
desiredPoles = [complex(0.8,0.25),complex(0.8,-0.25)]
desiredPoly = poly(desiredPoles)

%%
% Define Closed Loop Expected Transfer Function
K1 = polyval(desiredPoly,1)/polyval(Gnum,1)
l = 2
Gm = K1*tf(Gnum,desiredPoly,Ts)*zpk([],zeros(1,l),1,Ts)

%%
% Find Controler Transfer Function
Gc = (1/Gz)*(Gm/(1-Gm))

%%
% Find Closed Loop Transfer Function
Gmr = feedback(Gc*Gz,1)
Gmr = minreal(Gmr,1e-3) % Zero/Pole simplification

%%
% Controler Evaluation
step(Gmr)
stepinfo(Gmr)
