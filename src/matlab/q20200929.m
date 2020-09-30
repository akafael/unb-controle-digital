%% QUESTION 2020-09-29
% Gerado usando |publish('q20200929.m',struct('Format','pdf','outputDir','.')|

clear all
close all

%%
% Calcula Função de Transferência
K = 1
Ts = 0.1
G = tf(1,[1 10 0])

%%
% Discretização usando ZOH
Gz = c2d(G,Ts,'zoh')

%%
% Diagram de bode com indicação da margem de ganho e da margem de fase para o sistema contínuo
margin(G)

%%
% Cálculo da margem de Ganho (Gm) e Marge de Fase (Pm)
[Gm,Pm,Wcg,Wcp] = margin(G)

%%
% Converte TF para expressão simbólica
syms z w T
[num den] = tfdata(Gz,'v')
sGz = poly2sym(num,z)/poly2sym(den,z)
vpa(simplify(subs(sGz,T,Ts)),4) % Arrendonda para facilitar visualização

%%
% Aplicando transformação do plano s para o plano w
wz = (1 + (T/2)*w)/(1-(T/2)*w)
sGw = subs(sGz,z,wz)
vpa(simplify(subs(sGw,T,Ts)),4) % Arrendonda para facilitar visualização

%%
% Calculo de Kv através do $$lim_{w \to 0}w*G(w)$$
exprLimKv = w*simplifyFraction(subs(sGw,T,Ts))
Kv = eval(subs(simplify(exprLimKv),w,0))

% Convertendo de expressão simbólica para TF
[num,den] = numden(subs(sGw,T,Ts))
num = sym2poly(num)
den = sym2poly(den)
Gw = zpk(tf(num,den))

%%
% Diagram de bode com indicação da margem de ganho e da margem de fase para o sistema discretizado
margin(Gw)

%%
% Cálculo da margem de Ganho (Gm) e Marge de Fase (Pm)
[Gm,Pm,Wcg,Wcp] = margin(Gw)

