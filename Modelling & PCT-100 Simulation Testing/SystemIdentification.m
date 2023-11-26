clear; clc;clf
M = readmatrix("..\Coding Faris\closedLoop\Datasets\Datasets Open Loop Faris Ts 0.05.csv");

arr_k = M(:,1);
arr_timeNow = M(:,2);
arr_PV_flow = M(:,4)*0.4199798392422508 - 0.004550021909849653;
scatter(arr_timeNow,arr_PV_flow,"filled")
legend("Raw Data Plant")

SP_flow = 0.4199798392422508 * 10 - 0.004550021909849653
Yss = 3.429242569267122;
K = Yss/SP_flow % 0.9797835912191777;
Ts = 1
sysc_1vitechkova = tf([K],[1.4622697019577027 1],"InputDelay",0.41778553390502937);
sysd_1vitechkova = c2d(sysc_1vitechkova,Ts)
sysc_2vitechkova = tf([K],[0.932563970565796^2 2*0.932563970565796 1],"InputDelay",0.09782603168487558);
sysd_2vitechkova = c2d(sysc_2vitechkova,Ts)
sysc_latzel = tf([K],[2.2832144310474396^2 2* 2.2832144310474396 1]);
sysd_latzel = c2d(sysc_latzel,Ts)
sysc_smith = tf([K],[0.038709501241328326 1.5739784240722656 1]);
sysd_smith = c2d(sysc_smith,Ts)
sysc_krishnaswamy = tf([K],[1.0317201042175295 1],"InputDelay",0.7044448280334474);
sysd_krishnaswamy = c2d(sysc_krishnaswamy,Ts)
sysc_strejc = tf([K],[2.310636520385742^2 2*2.310636520385742 1]);
sysd_strejc = c2d(sysc_strejc,Ts)

sysc_harriot_khoiruz = tf([K],[0.468 1.39 1]);
sysd_harriot_khoiruz = c2d(sysc_harriot_khoiruz,Ts)

opt = stepDataOptions;
opt.StepAmplitude = SP_flow;

hold on
step(sysc_1vitechkova, opt)
step(sysc_2vitechkova, opt)
step(sysc_latzel, opt)
step(sysc_smith, opt)
step(sysc_krishnaswamy, opt)
step(sysc_strejc, opt)
step(sysc_harriot_khoiruz, opt)
% plot(sysd_1vitechkova, opt)
% plot(sysd_2vitechkova, opt)
% plot(sysd_latzel, opt)
% plot(sysd_smith, opt)
% plot(sysd_krishnaswamy, opt)
% plot(sysd_strejc, opt)
% plot(sysd_harriot_khoiruz, opt)
hold off
legend()