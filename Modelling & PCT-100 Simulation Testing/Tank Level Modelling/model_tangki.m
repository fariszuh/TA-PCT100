clear; clc

syms h(t);
d_pipa = 1; % cm2
A_pipa = 0.25*pi*d_pipa^2;
d_tabung = 9; % cm2
A_tabung = 0.25*pi*d_tabung^2;
g = 10; % m/s2

% feedback from sensor
u_pompa = 10;
k_pompa = 3.2/10; % 0-10V to 3.2 lt/min
Qin = k_pompa * u_pompa * t^0;
Qout = A_pipa*sqrt(2*g*h(t));
ode = Qin - Qout == A_tabung*diff(h,t,1);

% solve ODE
cond = h(0) == 0;
ySol = dsolve(ode,cond)

pretty(ySol)
% h(t) = ((Qout/Apipa)^2 )/(2*g);
