clear; clc; close all;
[t1,ltpmin1,mmlevel1] = loadDatasets(0.0001);
% SE1 = ((e1).^2);
% error1 = 0.5*SE1;

[t2,ltpmin2,mmlevel2] = loadDatasets(0.001);
% SE2 = ((e2).^2);
% error2 = 0.5*SE2;

[t3,ltpmin3,mmlevel3] = loadDatasets(0.01);
t3 = t3 - 8.15;
% SE3 = ((e3).^2);
% error3 = 0.5*SE3;

[t4,ltpmin4,mmlevel4] = loadDatasets("0.1(2)");
t4 = t4 - 6.088;
% SE4 = ((e4).^2);
% error4 = 0.5*SE4;

[t5,ltpmin5,mmlevel5] = loadDatasets(1);
t5 = t5 - 3.34;
% SE5 = ((e5).^2);
% error5 = 0.5*SE5;

% [k6,timestamp6,u_valve6,ltpmin6,mmlevel6,lr6,alpha6,SP6,e6] = loadDatasets(0.005);
% SE6 = ((e6).^2);
% error6 = 0.5*SE6;
% 
% [k7,timestamp7,u_valve7,ltpmin7,mmlevel7,lr7,alpha7,SP7,e7] = loadDatasets(0.025);
% SE7 = ((e7).^2);
% error7 = 0.5*SE7;
% 
% [k8,timestamp8,u_valve8,ltpmin8,mmlevel8,lr8,alpha8,SP8,e8] = loadDatasets(0.05);
% SE8 = ((e8).^2);
% error8 = 0.5*SE8;

% [k9,timestamp9,u_valve9,ltpmin9,mmlevel9,lr9,alpha9,SP6,e9] = loadDatasets(0.075);
% SE9 = ((e9).^2);
% error9 = 0.5*SE9;

%%
n_akhir = 27474;
t1 = t1(1:n_akhir);
k1 = 1:length(t1);
t2 = t2(1:n_akhir);
k2 = 1:length(t2);
t3 = t3(1:n_akhir);
k3 = 1:length(t3);
t4 = t4(1:n_akhir);
k4 = 1:length(t4);
t5 = t5(1:n_akhir);
k5 = 1:length(t5);
mmlevel1 = mmlevel1(1:n_akhir);
mmlevel2 = mmlevel2(1:n_akhir);
mmlevel3 = mmlevel3(1:n_akhir);
mmlevel4 = mmlevel4(1:n_akhir);
mmlevel5 = mmlevel5(1:n_akhir);

SP = 50*ones(length(t5),1);
SP(3955:7883) = 100;
SP(7883:11797) = 150;
SP(11797:15556) = 200;
SP(15556:19407) = 150;
SP(19407:23289) = 100;

figure;
hold on;
title("Plot Level Kondisi Berbeban, Alpha Konstan");
xlabel("t (detik)");
ylabel("Level (mm)");
plot(t1,mmlevel1,"DisplayName","alpha=0.0001");
plot(t2,mmlevel2,"DisplayName","alpha=0.001");
plot(t3,mmlevel3,"DisplayName","alpha=0.01");
plot(t4,mmlevel4,"DisplayName","alpha=0.1");
plot(t5,mmlevel5,"DisplayName","alpha=1");
% plot(timestamp6,mmlevel6,"DisplayName","alpha=0.005");
% plot(timestamp7,mmlevel7,"DisplayName","alpha=0.025");
% plot(timestamp8,mmlevel8,"DisplayName","alpha=0.05");
% plot(timestamp9,mmlevel9,"DisplayName","alpha=0.075");
plot(t5,SP,"DisplayName","Set Point");
legend;
hold off;

% 
% f = figure;
% f.Position = [200 200 500 200];
% hold on;
% title("Plot Square Error Kondisi Berbeban, Variasi Learning Rate Konstan");
% xlabel("t (detik)");
% ylabel("Square Error (mm^2)");
% plot(t_simulink1,SE1,"DisplayName","SE lr=0.001");
% plot(t_simulink2,SE2,"DisplayName","SE lr=0.01");
% plot(t_simulink3,SE3,"DisplayName","SE lr=0.1");
% plot(t_simulink4,SE4,"DisplayName","SE lr=1");
% plot(t_simulink5,SE5,"DisplayName","SE lr=2");
% plot(t_simulink6,SE6,"DisplayName","SE lr=5");
% plot(t_simulink7,SE7,"DisplayName","SE lr=10");
% % plot(t_simulink1,step_SPlevel1,"DisplayName","Set Point");
% legend;
% hold off;
% % CALCULATE TOTAL COST FUNCTION: Jtotal
% J_error1 = sum(error1)
% J_error2 = sum(error2)
% J_error3 = sum(error3)
% J_error4 = sum(error4)
% J_error5 = sum(error5)
% J_error6 = sum(error6)
% J_error7 = sum(error7)
% 
% figure;
% hold on;
% title("Plot u_{flow valve} Kondisi Berbeban, Variasi Learning Rate Konstan");
% xlabel("t (detik)");
% ylabel("Tegangan Flow Valve (volt)");
% plot(t_valve1,u_valve1,"DisplayName","u_{flow valve} lr=0.001");
% plot(t_valve2,u_valve2,"DisplayName","u_{flow valve} lr=0.01");
% plot(t_valve3,u_valve3,"DisplayName","u_{flow valve} lr=0.1");
% plot(t_valve4,u_valve4,"DisplayName","u_{flow valve} lr=1");
% plot(t_valve5,u_valve5,"DisplayName","u_{flow valve} lr=2");
% plot(t_valve6,u_valve6,"DisplayName","u_{flow valve} lr=5");
% plot(t_valve7,u_valve7,"DisplayName","u_{flow valve} lr=10");
% legend;
% hold off;

%% LOAD DATASETS
function [t,ltpmin,mmlevel] = loadDatasets(alpha)
    folderDatasets = "D:\OneDrive - Institut Teknologi Sepuluh Nopember\Tugas Akhir\TA PCT100\Datasets\";
    folderKarakteristik = "Pengujian NN\Implementasi\lr adaptif\tracking\20menit\";
    src = folderDatasets + folderKarakteristik + "alpha=" + alpha + ".mat";
    load(src);
%     disp("fff");
    t = arr_time;
    G_FT = 6.940753740463935;
    ltpmin = G_FT*arr_volt_AI0*6*(10^-2);
    mmlevel = 17.518911838790935*arr_volt_AI1 + 42.177984886649874;
end