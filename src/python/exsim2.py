"""
Laboratory Experiment 2 - Script
 - Discretization
 @author Rafael Lima
"""

import sympy
import numpy

class tf:
    sym = 1
    num = 1


def simplifyFraction(G,s):
    """
    Expand numerator and denominator from given fraction
    """
    num,den = sympy.fraction(G.expand().simplify())
    num = sympy.Poly(num,s)
    den = sympy.Poly(den,s)
    
    return (num/den)


def partialFraction(G,s):
    """
    Split Fraction into several factors using residues theorem
    """
    # Find Poles
    poles = sympy.solve(sympy.fraction(G.expand().simplify())[1],s)

    # Find Resudues
    Gp = 0
    for p in poles:
        Gp = Gp + (G*(s-p)).subs(s,p)/(s-p)

    return Gp

sympy.printing.printer.Printer().set_global_settings(precision=3)

# Symbols
s = sympy.symbols("s",complex=True)
z = sympy.symbols("z",complex=True)
K,a1,a0,T = sympy.symbols("K alpha_1 alpha_0 T",real=True)

# Constants
na0 = 2
na1 = 3
nT = 0.1

# Open Loop Transfer Function
sGo = 1/((s+na1)*(s+na0))

# Z Transform (From table)
zGo = z/(3*(z-sympy.exp(-3*T))) - z/(2*(z-sympy.exp(-2*T))) + z/(6*((z-1)))

# Forward Rectangle
Gzf = (z -1)/T
Gof = sGo.subs(s,Gzf)

# Backward Rectangle
Gzb = (z-1)/(T*z)
Gob = sGo.subs(s,Gzb)

# Trapezoid
Gzd = 2*(z-1)/(T*(z+1))
God = sGo.subs(s,Gzd)

# Matched Poles
Gom = 1/((z+sympy.exp(na0*nT))*(z+sympy.exp(na1*nT)))

# Question 2
a,b,kp,kc,J,w0 = sympy.symbols("a b k_P k_C J omega_0")

G2 = kp/(J*s*s)
H2 = kc*(s+b)/(s+a)
G1 = b*kc/a

G2mf = G1*(G2/(1+G2*H2))
Gsmfd = 
