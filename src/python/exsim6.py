"""
Laboratory Experiment 6 - Script
 - State Space Control
 @author Rafael Lima
"""

from sympy import *

printing.printer.Printer().set_global_settings(precision=3)

# Symbols
s = symbols("s",complex=True)
z = symbols("z",complex=True)
f1,f2 = symbols("f_1 f_2",complex=True)
l1,l2 = symbols("l_1 l_2",complex=True)

Ts = 1

# Define System
G = Matrix([[0, 1], [-0.16, -1]])
H = Matrix([0,1])
C = Matrix([[1,0]])
I = eye(2)

# Controler and Observer Gain
F = Matrix([[f1,f2]])
L = Matrix([l1,l2])

Ama = z*I - (G - H*F)
Amo = z*I - (G - L*C)

# Characterict Equation
polyPlant = det(Ama)
polyObs = det(Amo)

# Desired Characterict Equation
polyDesired = simplify((z-complex(0.5,0.5))*(z-complex(0.5,-0.5)))
polyObsDesired = simplify((z-complex(0.5,0.5))*(z-complex(0.5,-0.5)))
polyObsDesired2 = simplify((z-complex(0.05,0.05))*(z-complex(0.05,-0.05)))

# Solve Linear System for F
eq1F = Eq(polyPlant.coeff(z),polyDesired.coeff(z))
eq2F = Eq(polyPlant.coeff(z,0),polyDesired.coeff(z,0))
nF = linsolve([eq1F,eq2F],(f1,f2))
(nf1,nf2) = tuple(*nF)

# Solve Linear System for L
eq1L = Eq(polyObs.coeff(z),polyObsDesired.coeff(z))
eq2L = Eq(polyObs.coeff(z,0),polyObsDesired.coeff(z,0))
nL = linsolve([eq1L,eq2L],(l1,l2))
(nl1,nl2) = tuple(*nL)

# Solve Linear System for L2
eq1L2 = Eq(polyObs.coeff(z),polyObsDesired2.coeff(z))
eq2L2 = Eq(polyObs.coeff(z,0),polyObsDesired2.coeff(z,0))
nL2 = linsolve([eq1L2,eq2L2],(l1,l2))
(nl21,nl22) = tuple(*nL2)

