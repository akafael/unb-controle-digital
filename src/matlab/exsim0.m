%% Questions?
% Gerado usando |publish('exsim0.m',struct('format','pdf','outputDir','.')|

% Clean Up Everything
clear
close all

% Get path from current file and generate absolute path
file_path = fileparts(mfilename('fullpath'))
img_path = strcat(file_path,"/../../tex/img/")

%% QUESTION 1a

% Define Symbols
syms s z T

% Coeficients 
q1Ts = 0.02
q1K0 = 5
q1K1 = 3.2
q1a0 = 1
q1a1 = 4

%%
% Transfer Function
q1G = tf(q1K0,[1 q1a0 0])
q1Gc = tf(q1K1*[1 q1a0],[1 q1a1])

%%
% Symbolic Expressions
q1sG = poly2sym(q1K0,s)/poly2sym([1 q1a0 0],s)
q1sGc = poly2sym(q1K1*[1 q1a0],s)/poly2sym([1 q1a1],s)

%%
% Find Closed Loop Transfer Function
q1Gma = q1G*q1Gc
q1Gmf = feedback(q1Gma,1)

%%
% Find Partial Frac Expression
partfrac(q1sG/s)

%%
% From z Transform table
q1sGz = q1K0*(1-z^(-1))*((z/(z-exp(-q1a0*T))) - (z/(z-1)) + (T*z/((z-q1a0)^2)))
q1sGz = collect(simplify(expand(q1sGz)),z)

% Simplify
vpa(simplify(expand(subs(q1sGz,T,q1Ts))),4)

%%
% ZOH
q1Gz = c2d(q1G,q1Ts,'zoh')


%% QUESTION 1b

%%
% Forward Rectangle

% Find Transfer Function
q1Gzf = (z - 1)/T
q1sGcf = subs(q1sGc,s,q1Gzf)
q1sGcf = expand(simplify(q1sGcf))

% Convert Simbolic Expression to TF
[num,den] = numden(subs(q1sGcf,T,q1Ts))
num = sym2poly(num)
den = sym2poly(den)
q1Gcf = zpk(tf(num,den,q1Ts))

%%
% ZOH Method
q1Gcz = zpk(c2d(q1Gc,q1Ts,'zoh'))

%%
% Mached Poles Method
q1Gcm = zpk(c2d(q1Gc,q1Ts,'matched'))

%% QUESTION 1c

%%
% Find Desired Poles
q1MP = 0.163333
q1tc = 2

q1qsi = -log(q1MP)/sqrt(pi^2 + (log(q1MP))^2) % From MP
q1qsi = 0.5 % From TF
q1w0 = q1tc/q1qsi

q1DesiredPoles = roots([1 2*q1tc q1w0^2])
q1DesiredPolesZ = exp(q1DesiredPoles*q1Ts)


%% QUESTION 1d

%%
%
zpk(feedback(q1Gcm*q1Gz,1))

q1polesFm = rlocus(q1Gcm*q1Gz,1)

rlocus(q1Gcm*q1Gz);
hold on;
plot(q1DesiredPolesZ,'*')
ylim(3*[-1 1]);
xlim(3*[-1 1]);
hold off;

%%
%
zpk(feedback(q1Gcf*q1Gz,1))

q1polesFf = rlocus(q1Gcf*q1Gz,1)

rlocus(q1Gcf*q1Gz);
hold on;
plot(q1DesiredPolesZ,'*')
ylim(3*[-1 1]);
xlim(3*[-1 1]);
hold off;

%%
%
zpk(feedback(q1Gcz*q1Gz,1))

q1polesFz = rlocus(q1Gcz*q1Gz,1)

rlocus(q1Gcz*q1Gz);
hold on;
plot(q1DesiredPolesZ,'*')
ylim(3*[-1 1]);
xlim(3*[-1 1]);
hold off;

%%
%

step(feedback(q1G*q1Gc,1))
hold on;
step(feedback(q1Gcm*q1Gz,1),'--')
step(feedback(q1Gcf*q1Gz,1),'-.')
step(feedback(q1Gcz*q1Gz,1),'.')
legend('Continuos','Matched','Forward','ZOH')
hold off;

%% QUESTION2

close all

syms s z T Kc D a b K2 D

% Coeficients
q2Ts = 0.2
q2na = 0.6
q2nb = 1.5
q2K2 = 2

% Expressions
q2sG1 = a/(s+a)
q2sG2 = q2K2/(s+b)
q2sGc = Kc
q2sQ = D/s
q2sGho = 1/s

q2sGma0 = (q2sGc*q2sG1*q2sGho+q2sQ)*q2sG2
q2sGma1 = subs(q2sGma0,[a b],[q2na q2nb])

q2sG = collect(simplify(expand((subs((q2sQ+q2sG1)*q2sG2,[a b],[q2na q2nb])))),s)

%%
%
pretty((4/9)*partfrac((9/4)*q2sG/s))

%%
% From Table
q2sGz = (3*D)*(T*z/((z-1)^2)) - (2*D - 3)*(z/(z-1)) - 5*(z/(z-exp(-(3/5)*T))) + (2*D + 2)*(z/(z-exp(-(3/2)*T)))
q2sGmaz = (1-z^(-1))*(4/9)*q2sGz

pretty(q2sGmaz)

q2sGmfz = collect(simplifyFraction((q2sGc*q2sGmaz)/(1+q2sGc*q2sGmaz)),[Kc z D])

q2nGmaz = vpa(subs(collect(simplifyFraction(q2sGmaz),z),T,q2Ts),4)

q2nGmfz = vpa(collect(subs(q2sGmfz,T,q2Ts),z),4)

%% QUESTION 2c

%%
% SteadState Error
q2exprLimErrorStep = collect(subs(q2sGmaz,[T D],[q2Ts 0]),z)
q2exprErrorStep = subs(q2nGmaz,[D z],[0 0])

q2DesiredErrorStep = 0.1
q2nKc = eval(solve(q2exprErrorStep - q2DesiredErrorStep,Kc))

%% QUESTION3

syms s z T Kc Td

% Coefficients
q3Ts = 1

% Transfer Function
q3G = tf(1,[1 0 0])

sGz = (T^2)*((z+1)/(2*(z-1)^2))

sIGmf = collect(simplifyFraction(((1+Td)*z -1)/z + (1/Kc)*(1/sGz)),z)

q3Gmf = collect(subs(1/sIGmf,T,1),Kc)



%% QUESTION 3b
q3MP = 0.2
q3w0 = (2*pi)/(12*q3Ts)
q3qsi = -log(q1MP)/sqrt(pi^2 + (log(q1MP))^2) % From MP

q3tc = q3qsi*q3w0

q3DesiredPoles = roots([1 2*q3tc q3w0^2])
q3DesiredPolesZ = exp(q3DesiredPoles*q3Ts)


%%

[num,den] = numden(q3Gmf)
eqSis1 = subs(den,[T z (Kc*Td)],[1 q3DesiredPolesZ(1) a])
eqSis2 = subs(den,[T z (Kc*Td)],[1 q3DesiredPolesZ(2) a])
[A,B] = equationsToMatrix([eqSis1 eqSis2],[Kc,a]);
solutionKb = linsolve(A,B);

q3Kc = eval(solutionKb(1))
q3Td = eval(solutionKb(2))/q3Kc

%% 
%
q3poly = vpa(subs(den,[Kc Td],[q3Kc q3Td]),4)
poles = solve(vpa(subs(den,[Kc Td],[q3Kc q3Td]),4),z)

