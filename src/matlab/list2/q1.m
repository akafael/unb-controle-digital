%% LAB ?? - q1

close all
clear all

syms s z T a b w K

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
sGw1 = simplify(expand(subs(sGw1,T,Ts))) % Simplify expression

% Convert symbolic to TF
[num,den] = numden(sGw1)
Gw1 = zpk(tf(sym2poly(num),sym2poly(den)))

% Bode Plot
%margin(Gw1)

% Project Requirements
MaxError = 0.02
GainMarginDB = 10
PhaseMarginDeg = 50
PhaseMarginRad = degtorad(PhaseMarginDeg*1.1) % Convert and add safety margin

% Input Signal ( Unitary Step )
sR = 1/(w)                         % Symbolic
R = tf(1,[1 0])                    % Transfer Function

% Find Current Steady State Error
Kp1 = double(subs(sGz1,z,1))
Ess1 = 1/(1+Kp1)

% Find Gain for desired Steady State Error
exprK = MaxError - 1/(1+(Kp1*K))
K1 = solve(exprK,K)
nK1 = double(K1)

%margin(nK1*Gw1)

% Controler (found by manual binary search)
Tt = 1.5e-2;
Gc = tf(Tt,[1 Tt])

% Set Bode Plot Options
opts = bodeoptions('cstprefs');
opts.PhaseWrapping = 'on';
opts.PhaseWrappingBranch = -325

% Graphical Evaluation
%fig = figure()
%bode(nK1*Gw1*Gc,opts)
%hold on;
%bode(nK1*Gw1,opts)
%bode(Gc,opts)
%xline((1/Ts)/4,'--')
%hold off;

Gcz = c2d(Gc,Ts,'matched')

fig = figure()
step(feedback(nK1*Gcz*Gz1,1))

%%

Ga2 = tf(Ka,[1 0],Ts) % Ga(z) = z^-1

% Numeric ZOH Discretization 
Gz2 = c2d(G1*G2,Ts,'zoh')*Ga2
Gz2 = zpk(Gz2)

% Convert TF to symbolic
[num den] = tfdata(Gz2,'v')
sGz2 = poly2sym(num,z)/poly2sym(den,z)

% Find G(w) from numeric TF
zw = (2+T*w)/(2-T*w)
sGw2 = subs(sGz2,z,zw)
sGw2 = simplify(expand(subs(sGw2,T,Ts))) % Simplify expression

% Convert symbolic to TF
[num,den] = numden(sGw2)
Gw2 = zpk(tf(sym2poly(num),sym2poly(den)))

% Bode Plot
%margin(nK1*Gcz*Gz2)

% TODO Check Controler Project Procedure ( do I use G(w) or G(z) ?)

