%% EXSIM1 - Digital Control Experiment
% @author Rafael Lima

pkg load control % Required for octave

%% Discrete Transfer Function definition
Ts = 1
Gnum = [0.3679 0.2642]
Gden = conv([1 -1],[1 -0.3679])
G = tf(Gnum,Gden,Ts)

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

%% Graphical Evaluation
%rlocus(G)
%zgrid

