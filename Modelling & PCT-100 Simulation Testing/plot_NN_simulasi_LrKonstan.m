clear; clc; close all;
out1 = load('SP=100_MOV=dynamic_lrinit=0.001_alpha=0.mat');
mmlevel1 = out1.mmlevel;
persen_bukaanValve1 = out1.persen_bukaanValve;
step_SPlevel1 = out1.step_SPlevel;
t_simulink1 = out1.t_simulink;
u_valve1 = out1.u_Vfc;
t_valve1 = linspace(0,max(t_simulink1),length(u_valve1));
lr1 = out1.lr_save;
SE1 = ((out1.error).^2);
error1 = sum(SE1)/length(SE1);

out2 = load('SP=100_MOV=dynamic_lrinit=0.01_alpha=0.mat');
mmlevel2 = out2.mmlevel;
persen_bukaanValve2 = out2.persen_bukaanValve;
step_SPlevel2 = out2.step_SPlevel;
t_simulink2 = out2.t_simulink;
u_valve2 = out2.u_Vfc;
t_valve2 = linspace(0,max(t_simulink2),length(u_valve2));
lr2 = out2.lr_save;
SE2 = ((out2.error).^2);
error2 = sum(SE2)/length(SE2);

out3 = load('SP=100_MOV=dynamic_lrinit=0.1_alpha=0.mat');
mmlevel3 = out3.mmlevel;
persen_bukaanValve3 = out3.persen_bukaanValve;
step_SPlevel3 = out3.step_SPlevel;
t_simulink3 = out3.t_simulink;
u_valve3 = out3.u_Vfc;
t_valve3 = linspace(0,max(t_simulink3),length(u_valve3));
lr3 = out3.lr_save;
SE3 = ((out3.error).^2);
error3 = sum(SE3)/length(SE3);

out4 = load('SP=100_MOV=dynamic_lrinit=1_alpha=0.mat');
mmlevel4 = out4.mmlevel;
persen_bukaanValve4 = out4.persen_bukaanValve;
step_SPlevel4 = out4.step_SPlevel;
t_simulink4 = out4.t_simulink;
u_valve4 = out4.u_Vfc;
t_valve4 = linspace(0,max(t_simulink4),length(u_valve4));
lr4 = out4.lr_save;
SE4 = ((out4.error) .^2);
error4 = sum(SE4)/length(SE4);

out5 = load('SP=100_MOV=dynamic_lrinit=2_alpha=0.mat');
mmlevel5 = out5.mmlevel;
persen_bukaanValve5 = out5.persen_bukaanValve;
step_SPlevel5 = out5.step_SPlevel;
t_simulink5 = out5.t_simulink;
u_valve5 = out5.u_Vfc;
t_valve5 = linspace(0,max(t_simulink5),length(u_valve5));
lr5 = out5.lr_save;
SE5 = ((out5.error).^2);
error5 = sum(SE5)/length(SE5);

out6 = load('SP=100_MOV=dynamic_lrinit=5_alpha=0.mat');
mmlevel6 = out6.mmlevel;
persen_bukaanValve6 = out6.persen_bukaanValve;
step_SPlevel6 = out6.step_SPlevel;
t_simulink6 = out6.t_simulink;
u_valve6 = out6.u_Vfc;
t_valve6 = linspace(0,max(t_simulink6),length(u_valve6));
lr6 = out6.lr_save;
SE6 = ((out6.error).^2);
error6 = sum(SE6)/length(SE6);

out7 = load('SP=100_MOV=dynamic_lrinit=10_alpha=0.mat');
mmlevel7 = out7.mmlevel;
persen_bukaanValve7 = out7.persen_bukaanValve;
step_SPlevel7 = out7.step_SPlevel;
t_simulink7 = out7.t_simulink;
u_valve7 = out7.u_Vfc;
t_valve7 = linspace(0,max(t_simulink7),length(u_valve7));
lr7 = out7.lr_save;
SE7 = ((out7.error).^2);
error7 = sum(SE7)/length(SE7);

%%
figure;
hold on;
title("Plot Level Kondisi Berbeban, Variasi Learning Rate Konstan");
xlabel("t (detik)");
ylabel("Level (mm)");
plot(t_simulink1,mmlevel1,"DisplayName","Level lr=0.001");
plot(t_simulink2,mmlevel2,"DisplayName","Level lr=0.01");
plot(t_simulink3,mmlevel3,"DisplayName","Level lr=0.1");
plot(t_simulink4,mmlevel4,"DisplayName","Level lr=1");
plot(t_simulink5,mmlevel5,"DisplayName","Level lr=2");
plot(t_simulink6,mmlevel6,"DisplayName","Level lr=5");
plot(t_simulink7,mmlevel7,"DisplayName","Level lr=10");
plot(t_simulink1,step_SPlevel1,"DisplayName","Set Point");
legend;
hold off;

f = figure;
f.Position = [200 200 500 200];
hold on;
title("Plot Square Error Kondisi Berbeban, Variasi Learning Rate Konstan");
xlabel("t (detik)");
ylabel("Square Error (mm^2)");
plot(t_simulink1,SE1,"DisplayName","SE lr=0.001");
plot(t_simulink2,SE2,"DisplayName","SE lr=0.01");
plot(t_simulink3,SE3,"DisplayName","SE lr=0.1");
plot(t_simulink4,SE4,"DisplayName","SE lr=1");
plot(t_simulink5,SE5,"DisplayName","SE lr=2");
plot(t_simulink6,SE6,"DisplayName","SE lr=5");
plot(t_simulink7,SE7,"DisplayName","SE lr=10");
% plot(t_simulink1,step_SPlevel1,"DisplayName","Set Point");
legend;
hold off;
% CALCULATE TOTAL COST FUNCTION: Jtotal
% J_error1 = sum(error1)
% J_error2 = sum(error2)
% J_error3 = sum(error3)
% J_error4 = sum(error4)
% J_error5 = sum(error5)
% J_error6 = sum(error6)
% J_error7 = sum(error7)

figure;
hold on;
title("Plot u_{flow valve} Kondisi Berbeban, Variasi Learning Rate Konstan");
xlabel("t (detik)");
ylabel("Tegangan Flow Valve (volt)");
plot(t_valve1,u_valve1,"DisplayName","u_{flow valve} lr=0.001");
plot(t_valve2,u_valve2,"DisplayName","u_{flow valve} lr=0.01");
plot(t_valve3,u_valve3,"DisplayName","u_{flow valve} lr=0.1");
plot(t_valve4,u_valve4,"DisplayName","u_{flow valve} lr=1");
plot(t_valve5,u_valve5,"DisplayName","u_{flow valve} lr=2");
plot(t_valve6,u_valve6,"DisplayName","u_{flow valve} lr=5");
plot(t_valve7,u_valve7,"DisplayName","u_{flow valve} lr=10");
legend;
hold off;
