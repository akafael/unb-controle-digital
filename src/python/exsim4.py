"""
Laboratory Experiment 4 - Script
 - Rootlocus project
 @author Rafael Lima
"""

from sympy import *

def simplifyFraction(G,s):
    """
    Expand numerator and denominator from given fraction
    """
    num,den = fraction(G.expand().simplify())
    num = Poly(num,s)
    den = Poly(den,s)
    
    return (num/den)


def partfrac(G,s):
    """
    Split Fraction into several factors using residues theorem
    """
    # Find Poles
    poles = solve(sympy.fraction(G.expand().simplify())[1],s)

    # Find Residues
    Gp = 0
    for p in poles:
        Gp = Gp + (G*(s-p)).subs(s,p)/(s-p)

    return Gp

def roundExpr(expr, num_digits=4):
    """
    Round Every Number in an expression
    """
    return expr.xreplace({n : round(n, num_digits) for n in expr.atoms(Number)})


printing.printer.Printer().set_global_settings(precision=3)

# Symbols
s = symbols("s",complex=True)
z = symbols("z",complex=True)
w = symbols("w",complex=True)
K,a1,a0,T,b = symbols("K alpha_1 alpha_0 T beta",real=True)

nT = 0.2

# Transfer Function
sG = (K/(s*(s+1)))

# Z Transform from Table
sGz = K*(1-z**(-1))*(T*z/((z-1)**2) - z/(z-1) + z/((z-exp(-1*T))))

# Find W Transform
zw = (2+T*w)/(2-T*w)
sGw = sGz.combsimp().subs(z,zw)

nGw = roundExpr(sGw.combsimp().subs(T,nT))

# Find Kv
exprLimEv = simplify(w*nGw)
Ev = exprLimEv.subs(w,0)

nK = solve(Eq(1/Ev,2),K)[0]

