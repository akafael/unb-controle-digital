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

% Find Characterist Eq.
I = eye(size(A))
polyPlant = coeffs(det(z*I -(A-B*F)),z)

desiredPoles = [0.5+0.5*i, 0.5-0.5*i]
polyPlantDesired = poly(desiredPoles)

polyF = (polyPlant - polyPlantDesired)
[m,v] = equationsToMatrix(polyF(1:end-1),F);
nF = double(linsolve(m,v)')

polyObs = coeffs(det(z*I -(A-L*C)),z)
polyObsDesired = poly(10*desiredPoles)

polyL = (polyObs - polyObsDesired)
[m,v] = equationsToMatrix(polyL(1:end-1),L);
nL = double(linsolve(m,v))

% Run Simulation
modelFileName = 'exsim6_ss_model'
sim(modelFileName)

% Export Model as PNG
pictureFileName = strcat(img_path,modelFileName,'.png');   % Generate name from model name
print(['-s',modelFileName],'-dpng',pictureFileName);      % Generate PDF

% Run Simulation
modelFileName = 'exsim6_ss_observer_model'
sim(modelFileName)

% Export Model as PNG
pictureFileName = strcat(img_path,modelFileName,'.png');   % Generate name from model name
print(['-s',modelFileName],'-dpng',pictureFileName);      % Generate PDF

% Soundtrack: Adiós Nonino - Astor Piazzola
