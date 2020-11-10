%%

syms z

A = [0 1 0; 0 0 1; -0.16 0.84 0]
B = [1 1 1]'

F1 = sym('F_1')
F2 = sym('F_2')
F3 = sym('F_3')
F = [F1 F2 F3]

I = eye(size(A));
polySystem = flip(coeffs(det(z*I-A),z))

polyDesired = poly([0 0])

polyF = (polySystem - polyDesired)
[m,v] = equationsToMatrix(polyF,F);
nF = linsolve(m,v)
