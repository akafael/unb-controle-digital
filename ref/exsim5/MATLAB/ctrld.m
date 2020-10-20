function u = ctrld(v)
global alpha y1 u1

r1 = 0.75;
s0 = 1.25/alpha;
s1 = -0.75/alpha;
t0 = 1/(2*alpha);

uc = v(1);
y = v(2);
u = t0*uc-s0*y-s1*y1-r1*u1;
y1 = y;
u1 = u;