clear
clc

Vpump = 10; % Vmax pump
g = 10; % m/s2
r_pipa = 0.5; % cm
A_pipa = pi*r_pipa^2;
r_tabung = 9; % cm
A_tabung = pi*r_tabung^2;

syms h(t) vin
ode = (diff(h,t))^2 + 2*g*h == (vin - A_tabung*diff(h,t)/A_pipa)^2
ode2 = -104975*(diff(h,t))^2 + 648*vin*diff(h,t) + 20*h == vin^2
dsolve(ode2)

ode_no_vturun = vin - sqrt(2*g*h(t)) == A_tabung/A_pipa * diff(h,t)

% A = [-1.5,-2;1,0];
% B = [0.5;0];
% C = [0,1];
% D = 0;
% Ts = 0.25;
% sys = ss(A,B,C,D,Ts)