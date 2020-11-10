%% LAB ?? - q1

close all
clear all

syms s z T a b w

pretty(partfrac(1/((s+a)*(s+b)*s)))

% Constants
na = 1.25
nb = 5
Ka = 8
Ts = 0.4

% Transfer Functions
G1 = tf(na,[1 na])
G2 = tf(2*nb,[1 nb])
Ga = tf(Ka)

% Generate Symbolic expression for (1/s)*Gs1
sGs1 = Ka/((s+na)*(s+nb))
partfrac((1/s)*sGs1)  % Calculate partial fraction

% Numeric ZOH Discretization 
Gs1 = G1*G2*Ga
Gz1 = c2d(Gs1,Ts,'zoh')

% Convert TF to symbolic
[num den] = tfdata(Gz1,'v')
sGz1 = poly2sym(num,z)/poly2sym(den,z)

% Find G(w) from numeric TF
zw = (2+T*w)/(2-T*w)
sGw1 = subs(sGz1,z,zw)

% Convert symbolic to TF
[num,den] = numden(subs(sGw1,T,Ts))
Gw1 = zpk(tf(sym2poly(num),sym2poly(den)))

% Bode Plot
margin(Gw1)

% Project Requirements
MaxError = 0.02
GainMarginDB = 10
PhaseMarginDeg = 50
PhaseMarginRad = degtorad(PhaseMarginDeg*1.1) % Convert and add safety margin


