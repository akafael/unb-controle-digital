%% EXSIM2 


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

%% Transformada Z


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
Gm = tf(num,den,Ts)

%% Graphical Analysis

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
