%% EXSIM6

% Start Safe n Sound by Clean Up Everything
clear
close all

% Get path from current file and generate absolute path
file_path = fileparts(mfilename('fullpath'))
img_path = strcat(file_path,"/../../tex/img/")

% Define Symbols
syms s z T

% Transfer Function SS form
A = [0 1; 0.16 -1]
B = [0 1]'
C = [1 0]
Ts = 1

G = ss(A,B,C,0,Ts)

F1 = sym('F_1')
F2 = sym('F_2')
F = [F1 F2]
L1 = sym('L_1')
L2 = sym('L_2')
L = [L1;L2]
N = sym("N")

% Find Plant Characterist Eq.
I = eye(size(A))
polyPlant = coeffs(det(z*I -(A-B*F)),z)

% Find Desired Characteristic Eq.
desiredPoles = [0.5+0.5*i, 0.5-0.5*i]
polyPlantDesired = poly(desiredPoles)

% Find F Gain
polyF = (polyPlant - polyPlantDesired)
[m,v] = equationsToMatrix(polyF(1:end-1),F);
nF = double(linsolve(m,v)')

% Run Simulation
modelFileName = 'exsim6_ss_model'
sim(modelFileName)

% Export Model as PNG
pictureFileName = strcat(img_path,modelFileName,'.png');   % Generate name from model name
print(['-s',modelFileName],'-dpng',pictureFileName);      % Generate PDF

% Plot Simulation Results
fig = figure()
hold on;
plot(simout.R)
plot(simout.Y)
legend('R[k]','Y[k]')
hold off;
print(fig, strcat(img_path,"exsim6-ss-sim.png"),"-dpng")

fig = figure()
hold on;
plot(simout.R)
plot(simout.X)
legend('R[k]','X_1[k]','X_2[k]')
hold off;
print(fig, strcat(img_path,"exsim6-ss-state-sim.png"),"-dpng")


%%

for K = [1 0.1]

    % Find Observer Characteristic Eq.
    polyObs = coeffs(det(z*I -(A-L*C)),z)
    polesObsDesired = K*[complex(0.5,-0.5),complex(0.5,0.5)];
    polyObsDesired = poly(polesObsDesired);

    % Find L Gain
    polyL = (polyObs - polyObsDesired)
    [m,v] = equationsToMatrix(polyL(1:end-1),L);
    nL = double(linsolve(m,v))

    % Closed Loop Space State Expression
    N = 1
    Amf = A - B*nF - nL*C - B*N*C
    Bmf = B*N
    Cmf = C

    % Find Outer Loop Characteristic Equation
    I = eye(size(Amf));
    polyMf = flip(coeffs(det(z*I-Amf),z))

    % Run Simulation
    modelFileName = 'exsim6_ss_observer_model'
    sim(modelFileName)

    % Export Model as PNG
    pictureFileName = strcat(img_path,modelFileName,'.png');   % Generate name from model name
    print(['-s',modelFileName],'-dpng',pictureFileName);      % Generate PDF

    % Plot Simulation Results
    fig = figure()
    hold on;
    plot(simobsout.R)
    plot(simobsout.Y)
    legend('R[k]','Y[k]')
    hold off;
    print(fig, strcat(img_path,"exsim6-ssobs",num2str(10*K),"-sim.png"),"-dpng")

    Err = simobsout.X - simobsout.Xobs
    Err.Name = 'E'

    fig = figure()
    hold on;
    plot(simobsout.R)
    plot(Err)
    legend('R[k]','E[k]')
    legend()
    hold off;
    print(fig, strcat(img_path,"exsim6-ssobs",num2str(10*K),"-err-sim.png"),"-dpng")

end

% Soundtrack: Adiós Nonino - Astor Piazzola
