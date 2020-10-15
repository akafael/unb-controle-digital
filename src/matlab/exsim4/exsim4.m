%% EXSIM4

% Clean Up Everything
clear
close all

% Get path from current file and generate absolute path
file_path = fileparts(mfilename('fullpath'));
img_path = strcat(file_path,"/../../tex/img/");
tex_path = strcat(file_path,"/../../tex/aux/");

% Define Symbols
syms s z T w K;

%% Part 1

% Calcula Função de Transferência
K = 1
Ts = 0.2
G = tf(1,[1 1 0])

% Discretization usando ZOH
Gz = c2d(G,Ts,'zoh')

% Cálculo da margem de Ganho (Gm) e Marge de Fase (Pm)
[Gm,Pm,Wcg,Wcp] = margin(G)

% Convert TF to symbolic
syms z w T
[num den] = tfdata(Gz,'v')
sGz = poly2sym(num,z)/poly2sym(den,z)
nGz = vpa(simplify(subs(sGz,T,Ts)),4) % Arrendonda para facilitar visualização

% Find W Transform
zw = (2+T*w)/(2-T*w)
sGw = subs(sGz,z,zw)

% Convert symbolic to TF
[num,den] = numden(subs(sGw,T,Ts))
Gw = zpk(tf(sym2poly(num),sym2poly(den)))

% Generate Figure
fig = figure()
margin(Gw)
print(fig, strcat(img_path,"exsim4-bodeplot-gw"),"-dpng")

% Find K
exprLimGw = w*sGw
Ev = vpa(subs(exprLimGw,[T w],[0.2 1e-8]),4) % I had to put very small number intead zero.
Kvw = 1/Ev

% Cálculo da margem de Ganho (Gm) e Marge de Fase (Pm)
[Gwm,Pwm,Wwcg,Wwcp] = margin(Gw)

% Convert to Discret using exact matched poles
Gzw = c2d(Gw,Ts,'matched')

% Convert TF to symbolic
[num den] = tfdata(Gzw,'v')
sGzw = poly2sym(num,z)/poly2sym(den,z)

% Find K
exprLimGw = z*sGzw
Ev = vpa(subs(exprLimGw,[T z],[0.2 1e-8]),4) % I had to put very small number intead zero.
Kvzw = 1/Ev


%% PART2 - Lead Controler

% Project Requirement
GainMarginDB = 10
PhaseMarginDeg = 50
PhaseMarginRad = degtorad(PhaseMarginDeg*1.1) % Convert and add safety margin

% Get Current Phase and Gain Margin
[Gwm,Pwm,Wwcg,Wwcp] = margin(Gw)

% Find Parameters
phi = sin(PhaseMarginRad);
alpha = (1+phi)/(1-phi);
Wlead = Wwcg;
Tlead = 1/(alpha*Wlead);

pause
% Lead Controler
Gwlead = tf([alpha*Tlead 1],[Tlead 1]);

% Convert TF to symbolic
[num den] = tfdata(Gwlead,'v')
sGwlead = poly2sym(num,z)/poly2sym(den,z)

% Check Requirements
[Gm2,Pm2,Wcg2,Wcp2] = margin(Gwlead*Gw);
assert( 20*log10(Gm2) > GainMarginDB, 'Error: Gain margin smaller than Required!' )
assert( Pm2 > PhaseMarginDeg , 'Error: Phase margin smaller than Required!' )

% Graphical Evaluation
fig = figure()
hold on;

% Set Bode Plot Options
opts = bodeoptions('cstprefs');
opts.PhaseWrapping = 'on';
opts.PhaseWrappingBranch = -270

bode(Gw,opts)
margin(Gw*Gwlead)

legend('G(w)','Gc(w)G(w)')
hold off;

print(fig, strcat(img_path,"exsim4-control-gw"),"-dpng")

%% PART3 - Lead Controler

% Project Requirement
GainMarginDB = 10
PhaseMarginDeg = 50
PhaseMarginRad = degtorad(PhaseMarginDeg*1.5) % Convert and add safety margin

% Get Current Phase and Gain Margin
[Gzm,Pzm,Wzcg,Wzcp] = margin(Gzw)

% Find Parameters
phi = sin(PhaseMarginRad);
alpha = (1+phi)/(1-phi);
Wzlead = Wzcg;
Tlead = 1/(alpha*Wzlead);

% Lead Controler
Gzwlead = tf([alpha*Tlead 1],[Tlead 1],Ts);

% Convert TF to symbolic
[num den] = tfdata(Gwlead,'v')
sGzwlead = poly2sym(num,z)/poly2sym(den,z)

% Check Requirements
[Gm3,Pm3,Wcg3,Wcp3] = margin(Gzw);
assert( 20*log10(Gm3) > GainMarginDB, 'Error: Gain margin smaller than Required!' )
assert( Pm3 > PhaseMarginDeg , 'Error: Phase margin smaller than Required!' )

% Graphical Evaluation
fig = figure()
hold on;

% Set Bode Plot Options
opts = bodeoptions('cstprefs');
opts.PhaseWrapping = 'on';
opts.PhaseWrappingBranch = -270

bode(Gw,opts)
margin(Gzw*Gzwlead)

legend('Gw(z)','Gc(w)Gw(z)')
hold off;

print(fig, strcat(img_path,"exsim4-control-gzw"),"-dpng")

%% PART 4- Compare Discretization

fig = figure()
hold on;

% Set Bode Plot Options
opts = bodeoptions('cstprefs');
opts.PhaseWrapping = 'on';
opts.PhaseWrappingBranch = -270

bode(G,opts)
bode(Gw,opts)
bode(Gzw,opts)

legend('G(s)','G(w)','Gw(z)','(1/Ts)/4')

% Add marks at (1/Ts/4) to compare divergence
xline(fig.Children(end-1),1/Ts/4,'--'); % Phase Plot
xline(fig.Children(end),1/Ts/4,'--'); % Mag Plot
hold off;

print(fig, strcat(img_path,"exsim4-bodeplot-compare"),"-dpng")

%% Compare Controlers

fig = figure()
hold on;

% Set Bode Plot Options
opts = bodeoptions('cstprefs');
opts.PhaseWrapping = 'on';
opts.PhaseWrappingBranch = -270

bode(Gw*Gwlead,opts)
bode(Gzw*Gzwlead,opts)

legend('G(s)','G(w)','(1/Ts)/4')

% Add marks at (1/Ts/4) to compare divergence
xline(fig.Children(end-1),1/Ts/4,'--'); % Phase Plot
xline(fig.Children(end),1/Ts/4,'--'); % Mag Plot
hold off;

print(fig, strcat(img_path,"exsim4-bodeplot-compare-control"),"-dpng")

