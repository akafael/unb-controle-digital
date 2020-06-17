"""
Laboratory Experiment 1 - Script
@author Rafael Lima
"""


import sympy
import control

# Symbols
z = sympy.symbols("z",complex=True)
K,a1,a0,b1 = sympy.symbols("K alpha_1 alpha_0 beta_1",real=True)

# Constants
na1 = 0.3679
na0 = 0.2642
nb1 = 1

# Open Loop Transfer Function
sGo = K*(a1*z + a0)/((z-b1)*(z-a1)) 
nGo = sGo.subs([(a1,na1),(a0,na0),(b1,nb1)])

# Closed Loop Transfer Function
sGc = (sGo/(1-sGo)).simplify()
nGc = sGc.subs([(a1,na1),(a0,na0),(b1,nb1)])

# Polynomy
_,poly = sympy.fraction(sGc)
npoly = poly.subs([(a1,na1),(a0,na0),(b1,nb1)])

# Jury eq1
eqJ1 = poly.subs(z,1)
K1 = sympy.solve(eqJ1,K)[0]
nK1 = K1.subs([(a1,na1),(a0,na0),(b1,nb1)])

# Jury eq2
eqJ2 = poly.subs(z,-1)
K2 = sympy.solve(eqJ2,K)[0]
nK2 = K2.subs([(a1,na1),(a0,na0),(b1,nb1)])

# Jury eq3
apoly = sympy.Poly(poly.expand(), z).all_coeffs()
K3 = sympy.solve(apoly[0]-apoly[-1],K)[0]
nK3 = K3.subs([(a1,na1),(a0,na0),(b1,nb1)])
