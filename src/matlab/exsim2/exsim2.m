%% EXSIM2 

% Clean Up Everything
clear
close all

% Get path from current file and generate absolute path
file_path = fileparts(mfilename('fullpath'))
img_path = strcat(file_path,"/../../tex/img/")

% Define Symbols
syms s z T

% Transfer Function
Ts = 0.1
a1 = 2
a0 = 3
Gnum = 1
Gden = conv([1 a1],[1 a0])
G = tf(Gnum,Gden)

% Generate Symbolic expression for G
sG = poly2sym(Gnum,s)/poly2sym(Gden,s)

%% ZOH
Gz = c2d(G,Ts,'zoh')

%% Forward Rectangle

% Find Transfer Function
Gzf = (z - 1)/T
Gof = subs(sG,s,Gzf)
Gof = expand(simplify(Gof))

% Convert Simbolic Expression to TF
[num,den] = numden(subs(Gof,T,Ts))
num = sym2poly(num)
den = sym2poly(den)
Gf = tf(num,den,Ts)

%% Backward Rectangle
Gzb = (z-1)/(T*z)
Gob = subs(sG,s,Gzb)
Gob = expand(simplify(Gob))

% Convert Simbolic Expression to TF
[num,den] = numden(subs(Gob,T,Ts))
num = sym2poly(num)
den = sym2poly(den)
Gb = tf(num,den,Ts)

%% Trapezoid
Gzd = 2*(z-1)/(T*(z+1))
God = subs(sG,s,Gzd)
God = expand(simplify(God))

% Convert Simbolic Expression to TF
[num,den] = numden(subs(God,T,Ts))
num = sym2poly(num)
den = sym2poly(den)
Gd = tf(num,den,Ts)

%% Match Poles
num = 1
den = conv([1 exp(-a1*Ts)],[1 exp(-a0*Ts)])
Gm = c2d(G,Ts,'matched')

%% Graphical Analysis

fig = figure()
step(Gz)
hold on;
step(G,':')
hold off;
legend("Gz","G")
print(fig, strcat(img_path,"exsim2-plot-g-zoh.png"),"-dpng")

fig = figure()
step(Gf)
hold on;
step(G,':')
hold off;
legend("Gf","G")
print(fig, strcat(img_path,"exsim2-plot-g-forward.png"),"-dpng")

fig = figure()
step(Gb)
hold on;
step(G,':')
hold off;
legend("Gb","G")
print(fig, strcat(img_path,"exsim2-plot-g-backward.png"),"-dpng")

fig = figure()
step(Gd)
hold on;
step(G,':')
hold off;
legend("Gd","G")
print(fig, strcat(img_path,"exsim2-plot-g-trap.png"),"-dpng")

fig = figure()
step(Gm)
hold on;
step(G,':')
hold off;
legend("Gm","G")
print(fig, strcat(img_path,"exsim2-plot-g-matched.png"),"-dpng")

close all

%% Question 2
syms a b kp kc J w0

sG2 = kp/(J*s*s)
sH2 = kc*(s+b)/(s+a)
sG1 = b*kc/a

sG2mf = sG1*(sG2/(1+sG2*sH2))
G2mf = subs(sG2mf,[a b kc],[2*w0 w0/2 2*J*w0*w0/kp])

% Convert Simbolic Expression to TF
[num,den] = numden(subs(G2mf,w0,1))
num = sym2poly(num)
den = sym2poly(den)
G2 = tf(num,den,Ts)

fig = figure()
margin(G2)
print(fig, strcat(img_path,"exsim2-plot-bode2.png"),"-dpng")

%% Simulink Simulation

% Export Model as PNG
modelFileName = 'exsim2model'
pictureFileName = strcat(img_path,modelFileName,'.png');   % Generate name from model name
print(['-s',modelFileName],'-dpng',pictureFileName);      % Generate PDF
