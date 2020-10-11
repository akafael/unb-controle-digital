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

% Cálculo da margem de Ganho (Gm) e Marge de Fase (Pm)
[Gwm,Pwm,Wwcg,Wwcp] = margin(Gw)

