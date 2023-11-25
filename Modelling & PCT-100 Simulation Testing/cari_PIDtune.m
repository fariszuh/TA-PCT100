clc; 
%% METODE ANALITIK0.01028
Glevel_analitik = tf([39.2975],[1 0.01028]);
Gfcvalve_analitik = tf([0.1619],[0.0034 1]);
Gscaling = 1/6000; % lt/min to m3/s
Gplant_analitik = Gfcvalve_analitik*Glevel_analitik*Gscaling
Gplant_analitik_2ndform = tf([0.0103],[0.3307 97.2797 1]);

[num, denum] = tfdata(Gplant_analitik_2ndform);
% ubah ke dalam bentuk K/(as^2 + bs + c)
num = cell2mat(num);
K = num(end);
denum = cell2mat(denum);
a = denum(1);
b = denum(2);
c = denum(3);

wn = sqrt(1/a);
zeta = b*wn/2;
tau_star = 97.4;
ti = 2*zeta/wn;
td = 1/(2*zeta*wn);

Kp = 2*zeta/(tau_star*wn*K);
Ki = Kp/ti;
Kd = Kp*td;

%% METODE pidtuner()
Glevel_tuner = tf([39.2975],[1 0.01028]);
Gfcvalve_tuner = tf([0.1619],[0.0034 1]);
Gplant_tuner = Gfcvalve_tuner*Glevel_tuner*Gscaling

C = pidtune(Gplant_tuner,'PID')

% sys = zpk([],[-1 -1 -1],1)
% [C_pi,info] = pidtune(sys,'PID')
% 
% pidTuner(Gplant,'PID')

%% compensator
% u = 0.9679*18/2.9134
u = 9.964*10^-5; %(100*0.0571 - 2.4079);
syms s;
s = tf('s');
Glevel_analitik = tf([39.2975],[1 0.01028]); % [3822.7],[97.2763 1]
Gfcvalve_analitik = tf([0.1619],[0.0034 1]);
Gscaling = 1/6000; % lt/min to m3/s
GLT = 0.00182; % 0.0571/s^2 - 2.7096/s; %0.00182;
Gplant = 1000*Gfcvalve_analitik*Gscaling*Glevel_analitik;
% y = 
% V = 0.0571 h - 2.4076;
fe = feedback(Gplant,1);

r_tangki = 0.08; % dalam meter
A = pi*r_tangki^2;
C=A;
h_ss = 0.0617; % dalam meter
Q_in_ss = 0.9679/60000; % dalam m3/s
R = h_ss/Q_in_ss
Glevel_ogata = R/(R*C*s + 1)
Gplant_ogata = 1000*Gfcvalve_analitik*Gscaling*Glevel_ogata;
[y_lin,t_lin] = step(Gplant_ogata*u,1400);
[y_nonl,t_nonl] = step(1000*Gplant_analitik*u,1400);
figure;
hold on;
title("Openloop Level");
xlabel("t (detik)");
ylabel("Level (mm)")
plot(t_lin,y_lin,'DisplayName',"Model Linear");
plot(t_nonl,y_nonl,'DisplayName',"Model Nonlinear");
plot(t_simulink,mmlevel,'DisplayName',"Model Simulink");
% plot(t_lin,100*ones(length(t_lin),1),'DisplayName',"SetPoint");
legend;
hold off;
