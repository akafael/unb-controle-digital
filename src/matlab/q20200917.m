%% EXSIM2 

% Clean Up Everything
clear
close all

% Get path from current file and generate absolute path
file_path = fileparts(mfilename('fullpath'))
img_path = strcat(file_path,"/../tex/img/")

% Define Symbols
syms s z T w

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


%% ZOH

for Ts = [0.1 0.01]
    Gz = c2d(G,Ts,'zoh') % ZOH Discretization
   
    % Find G(w) 
    [num,den] = numden(subs(sGw,T,Ts))
    Gw = tf(sym2poly(num),sym2poly(den))
    zero(Gw)
    pole(Gw)

    % Plot
    fig = figure(); % Get Figure Handler

    % Bode Plot
    hold on;
    opts = bodeoptions('cstprefs');
    opts.PhaseWrapping='on';
    bode(G,opts)
    bode(Gz,opts)
    bode(Gw)   % Bode Plot with Phase and Gain Margin

    % Add marks at (1/Ts/4) to compare divergence
    xline(fig.Children(end-1),1/Ts/4,'--'); % Phase Plot
    xline(fig.Children(end),1/Ts/4,'--'); % Mag Plot
   
    title(fig.Children(end),strcat('T=',num2str(Ts),'s'))
    legend(fig.Children(end),'G(s)','G(z)','G(w)');
    hold off;
end
