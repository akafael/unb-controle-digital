"""
Laboratory Experiment 1 - Script
 - Jury Stability Criteria
@author Rafael Lima
"""

import sympy
import numpy

class tf:
    sym = 1
    num = 1


def simplifyFraction(fraction,s):
    """
    Expand numerator and denominator from given fraction
    """
    num,den = sympy.fraction(fraction.expand().simplify())
    num = sympy.Poly(num,s)
    den = sympy.Poly(den,s)
    
    return (num/den)


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
zGo = z*(sympy.exp(-a0*T)-sympy.exp(-a1*T))/((a1-a0)*(z-sympy.exp(-a0*T))*(z-sympy.exp(-a1*T)))
nzGo = zGo.subs([(a0,na0),(a1,na1)])

# Forward Rectangle
Gzf = (z -1)/T
Gof = sGo.subs(s,Gzf)

# Backward Rectangle
Gzb = (z-1)/(T*z)
Gob = sGo.subs(s,Gzb)

# Trapezoid
Gzd = 2*(z-1)/(T*(z+1))
God = sGo.subs(s,Gzd)
