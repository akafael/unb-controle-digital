%% EXSIM 5 - Professor Script

% Start Safe n Sound by Clean Up Everything
clear
close all

% Get path from current file and generate absolute path
file_path = fileparts(mfilename('fullpath'))
img_path = strcat(file_path,"/../../tex/img/")

global alpha u1 y1

% Transfer Function Parameters - Required by Simulink Model
J = 1;
kp = 1;
w0 = 1;
a = 2*w0;
b = w0/2;
kc = 2*J*w0^2/kp;
T = 1.4/w0;
alpha = (kp*T^2)/(2*J);
u1 = 0;
y1 = 0;

% Transfer Function Parameters - Required by Simulink Model
r1 = 0.75;
s0 = 1.25/alpha;
s1 = -0.75/alpha;
t0 = 1/(2*alpha);

% Simulation Parameters - Required by Simulink Model
tf = 20; % Stop Time

% Run Simulation
modelFileName = 'exsim5model'
sim(modelFileName)

% Export Model as PNG
pictureFileName = strcat(img_path,modelFileName,'.png');   % Generate name from model name
print(['-s',modelFileName],'-dpng',pictureFileName);      % Generate PDF

%% Simulation Graphical Evaluation
fig = figure()

subplot(211);
plot(y(:,1),y(:,2),yd(:,1),yd(:,2));
title('T = 1.4/\omega_0');
%xlabel('\omega_0t')
ylabel('y');
xticks(0:T:tf)
grid;
legend('continuo','exsim5');

%subplot(312);
%plot(yp(:,1),yp(:,2),yp1(:,1),yp1(:,2));
%xlabel('\omega_0t');
%xticks(0:T:20)
%ylabel('dy/dt');
%grid;

subplot(212);
stairs(ud(:,1),ud(:,2),'r');
hold on;
plot(u(:,1),u(:,2));
xlabel('\omega_0t');
ylabel('u');
xticks(0:T:tf)
grid;

hold off;
print(fig, strcat(img_path,"exsim5-deadbeat-sim.png"),"-dpng")

