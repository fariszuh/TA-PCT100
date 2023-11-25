clear; clc; close all;
[k1,timestamp1,u_valve1,ltpmin1,mmlevel1,lr1,alpha1,SP1,e1] = loadDatasets(0.0001);
SE1 = ((e1).^2);
error1 = 0.5*SE1;

[k2,timestamp2,u_valve2,ltpmin2,mmlevel2,lr2,alpha2,SP2,e2] = loadDatasets(0.001);
SE2 = ((e2).^2);
error2 = 0.5*SE2;

[k3,timestamp3,u_valve3,ltpmin3,mmlevel3,lr3,alpha3,SP3,e3] = loadDatasets(0.01);
SE3 = ((e3).^2);
error3 = 0.5*SE3;

[k4,timestamp4,u_valve4,ltpmin4,mmlevel4,lr4,alpha4,SP4,e4] = loadDatasets(0.1);
SE4 = ((e4).^2);
error4 = 0.5*SE4;

[k5,timestamp5,u_valve5,ltpmin5,mmlevel5,lr5,alpha5,SP5,e5] = loadDatasets(1);
SE5 = ((e5).^2);
error5 = 0.5*SE5;

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
figure;
hold on;
title("Plot Level Kondisi Berbeban, Alpha Konstan");
xlabel("t (detik)");
ylabel("Level (mm)");
plot(timestamp1,mmlevel1,"DisplayName","alpha=0.0001");
plot(timestamp2,mmlevel2,"DisplayName","alpha=0.001");
plot(timestamp3,mmlevel3,"DisplayName","alpha=0.01");
plot(timestamp4,mmlevel4,"DisplayName","alpha=0.1");
plot(timestamp5,mmlevel5,"DisplayName","alpha=1");
% plot(timestamp6,mmlevel6,"DisplayName","alpha=0.005");
% plot(timestamp7,mmlevel7,"DisplayName","alpha=0.025");
% plot(timestamp8,mmlevel8,"DisplayName","alpha=0.05");
plot(timestamp9,mmlevel9,"DisplayName","alpha=0.075");
plot(timestamp4,SP4,"DisplayName","Set Point");
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
function [k,timestamp,MV_volt_FCValve,ltpmin,mmlevel,lr,alpha,SP,e] = loadDatasets(alpha)
    folderDatasets = "D:\OneDrive - Institut Teknologi Sepuluh Nopember\Tugas Akhir\TA PCT100\Datasets\";
    folderKarakteristik = "Pengujian NN\Implementasi\lr adaptif\tracking\10menit\";
    src = folderDatasets + folderKarakteristik + "alpha=" + alpha + ".txt";
%     folderKarakteristik = "Pengujian NN\Implementasi\lr konstan\";
%     src = folderDatasets + folderKarakteristik + "lr=" + alpha + ".txt";

    T = readmatrix(src);
    k = T(:,1);  
    timestamp = T(:,2)/1000;
    MV_volt_FCValve = T(:,3);

    volt_flow = T(:,5);
    volt_level = T(:,6);

    % scaling langsung dikali 10V bukan 3.3V, karena sudah dlm bentuk bit
%     volt_flow = bit_flow * 10 / 4096; 
%     volt_level = bit_level * 10 / 4096;
    
    G_FT = 6.940753740463935;
    ltpmin = G_FT*volt_flow*6*(10^-2);
%     mmlevel = volt_level;
    mmlevel = 17.518911838790935*volt_level + 42.177984886649874;

    lr = T(:,8);
    alpha = T(:,9);
    SP = T(:,10);
    e = T(:,11); 
end