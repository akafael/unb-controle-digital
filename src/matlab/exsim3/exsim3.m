%% EXSIM2 

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
    title(strcat("Root Locus (T=",num2str(Ts),"s)"))
    print(fig, strcat(img_path,"exsim3-rlocus-t",num2str(Ts*1000),"ms.png"),"-dpng")
    
    % Find Max Stable K
    kMax = eval(subs(solve(poly,K),[z T],[-1 Ts]))

    % Poles at K = 2
    poles2  = rlocus(Gz,2)

    % Transfer Function at K = 2
    Kc = 2
    [num,den] = numden(subs(sGmf,[K T],[Kc Ts]))
    Gk2 = tf(sym2poly(num),sym2poly(den),Ts)

    % Step Response
    Gcc = feedback(Gz,Ts)
    sysinfo = stepinfo(Gcc)

    % Calculate Damping
    damping = log(sysinfo.Overshoot)/sqrt(pi^2+(log(sysinfo.Overshoot)^2))

    % Print System Response to tex table
    fprintf(fileTable,"%.1f & (%s, %s) & %.2f & %.3f & %.2f\\\\\n",...
            Ts,...
            num2str(poles2(1)), num2str(poles2(2)),...
            sysinfo.Overshoot/100, damping , sysinfo.SettlingTime);

    % Run Model 1 simulation
    sim('exsim3modelPart1') % export simramp and sim step

    % Step Response with K = 2
    fig = figure()    
    step(Gcc)
    plot(simstep) 
    title(strcat("Step Response (T=",num2str(Ts),"s)"))
    legend("input","output")
    print(fig, strcat(img_path,"exsim3-step-t",num2str(Ts*1000),"ms.png"),"-dpng")

    % Ramp Response with K = 2
    fig = figure()    
    plot(simramp) 
    title(strcat("Ramp Response (T=",num2str(Ts),"s)"))
    legend("input","output")
    print(fig, strcat(img_path,"exsim3-ramp-t",num2str(Ts*1000),"ms.png"),"-dpng")
end

fprintf(fileTable,"\n");
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
sGz2 = poly2sym(Gz2.num{1},z)/poly2sym(Gz2.den{1},z);

fileEq = fopen(strcat(tex_path,"exsim3-eq-g2-tf.tex"),"w");
fprintf(fileEq,"G(z),%s\n",latex(sGz2));
fclose(fileEq);

% Request Conditions
desiredDamping = 0.5
desiredSettlingTime = 2
desiredOvershoot = exp(-desiredDamping*pi/sqrt(1-desiredDamping^2))
desiredPoles = -(4/desiredSettlingTime)*(1 + i*[1 -1]*sqrt(1-desiredDamping^2)/desiredDamping)
desiredPolesZ = exp(desiredPoles*Ts)

% Controler
sGc = (z-exp(-2*Ts))/(z-0.25)
syms b
sGc2 = K*(z-exp(-2*Ts))/(z-b)
sGma2 = simplify(expand(sGc2*sGz2))
sGmf2 = simplify(expand(sGma2/(1+sGma2)))

% Find K and b for the controler
[~,poly2] = numden(sGmf2)
eqKb1 = subs(poly2,z,desiredPolesZ(1));
eqKb2 = subs(poly2,z,desiredPolesZ(2));
[A,B] = equationsToMatrix([eqKb1,eqKb2],[K,b]);
solutionKb = linsolve(A,B);
Kd = eval(solutionKb(1));
nb = eval(solutionKb(2));

% Generate TF with calculeted K and b
nGmf2 = subs(sGc2,[T K b],[Ts Kd nb])
[num,den] = numden(nGmf2)
Gc = tf(sym2poly(num),sym2poly(den),Ts)
Gmf2 = zpk(feedback(Gc*Gz2,1))

% Root Locus
fig = figure()
hold on;
rlocus(Gz2)
zgrid()
plot(desiredPolesZ,'*')
xlim([-3 1.5])
hold off;
print(fig, strcat(img_path,"exsim3-rlocus-g2.png"),"-dpng")

% Root Locus Controler
fig = figure()
hold on;
rlocus(Gz2*Gc)
zgrid()
plot(desiredPolesZ,'*')
xlim([-3 1.5])
hold off;
print(fig, strcat(img_path,"exsim3-rlocus-g2-control.png"),"-dpng")

% Step Response Evaluation
sysinfo2 = stepinfo(Gmf2)
qsi = log(sysinfo2.Overshoot)/sqrt(pi^2+(log(sysinfo2.Overshoot)^2))

% Step Response
fig = figure()
hold on;
step(Gmf2)
%yline(desiredOvershoot+sysinfo2.SettlingMax,':')
xline(desiredSettlingTime,':')
legend("G","")
hold off;
print(fig, strcat(img_path,"exsim3-step-g2-control.png"),"-dpng")

% Ramp Response
fig = figure()
hold on;
lsim(Gmf2,0:Ts/2:sysinfo2.SettlingTime*1.5)
xline(desiredSettlingTime,':')
legend("G","")
title("Ramp")
hold off;
print(fig, strcat(img_path,"exsim3-ramp-g2-control.png"),"-dpng")


%% Part 2 - Project 2
gamma = 0.01
Kcss = 3
Gcss = tf([1 gamma],[1 gamma*Kcss],Ts)

Gmf3 = zpk(feedback(Gcss*Gc*Gz2,1))

% Step Response
fig = figure()
hold on;
step(Gmf2)
step(Gmf3)
%yline(desiredOvershoot+sysinfo2.SettlingMax,':')
xline(desiredSettlingTime,':')
legend("Gc","Gc*Gc2")
hold off;
print(fig, strcat(img_path,"exsim3-step-g3-control.png"),"-dpng")

% Ramp Response
fig = figure()
hold on;
lsim(Gmf2,0:Ts/2:sysinfo2.SettlingTime*1.5)
lsim(Gmf3,0:Ts/2:sysinfo2.SettlingTime*1.5)
xline(desiredSettlingTime,':')
legend("Gc","Gc*Gc2")
title("Ramp")
hold off;
print(fig, strcat(img_path,"exsim3-ramp-g3-control.png"),"-dpng")

%% Symulink Evaluation


% Run Model 1 simulation
modelFileName = 'exsim3modelPart1';
sim(modelFileName)

% Export Model as PNG
pictureFileName = strcat(img_path,modelFileName,'.png');  % Generate name from model name
print(['-s',modelFileName],'-dpng',pictureFileName);      % Generate PDF

% Run Model 2 simulation
model2FileName = 'exsim3modelPart2';
sim(model2FileName)

% Export Model as PNG
pictureFileName = strcat(img_path,model2FileName,'.png');  % Generate name from model name
print(['-s',model2FileName],'-dpng',pictureFileName);      % Generate PDF

% Run Model 2 simulation
model2FileName = 'exsim3modelPart2d';
sim(model2FileName)

% Export Model as PNG
pictureFileName = strcat(img_path,model2FileName,'.png'); % Generate name from model name
print(['-s',model2FileName],'-dpng',pictureFileName);      % Generate PDF
