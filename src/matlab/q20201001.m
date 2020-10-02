%% QUESTION 2020-10-01
% Gerado usando |publish('q20201001.m',struct('format','pdf','outputDir','.')|

clear all
close all

%% Estudo comportamento atual do sistema
% Para todo projeto de controlador vale o mesmo princípio de todo sistema cibernético. Primeiro vemos como o sistema está se comportando, avaliamos a distância do desejado e ajustamos conforma a necessidade.

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
fig = figure()
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
fig = figure()
margin(Gw)

%%
% Cálculo da margem de Ganho (Gm) e Marge de Fase (Pm)
[Gm,Pm,Wcg,Wcp] = margin(Gw)

%% Projeto Controlador
% Temos que para este sistema a margem de fase é diferente de 50. Para ajustar isto temos que verificar qual é o ganho atual do sistema e diferença entre o ganho do ponto que possui e fornecer este valor para o ganho $K$. Pelo gráfico temos que no ponto igual $w=4.99rad/s$ a fase é aproximadamente igual a desejada e possui ganho igual a $34.8 dB$ assim basta adicionar um gnaho $K$ tal que $20 log(K) = 34.8 dB$ logo

[Gd,Pd] = bode(Gw,4.99)
GdesiredAtDesiredPhase = -20*log10(Gd)
K = 10^(GdesiredAtDesiredPhase/20)
% K = 1/Gd % Para a resposta direta

%%
% Verificando temos
[Gm,Pm,Wcg,Wcp] = margin(K*Gw)

%%
% E assim passamos a seguinte resposta em frequência do sistema
fig = figure()
margin(K*Gw)


