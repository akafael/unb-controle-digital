"""
Laboratory Experiment 1 - Script
@author Rafael Lima
"""


import sympy


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

# Jury Stability Criteria eq1
eqJ1 = poly.subs(z,1)
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
K3 = sympy.solve(apoly[0]-apoly[-1],K)[0]
sK3 = K3.subs([(a1, sympy.UnevaluatedExpr(na1)),\
               (a0, sympy.UnevaluatedExpr(na0)),\
               (b1, sympy.UnevaluatedExpr(nb1))],\
               order='none').evalf()
nK3 = sK3.doit()

# Modified Roth Criteria
w = sympy.symbols("w",complex=True)
bilinearTransf = (w+1)/(w-1)
sGw = sGo.subs(z,bilinearTransf)

# Simplification
num,den = sympy.fraction(sGw.expand().simplify())
num = sympy.Poly(num,w)
den = sympy.Poly(den,w)
sGww = num/den
nGww = Gww.subs([(a1,na1),(a0,na0),(b1,nb1)])

polyw = den.expr
npolyw = polyw.subs([(a1,na1),(a0,na0),(b1,nb1)])
