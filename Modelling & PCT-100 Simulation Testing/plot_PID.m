clear; clc; close all;
out1 = load('PID_analitik.mat');
mmlevel1 = out1.mmlevel;
persen_bukaanValve1 = out1.persen_bukaanValve;
step_SPlevel1 = out1.step_SPlevel;
t_simulink1 = out1.t_simulink;
u_valve1 = out1.u_Vfc;
t_valve1 = linspace(0,max(t_simulink1),length(u_valve1));
lr1 = out1.lr_save;
SE1 = ((out1.error).^2);
error1 = 0.5*SE1;

out2 = load('PID_pidtune.mat');
mmlevel2 = out2.mmlevel;
persen_bukaanValve2 = out2.persen_bukaanValve;
step_SPlevel2 = out2.step_SPlevel;
t_simulink2 = out2.t_simulink;
u_valve2 = out2.u_Vfc;
t_valve2 = linspace(0,max(t_simulink2),length(u_valve2));
lr2 = out2.lr_save;
SE2 = ((out2.error).^2);
error2 = 0.5*SE2;

%%
figure;
hold on;
title("Plot Level Kondisi Berbeban Kontroller PID");
xlabel("t (detik)");
ylabel("Level (mm)");
plot(t_simulink1,mmlevel1,"DisplayName","Metode Analitik");
plot(t_simulink2,mmlevel2,"DisplayName","Metode pidtune()");
plot(t_simulink1,step_SPlevel1,"DisplayName","Set Point");
legend;
hold off;

f = figure;
f.Position = [200 200 500 200];
hold on;
title("Plot Square Error Kondisi Berbeban Kontroller PID");
xlabel("t (detik)");
ylabel("Square Error (mm^2)");
plot(t_simulink1,SE1,"DisplayName","Metode Analitik");
plot(t_simulink2,SE2,"DisplayName","Metode pidtune()");
% plot(t_simulink1,step_SPlevel1,"DisplayName","Set Point");
legend;
hold off;
% CALCULATE TOTAL COST FUNCTION: Jtotal
J_error1 = sum(error1)
J_error2 = sum(error2)

figure;
hold on;
title("Plot u_{flow valve} Kondisi Berbeban Kontroller PID");
xlabel("t (detik)");
ylabel("Tegangan Flow Valve (volt)");
plot(t_valve1,u_valve1,"DisplayName","Metode Analitik");
plot(t_valve2,u_valve2,"DisplayName","Metode pidtune()");
legend;
hold off;
