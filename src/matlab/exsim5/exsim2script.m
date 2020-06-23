clear
close all

global newx alpha T u1 y1

J = 1;
kp = 1;
w0 = 1;
a = 2*w0;
b = w0/2;
kc = 2*J*w0^2/kp;
T = 1.4/w0;
alpha = (kp*T^2)/(2*J);
u1 = 0;
y1 = 0;

r1 = 0.75;
s0 = 1.25/alpha;
s1 = -0.75/alpha;
t0 = 1/(2*alpha);

syscl = tf([w0^2/2 w0^3],[1 2*w0 2*w0^2 w0^3]);

a1 = 7/(4*T);
b1 = 2/(5*T);
kc1 = 5/(4*alpha);

newx = 0;
tf = 20;
sim('exsim2model')
figure
subplot(211)
plot(y(:,1),y(:,2),y(:,1),y(:,3))
title('T = 1.4/\omega_0')
xlabel('t(s)')
ylabel('y')
grid
legend('continuo','deadbeat')
subplot(212)
stairs(u(:,1),u(:,3),'r')
hold on
plot(u(:,1),u(:,2))
xlabel('t(s)')
ylabel('u')
grid