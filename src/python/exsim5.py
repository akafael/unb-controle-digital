"""
Laboratory Experiment 5 - Script
 - Deadbeat Control Project
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


def simboliczpk( zeros, poles, gain, s = symbols("s",complex=True) ):
    """
    Generate Transfer Function in from the zeros, poles
    """
    Gzeros = prod([s-a for a in zeros])
    Gpoles = prod([s-a for a in poles])
    G = (gain*Gzeros)/(Gpoles)

    return G


printing.printer.Printer().set_global_settings(precision=3)

# Symbols
s = symbols("s",complex=True)
z = symbols("z",complex=True)
w = symbols("w",complex=True)
K,a1,a0,T,b = symbols("K alpha_1 alpha_0 T beta",real=True)

nT = 0.2

# Transfer Function
K1 = 0.0125
G1zeros = [-0.195,-2.821]
G1poles = [0,1,0.368,0.8187]
sG1 = simboliczpk(G1zeros,G1poles,K1,z)

# Transfer Function
K2 = 0.0003916
G2zeros = [-2.8276,-0.19]
G2poles = [1,1,0.2865]
sG2 = simboliczpk(G2zeros,G2poles,K2,z)
 
