%% EXSIM2 

% Clean Up Everything
clear
close all

% Get path from current file and generate absolute path
file_path = fileparts(mfilename('fullpath'))
img_path = strcat(file_path,"/../tex/img/")
tex_path = strcat(file_path,"/../tex/aux/")

% Define Symbols
syms s z T w K

% Transfer Function
Ts = 0.1
a0 = 1
Gnum = 1
Gden = [1 a0]
G = tf(Gnum,Gden)

% Generate Symbolic expression for (1/s)*G
sG = poly2sym(Gnum,s)/poly2sym(Gden,s);
partfrac((1/s)*sG)  % Calculate partial fraction

% Find G(w)
sGz = (1-exp(-T))/(z-exp(-T))
zw = (2+T*w)/(2-T*w)
sGw = subs(sGz,z,zw)

% Closed Loop with Controler
sGc = z/(z-1)
sGma = simplify(expand(K*sGc*sGz))
sGmf = simplify(expand(sGma/(1+sGma)))

% Find Max K for stable function
[~,poly] = numden(sGmf)
eval(subs(solve(poly,K),[z T],[-1 2]))

% Create File for table
fileTable = fopen(strcat(tex_path,"exsim3-g-table.tex"),"w")

for Ts = [0.5 1 2]
    [num,den] = numden(subs(sGc,T,Ts))
    Gc = tf(sym2poly(num),sym2poly(den),Ts)
    Gz = Gc*c2d(G,Ts,'zoh') % ZOH Discretization

    % Root Locus
    fig = figure()
    rlocus(Gz)
    xlim([-1.5 1])
    title(strcat("Root Locus (T=",num2str(Ts),")"))
    print(fig, strcat(img_path,"exsim3-rlocus-t",num2str(Ts*1000),"ms.png"),"-dpng")
    
    % Find Max Stable K
    kMax = eval(subs(solve(poly,K),[z T],[-1 Ts]))

    % Poles at K = 2
    poles2  = rlocus(Gz,2)

    % Transfer Function at K = 2
    [num,den] = numden(subs(sGmf,[K T],[2 Ts]))
    Gk2 = tf(sym2poly(num),sym2poly(den),Ts)

    % TODO Step Response with K = 2
    Gcc = feedback(Gz,Ts)
    fig = figure()    
    step(Gcc)
    title(strcat("Step Response (T=",num2str(Ts),")"))
    print(fig, strcat(img_path,"exsim3-step-t",num2str(Ts*1000),"ms.png"),"-dpng")

    % Step Response
    sysinfo = stepinfo(Gcc)

    % Calculate Damping
    damping = log(sysinfo.Overshoot)/sqrt(pi^2+(log(sysinfo.Overshoot)^2))

    % Print System Response to tex table
    fprintf(fileTable,"%.1f & %.3f & %.3f & %.3f\\\\\n",Ts, sysinfo.Overshoot, damping , sysinfo.SettlingTime);
end

fprintf(fileTable,"\n")
fclose(fileTable);

%% Part 2

% Transfer Function
Ts = 0.2
a0 = 2
Gnum = 1
Gden = conv([1 0],[1 a0])
G2 = tf(Gnum,Gden)

% Create TF from poles and zeros
% G2 = zpk([],[0 2],1)

% Generate Symbolic expression for (1/s)*G
sG2 = poly2sym(Gnum,s)/poly2sym(Gden,s);
partfrac((1/s)*sG2)  % Calculate partial fraction

Gz2 = c2d(G2,Ts,'zoh')

% Controler
sGc = (z-0.6703)/(z-0.1)
[num,den] = numden(subs(sGc,T,Ts))
Gc = tf(sym2poly(num),sym2poly(den),Ts)
Gmf2 = feedback(Gc*Gz2,1)

% Root Locus
fig = figure()
rlocus(Gz2)
zgrid()
xlim([-3 1.5])
print(fig, strcat(img_path,"exsim3-rlocus-g2.png"),"-dpng")

% Root Locus Controler
fig = figure()
rlocus(Gz2*Gc)
zgrid()
xlim([-3 1.5])
print(fig, strcat(img_path,"exsim3-rlocus-g2-control.png"),"-dpng")

% Step Response
fig = figure()
step(Gmf2)
sysinfo2 = stepinfo(Gmf2)
qsi = log(sysinfo2.Overshoot)/sqrt(pi^2+(log(sysinfo2.Overshoot)^2))
print(fig, strcat(img_path,"exsim3-step-g2-control.png"),"-dpng")

close all
