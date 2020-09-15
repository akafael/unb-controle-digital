"""
Laboratory Experiment 2 - Script
 - Discretization
 @author Rafael Lima
"""

import sympy
import numpy

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
