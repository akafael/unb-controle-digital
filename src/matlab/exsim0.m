%% Questions?
% Gerado usando |publish('exsim0.m',struct('format','pdf','outputDir','.')|

% Clean Up Everything
clear
close all

% Get path from current file and generate absolute path
file_path = fileparts(mfilename('fu?llpath'))
img_path = strcat(file_path,"/../../tex/img/")

%% QUESTION 1a

% Define Symbols
syms s z T

% Coeficients 
Ts = 0.1
K0 = 5
K1 = 3.2
a0 = 1
a1 = 4

%%
% Transfer Function
G = tf(K0,[1 a0 0])
Gc = tf(K1*[1 a0],[1 a1])

%%
% Symbolic Expressions
sG = poly2sym(K0,s)/poly2sym([1 a0 0],s)
sGc = poly2sym(K1*[1 a0],s)/poly2sym([1 a1],s)

%%
% Find Closed Loop Transfer Function
Gma = G*Gc
Gmf = feedback(Gma,1)

%%
% Find Partial Frac Expression
partfrac(sG/s)

%%
% From z Transform table
sGz = K0*(1-z^(-1))*((z/(z-exp(-a0*T))) - (z/(z-1)) + (T*z/((z-a0)^2)))
sGz = collect(simplify(expand(sGz)),z)

% Simplify
vpa(simplify(expand(subs(sGz,T,Ts))),4)

%%
% ZOH
Gz = c2d(G,Ts,'zoh')


%% QUESTION 1b

%%
% Forward Rectangle

% Find Transfer Function
Gzf = (z - 1)/T
sGcf = subs(sGc,s,Gzf)
sGcf = expand(simplify(sGcf))

% Convert Simbolic Expression to TF
[num,den] = numden(subs(sGcf,T,Ts))
num = sym2poly(num)
den = sym2poly(den)
Gcf = tf(num,den,Ts)

%%
% ZOH Method
Gcz = c2d(G,Ts,'zoh')

%%
% Mached Poles Method
Gcm = c2d(G,Ts,'matched')

%% QUESTION 1c

%%
% Find Desired Poles
MP = 0.1633333333333333333333333333333333
tc = 2

qsi = -log(MP)/sqrt(pi^2 + (log(MP))^2)
qsi = 0.5
w0 = tc/qsi

DesiredPoles = roots([1 2*tc w0^2])
DesiredPolesZ = exp(-DesiredPoles*Ts)


