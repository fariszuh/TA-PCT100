clc; clear; close all
% jalankan dulu simulink closed loop untuk mendapat out.drainLoad
selectorSP = 0; % 1 untuk SP fixed, 0 untuk SP dynamic
SP = 100;
if selectorSP == 1
    SPstat = SP;
elseif selectorSP == 0
    SPstat = "dynamic";
end

selectorMOV = 0; % 1 untuk MOV fixed, 0 untuk MOV dynamic
persenMOVfixed = 0.5;
if selectorMOV == 1
    MOVstat = persenMOVfixed;
elseif selectorMOV == 0
    MOVstat = "dynamic";
end

lr_init = 0.00001;
alpha = 0.0001; % 0 jika tidak ada adaptasi lr
out = sim('closedLoop', 'timeout', 1680);

t_simulink = out.tout;
step_SPlevel = out.SPlevel;
% step_SPlevel = 100*ones(length(t_simulink),1);
persen_bukaanValve = out.drainLoad * 100;
mmlevel = out.h_simulink;
u_Vfc = out.Vfc;
lr_save = out.lr;
error = out.error_save;
t_Vfc = linspace(min(t_simulink),max(t_simulink),length(u_Vfc))';
save("TanpaKontroller_SP="+SPstat+"_MOV="+MOVstat+"_lrinit="+lr_init+"_alpha="+alpha+".mat","t_simulink","mmlevel","step_SPlevel","persen_bukaanValve","u_Vfc","lr_save","error");
% save("test_PID_pidtune"+"_SP="+SPstat+"_MOV="+MOVstat+".mat","t_simulink","mmlevel","step_SPlevel","persen_bukaanValve","u_Vfc","lr_save","error");


%% PLOT
figure; 
subplot(3,1,1);
hold on;
title("Respon Level");
xlabel("t (detik)");
ylabel("Level (mm)");
plot(t_simulink, mmlevel,"DisplayName","Level Tangki");
plot(t_simulink, step_SPlevel,"DisplayName","Setpoint Level");
legend;
hold off;

subplot(3,1,2);
title("Sinyal Kontrol Aktuator Valve");
hold on;
xlabel("t (detik)");
ylabel("V_{FC Valve} (volt)");
plot(t_Vfc, u_Vfc);
hold off;

subplot(3,1,3);
title("Beban Motor Drain Valve");
hold on;
xlabel("t (detik)");
ylabel("Bukaan Motor Valve (%)");
plot(t_simulink, persen_bukaanValve);
hold off;

stepinfo(mmlevel,t_simulink)

% 
% figure; hold on;
% title("Beban oleh Bukaan Motor Drain Valve");
% xlabel("t (detik)");
% ylabel("Bukaan Motor Valve (%)");
% plot(t_simulink, persen_bukaanValve);
% hold off;
% %%
% figure; hold on;
% title("Step Set Point");
% xlabel("t (detik)");
% ylabel("SP Level (mm)");
% plot(t_simulink, step_SPlevel);
% hold off;
