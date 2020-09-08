"""
Laboratory Experiment 1 - Script
 - Jury Stability Criteria
@author Rafael Lima
"""

import sympy
import numpy

sympy.printing.printer.Printer().set_global_settings(precision=3)

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
sGc = (sGo/(sGo + 1)).simplify()
nGc = sGc.subs([(a1,na1),(a0,na0),(b1,nb1)])

# Polynomy
_,poly = sympy.fraction(sGc)
poly = poly.expand().factor(z)
npoly = poly.subs([(a1,na1),(a0,na0),(b1,nb1)])
poles = sympy.solve(npoly,z) 

# Jury Stability Criteria eq1
eqJ1 = poly.subs(z,1)
neqJ1 = npoly.subs(z,1)
K1 = sympy.solve(eqJ1,K)[0]
sK1 = K1.subs([(a1, sympy.UnevaluatedExpr(na1)),\
               (a0, sympy.UnevaluatedExpr(na0)),\
               (b1, sympy.UnevaluatedExpr(nb1))],\
               order='none').combsimp()
nK1 = sK1.doit()

# Jury Stability Criteria eq2
eqJ2 = poly.subs(z,-1)
K2 = sympy.solve(eqJ2,K)[0]
sK2 = K2.subs([(a1, sympy.UnevaluatedExpr(na1)),\
               (a0, sympy.UnevaluatedExpr(na0)),\
               (b1, sympy.UnevaluatedExpr(nb1))],\
               order='none').combsimp()
nK2 = sK2.doit()

# Jury Stability Criteria eq3
apoly = sympy.Poly(poly.expand(), z).all_coeffs()
napoly = sympy.Poly(npoly.expand(), z).all_coeffs()
K3 = sympy.solve(apoly[2]-apoly[0],K)[0]
sK3 = K3.subs([(a1, sympy.UnevaluatedExpr(na1)),\
               (a0, sympy.UnevaluatedExpr(na0)),\
               (b1, sympy.UnevaluatedExpr(nb1))],\
               order='none').evalf()
nK3 = sK3.doit()

# Modified Roth Criteria
w = sympy.symbols("w",complex=True)
bilinearTransf = (w+1)/(w-1)
sGw = sGc.subs(z,bilinearTransf)

# Simplification
num,den = sympy.fraction(sGw.expand().simplify())
num = sympy.Poly(num,w)
den = sympy.Poly(den,w)
sGww = num/den
nGww = sGww.subs([(a1,na1),(a0,na0),(b1,nb1)])

polyw = den.expr
npolyw = polyw.subs([(a1,na1),(a0,na0),(b1,nb1)])

# TODO Generate Roth table

sK4 = npolyw.subs(w,0)
nK4 = sympy.solve(sK4,K)[0]

# Oscilation
sGs = sGc.subs(K,K3)
nGs = nGc.subs(K,nK3)
_,den = sympy.fraction(nGs.expand().simplify())
opoles = sympy.solve(den,z)
freq = 2*numpy.pi/sympy.arg(opoles[1])

