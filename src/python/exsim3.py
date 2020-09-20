"""
Laboratory Experiment 3 - Script
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

    # Find Resudues
    Gp = 0
    for p in poles:
        Gp = Gp + (G*(s-p)).subs(s,p)/(s-p)

    return Gp

printing.printer.Printer().set_global_settings(precision=3)

# Symbols
s = symbols("s",complex=True)
z = symbols("z",complex=True)
K,a1,a0,T = symbols("K alpha_1 alpha_0 T",real=True)

# Constants
na0 = 1
nT = 0.5

# Open Loop Transfer Function
sGo = 1/(s+na0)

# Z Transform (From table) 
sGz = (1-exp(-T))/(z-exp(-T))

# Controler TF
sGc = K*z/(z-1)
sGma = simplify(expand(sGc*sGz))
sGmf = simplify(expand(sGma/(1+sGma))) 

# Characterist Equation
_,poly = fraction(sGmf)

# Find Critical Value for K
sK = solve(poly,K)[0]
Kmax = sK.subs([(T,nT),(z,-1)])

poles2 = solve(poly.subs([(T,nT),(K,2)]),z)
