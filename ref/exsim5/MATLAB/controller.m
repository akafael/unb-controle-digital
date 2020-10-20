function u = controller(v)
global newx alpha T

a = 7/(4*T);
b = 2/(5*T);
kc = 5/(4*alpha);

x = newx;
uc = v(1);
y = v(2);
u = kc*(b/a*uc-y+x);
newx = x+T*((a-b)*y-a*x);