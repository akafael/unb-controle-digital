"""
Laboratory Experiment 5 - Script
 - Deadbeat Control Project
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

# Transfer Function
K1 = 0.0125
G1zeros = [-0.195,-2.821]
G1poles = [0,1,0.368,0.8187]
sG1 = simboliczpk(G1zeros,G1poles,K1)

# Transfer Function
K2 = 0.0003916
G2zeros = [-2.8276,-0.19]
G2poles = [1,1,0.2865]
sG2 = simboliczpk(G2zeros,G2poles,K2)

# Ripple Free Deadbeat Controler
bz,az = fraction(sG1)
n = len(G1poles)
sM1 = (bz/(bz.subs(z,1)))*(1/(z**n))
sD1 = (1/sG1)*(sM1/(1-sM1))

# Deadbeat Controler
bz,az = fraction(sG2)
n = len(G1poles) - len(G1zeros)
sM2 = ((n+1)*z-n)/(z**(n+1))
sD2 = (1/sG2)*(sM2/(1-sM2))

# Question 3
a,b,kp,kc,J,w0,T = symbols("a b k_P k_C J omega_0 T")

G22 = kp/(J*s*s)
H22 = kc*(s+b)/(s+a)
G21 = b*kc/a

G22mf = G21*(G22/(1+G22*H22))

Gz22 = (1-z**(-1))*((kp*(T**2))/(2*J))*(z*(z+1)/((z-1)**3))
sGz22 = ((T**2)*kp/(2*J))*(z+1)/((z-1)**2)

