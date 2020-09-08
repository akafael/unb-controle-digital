%% EXSIM1 - Digital Control Experiment
% @author Rafael Lima



function exsim()
    Gc = exsim1_oscilation()
    Gc = exsim1_instable()
    Gc = exsim1_stable()
end

function Gc = exsim1_closedloop(K)
%% Discrete Transfer Function definition

    if nargin < 1
        K = 1
    end

    Ts = 1
    a1 = 0.3679
    a0 = 0.2642
    b1 = 1
    Gnum = [a1 a0]*K
    Gden = conv([1 -b1],[1 -a1])
    G = tf(Gnum,Gden,Ts)
    Gc = feedback(G)
end

function Gc = exsim1_oscilation()
    %% Oscilation
    Ts = 1
    a1 = 0.3679
    a0 = 0.2642
    b1 = 1
    K = (1 - a1*b1)/a0 % Expression from Juri Stability Criteria Result
    Gnum = [a1 a0]*K
    Gden = conv([1 -b1],[1 -a1])
    G = tf(Gnum,Gden,Ts)
    Gc = feedback(G)

    % Plot Figure
    fig = figure();
    step(Gc);
    grid off;
    title(["K = ", num2str(K)])
    
    % Get path from current file
    file_path = fileparts(mfilename('fullpath'))
    print(fig, [file_path,"/../tex/img/exsim1-plot-oscilation.png"],"-dpng")
end

function fig = plot_step(Gc)
%% PLOT_STEP Plot Step response for a given TF
    fig = figure();
    step(Gc);
    grid off;
    title(["K = ", num2str(K)])
end

function Gc = exsim1_instable()
    %% Instable
    Ts = 1
    a1 = 0.3679
    a0 = 0.2642
    b1 = 1
    K = 2*(1 - a1*b1)/a0
    Gnum = [a1 a0]*K
    Gden = conv([1 -b1],[1 -a1])
    G = tf(Gnum,Gden,Ts)
    Gc = feedback(G)

    % Plot Figure
    fig = figure();
    step(Gc);
    grid off;
    title(["K = ", num2str(K)])

    % Get path from current file
    file_path = fileparts(mfilename('fullpath'))
    print(fig, [file_path,"/../tex/img/exsim1-plot-instable.png"],"-dpng")
end

function Gc = exsim1_stable()
    %% Stable
    Ts = 1
    a1 = 0.3679
    a0 = 0.2642
    b1 = 1
    K = 0.5*(1 - a1*b1)/a0
    Gnum = [a1 a0]*K
    Gden = conv([1 -b1],[1 -a1])
    G = tf(Gnum,Gden,Ts)
    Gc = feedback(G)

    % Plot Figure
    fig = figure();
    step(Gc);
    grid off;
    title(["K = ", num2str(K)])

    % Get path from current file
    file_path = fileparts(mfilename('fullpath'))
    print(fig, [file_path,"/../tex/img/exsim1-plot-stable.png"],"-dpng")
end

%% Symbolic Representation
%syms z
%sGnum = poly2sym(Gnum,z)
%sGden = poly2sym(Gden,z)
%sG = sGnum/sGden

%% Juri Stability Method

% Check if $Q(1) > 0$
%syms K
%sQ = sGden+K*sGnum
%R1 = subs(sQ,z,1)

% Check if $((-1)^n)*Q(-1) > 0$
%n = size(Gden,2)
%R2 = ((-1)^(n-1))*subs(sQ,z,-1)

% Check if 
%R3 = Gden(1) < Gden(n)

%n = size(Gden,2)
%k = 1
%a = Gden
%mb = [[a(1) a(n-k)];[a(n) a(k)]]

