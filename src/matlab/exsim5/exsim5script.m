clear
close all

global alpha u1 y1

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

tf = 10;
sim('exsim5model')
figure
subplot(311)
plot(y(:,1),y(:,2),yd(:,1),yd(:,2))
title('T = 1.4/\omega_0')
%xlabel('\omega_0t')
ylabel('y')
grid
legend('continuo','deadbeat')
subplot(312)
plot(yp(:,1),yp(:,2),yp1(:,1),yp1(:,2))
%xlabel('\omega_0t')
ylabel('dy/dt')
grid
subplot(313)
stairs(ud(:,1),ud(:,2),'r')
hold on
plot(u(:,1),u(:,2))
hold off
xlabel('\omega_0t')
ylabel('u')
grid