"""
Laboratory Experiment 1 - Script
 - Jury Stability Criteria
@author Rafael Lima
"""

import sympy
import numpy

def simplifyFraction(fraction,s):
    """
    Simplify Fraction
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
sGo = 1/((s+a1)*(s+a0))
nGo = 1/((s+na1)*(s+na0))

# Forward Rectangle
Gzf = (z -1)/T
Gof = sGo.subs(s,Gzf)

# Backward Rectangle
Gzb = (z-1)/(T*z)
Gob = sGo.subs(s,Gzb)

# Trapezoid
Gzd = 2*(z-1)/(T*(z+1))
God = sGo.subs(s,Gzd)
