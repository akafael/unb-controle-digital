%% EXSIM5

% Start Safe n Sound by Clean Up Everything
clear
close all

% Get path from current file and generate absolute path
file_path = fileparts(mfilename('fullpath'))
img_path = strcat(file_path,"/../../tex/img/")

% Define Symbols
syms s z T


%% Part 1
% Transfer Function
Ts = 1
K1 = 0.0125
G1zeros = [-0.195 -2.821]
G1poles = [0 1 0.368 0.8187]
G1 = zpk(G1zeros,G1poles,K1,Ts)

% Convert TF to symbolic
sG1 = poly2sym(poly(G1zeros),z)/poly2sym(poly(G1poles),z)
nG1 = vpa(sG1,4)

% Minimum-Time Deadbeat Control
[num,den] = numden(sG1)
l = size(solve(den,z),1)-size(solve(num,z),1) % l => (#poles-#zeros)

% Ripple Free Deadbeat Controler
num = poly2sym(poly(G1zeros),z)
den = poly2sym(poly(G1poles),z)
l = size(G1poles,2) % l => (#poles-#zeros) + #zeros = #poles
num1 = polyval(poly(G1zeros),1)
sM1 = num/(num1*z^l)
sGc1 = (den/num1)/(z^l-(num/num1))

% Ripple Free Controler
Gc1 = zpk(tf(poly((1/num1)*G1poles),sym2poly(z^l -(1/num1)*num),Ts))

% Ripple Free Closed Loop Transfer Function
M1 = zpk((1/num1)*G1zeros,zeros(1,l),1,Ts)

fig = figure()
title("Ripple Free Deadbeat")
step(M1)
xticks(0:Ts:20)
grid
legend('M_1(z)')
print(fig, strcat(img_path,"exsim5-g1-deadbeat-sim.png"),"-dpng")


%% Part 2
% Transfer Function
K2 = 0.0003916
G2zeros = [-2.8276 -0.19]
G2poles = [1 1 0.2865]
G2 = zpk(G2zeros,G2poles,K2,Ts)

% Convert TF to symbolic
sG2 = poly2sym(poly(G2zeros),z)/poly2sym(poly(G2poles),z)
nG2 = vpa(sG2,4)

% Deadbeat Controler
n = size(G2poles,2) - size(G2zeros,2) % n => (#poles-#zeros)
sM2 = ((n+1)*z+n)/(z^(n+1))
sGc2 = (1/sG2)*(((n+1)*z+n)/(z^(n+1)-((n+1)*z +n)))

M2 = zpk(tf([(n+1) n],[1 zeros(1,n)],Ts))
Gc2 = zpk((1/G2)*(M2/(1-M2)))

% Graphical Evaluation
fig = figure()
title("Ripple Free Deadbeat")
lsim(M2,0:Ts:20)
xticks(0:Ts:20)
grid
legend('M_2(z)')
print(fig, strcat(img_path,"exsim5-g2-deadbeat-sim.png"),"-dpng")

% Soundtrack: Dust in the Wind - Kansas
