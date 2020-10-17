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
K1 = 0.0125
G1zeros = [-0.195 -2.821]
G1poles = [0 1 0.368 0.8187]
G1 = zpk(G1zeros,G1poles,K1)

% Convert TF to symbolic
%[num den] = tfdata(G1,'v')
%sG1 = poly2sym(num,z)/poly2sym(den,z)
%nG1 = vpa(simplify(subs(sG1,T,Ts)),4)

%% Part 2
% Transfer Function
K2 = 0.0003916
G2zeros = [-2.8276 -0.19]
G2poles = [1 1 0.2865]
G2 = zpk(G2zeros,G2poles,K2)

% Convert TF to symbolic
%[num den] = tfdata(G2,'v')
%sG2 = poly2sym(num,z)/poly2sym(den,z)
%nG2 = vpa(simplify(subs(sG2,T,Ts)),4)

% OST: The Rolling Stones
