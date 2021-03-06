%% Rafael Lima - q1
% Generated using |publish('q1.m',struct('format','pdf','outputDir','.')|

close all
clear all

syms s z T a b w K

%%
% Use partfrac to help with Z Transform
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

margin(nK1*Gw1)

%% Controler Atempt 0 - first order low pass filter

% Controler (found by manual binary search)
Tt = 1.5e-2;
Gc = tf(Tt,[1 Tt])

% Set Bode Plot Options
opts = bodeoptions('cstprefs');
opts.PhaseWrapping = 'on';
opts.PhaseWrappingBranch = -325;

% Graphical Evaluation
fig = figure();
bode(nK1*Gw1*Gc,opts);
hold on;
bode(nK1*Gw1,opts);
bode(Gc,opts);
xline((1/Ts)/4,'--')
hold off;

Gcz = c2d(Gc,Ts,'matched')

fig = figure();
step(feedback(nK1*Gcz*Gz1,1))

%% Find Delay Effect

Ga2 = tf(Ka,[1 0],Ts) % Ga(z) = z^-1

%% 
% Numeric ZOH Discretization 
Gz2 = c2d(G1*G2,Ts,'zoh')*Ga2
Gz2 = zpk(Gz2)

%%
% Convert TF to symbolic
[num den] = tfdata(Gz2,'v')
sGz2 = poly2sym(num,z)/poly2sym(den,z)

%%
% Find G(w) from numeric TF
zw = (2+T*w)/(2-T*w)
sGw2 = subs(sGz2,z,zw)
sGw2 = simplify(expand(subs(sGw2,T,Ts))) % Simplify expression

%%
% Convert symbolic to TF
[num,den] = numden(sGw2)
Gw2 = zpk(tf(sym2poly(num),sym2poly(den)))

%%
% Bode Plot
margin(nK1*Gcz*Gz2);

%%
% Set Bode Plot Options
opts = bodeoptions('cstprefs');
opts.PhaseWrapping = 'on';
opts.PhaseWrappingBranch = -360;

%%
% Graphical Evaluation of G1(w) and G2(w)
fig = figure();
bode(Gw1/nK1,opts);
hold on;
bode(Gw2/nK1,opts);
magAxis = fig.Children(end);
phaseAxis = fig.Children(end-1);

% Add marks at (1/Ts/4) to compare divergence
yline(phaseAxis,-180+PhaseMarginDeg,'--'); % Phase Plot
%xline(fig.Children(end),1/Ts/4,'--'); % Mag Plot
legend(magAxis); % Put legend at Mag plot
legend(phaseAxis); % Put legend at Mag plot
hold off;


%% First Atempt Controler

%%
% Get Point with Phase=-150 at bode plot
Wgc2 = 1.84774 % Found by manual binary search
Wgc1 = 3.7237 % Found by manual binary search

%%
% Find Gain at this point
[Gc1,phaseC1] = bode(Gw1/nK1,Wgc1)
[Gc2,phaseC2] = bode(Gw2/nK1,Wgc2)

%%
% Create a Controler with gain = 1/Gc to move W(0db) to the point with phase= -150 degres
Beta1 = Gc1
Beta2 = Gc2
Tlag1 = 100/Wgc1
Tlag2 = 100/Wgc2

%%
% Create TF
Glag1 = tf([Tlag1 1],[Tlag1*Beta1 1])
Glag2 = tf([Tlag2 1],[Tlag2*Beta2 1])

%%
% Graphical Evaluation
fig = figure();
margin(Gw1*Glag1/nK1);
hold on;
bode(Gw1/nK1,opts);
bode(Glag1,opts);
hold off;

%%
% Graphical Evaluation
fig = figure();
margin(Gw2*Glag2/nK1);
hold on;
bode(Gw2/nK1,opts);
bode(Glag2,opts);
hold off;

%% Second Atempt

PhaseMarginDeg = 51

%%
% Search W(phase = 180-PhaseMarginDeg )

dW = 1e-3
[Gain,Phase,Ww1] = bode(Gw1/nK1,0:dW:10);
positionDesired = dsearchn(Phase(1,1,:),360-(180-PhaseMarginDeg))
Gc21 = Gain(positionDesired)
phaseC21 = Phase(positionDesired)
Wgc21 = Ww1(positionDesired)

[Gain,Phase,Ww2] = bode(Gw2/nK1,0:dW:10);
positionDesired = dsearchn(Phase(1,1,:),360-(180-PhaseMarginDeg))
Gc22 = Gain(positionDesired)
phaseC22 = Phase(positionDesired)
Wgc22 = Ww2(positionDesired)

%%
% Create a Controler with gain = 1/Gc to move W(0db) to the point with phase= -150 degres
Beta21 = Gc21
Beta22 = Gc22
Tlag21 = 100/Wgc21
Tlag22 = 100/Wgc22

% Create TF
Glag21 = tf([Tlag21 1],[Tlag21*Beta21 1])
Glag22 = tf([Tlag22 1],[Tlag22*Beta22 1])

%%
% Graphical Evaluation
fig = figure();
margin(Gw1*Glag21/nK1);
hold on;
bode(Gw1/nK1,opts);
bode(Glag21,opts);
hold off;

%%
% Graphical Evaluation
fig = figure();
margin(Gw2*Glag22/nK1);
hold on;
bode(Gw2/nK1,opts);
bode(Glag22,opts);
hold off;

