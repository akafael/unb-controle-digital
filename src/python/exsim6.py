"""
Laboratory Experiment 6 - Script
 - State Space Control
 @author Rafael Lima
"""

from sympy import *

def simplifyFraction( G, z = symbols("z",complex=True) ):
    """
    Expand numerator and denominator from given fraction
    """
    num,den = fraction(G.expand().simplify())
    num = Poly(num,z)
    den = Poly(den,z)
    
    return (num/den)


def partfrac( G, z = symbols("z",complex=True) ):
    """
    Split Fraction into several factors using residues theorem
    """
    # Find Poles
    poles = solve(sympy.fraction(G.expand().simplify())[1],s)

    # Find Residues
    Gp = 0
    for p in poles:
        Gp = Gp + (G*(z-p)).subs(z,p)/(z-p)

    return Gp

def roundExpr( expr, num_digits=4 ):
    """
    Round Every Number in an expression
    """
    return expr.xreplace({n : round(n, num_digits) for n in expr.atoms(Number)})


def simboliczpk( zeros, poles, gain, z = symbols("z",complex=True) ):
    """
    Generate Transfer Function in from the zeros, poles
    """
    Gzeros = prod([z-a for a in zeros])
    Gpoles = prod([z-a for a in poles])
    G = (gain*Gzeros)/(Gpoles)

    return G


def canonicalFraction( expr, z = symbols("z",complex=True) ):
    """
    Rewrite Fraction in the zpk form
    """
    num,den = fraction( expr )
    num = prod([z-a for a in solve(num,z)])
    den = prod([z-a for a in solve(den,z)])
    gain = (expr*(den/num)).subs(z,0)

    return gain*(num/den)


printing.printer.Printer().set_global_settings(precision=3)

# Symbols
s = symbols("s",complex=True)
z = symbols("z",complex=True)

Ts = 1

