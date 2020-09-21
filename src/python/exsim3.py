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

def roundExpr(expr, num_digits=4):
    """
    Round Every Number in an expression
    """
    return expr.xreplace({n : round(n, num_digits) for n in expr.atoms(Number)})


printing.printer.Printer().set_global_settings(precision=3)

# Symbols
s = symbols("s",complex=True)
z = symbols("z",complex=True)
K,a1,a0,T,b = symbols("K alpha_1 alpha_0 T beta",real=True)

# Constants
na0 = 1
nT = 0.5

# Open Loop Transfer Function
sGo = 1/(s+na0)

# Z Transform (From table) 
sGz = (1/na0)*(1-exp(-T))/(z-exp(-T))

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


# Part 2
# Constants
na1 = 2
Ts = 0.2

# Open Loop Transfer Function
sGo2 = 1/(s+2)

# Z Transform (From table) 
sGz2 = (z-1)*(1/(4*(z-exp(-2*T))) - 1/(4*(z-1)) + T*(1/((z-1)*(z-1))))

# Controler TF
sGc2 = K*(z-exp(-na1*T))/(z-b)
sGma2 = simplifyFraction(sGc2*sGz2,z)
sGmf2 = simplify(expand(sGma2/(1+sGma2))) 

# Characterist Equation
_,poly2 = fraction(sGmf2)

# Request Conditions
desiredDamping = 0.5
desiredSettlingTime = 2
desiredOvershoot = exp(-desiredDamping*pi/sqrt(1-desiredDamping**2))
desiredPoles = [0,0]
desiredPoles[0] = -(4/desiredSettlingTime)*(1 + I*sqrt(1-desiredDamping**2)/desiredDamping)
desiredPoles[1] = -(4/desiredSettlingTime)*(1 - I*sqrt(1-desiredDamping**2)/desiredDamping)
desiredPolesZ = [exp(desiredPoles[0]*Ts),exp(desiredPoles[1]*Ts)]

# Solve Linear System to find K and b
sysKb = [K,b]
sysKb[0] = poly2.subs([(z,desiredPolesZ[0]),(T,Ts)]).evalf().collect(K).collect(b)
sysKb[1] = poly2.subs([(z,desiredPolesZ[1]),(T,Ts)]).evalf().collect(K).collect(b)
resp = list(linsolve(sysKb,(K,b)))[0]
nK = resp[0]
nb = resp[1]

# Find TF
nGmf2 = sGmf2.subs([(K,nK),(b,nb),(T,Ts)])

# Find Critical Value for K
sK2 = solve(poly2,K)[0]
#Kmax = sK.subs([(T,nT),(z,-1)])


