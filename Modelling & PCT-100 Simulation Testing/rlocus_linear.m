% untuk mulai menampilkan grafik osilasi, run simulasinya dulu
% simulinknya ada di tuningPID
clc; clear; close all;

valve = tf([0.1619],[0.0034 1]);
delay_valve = tf([-0.0011 1],[0.0011 1]);
tangki = tf([39.2975],[1 0.01028]);
plant = valve*delay_valve*tangki

figure;
rlocus(plant)
%% SIMULASI HASIL BACAAN ROOT LOCUS
% dari hasil root locus diperoleh critical gain Kcr = 81.4
out = sim("tuningPID.slx","timeout", 0.2);

figure;
title("Closed Loop Ziegler-Nichols Critical Gain K_{cr}");
hold on;
xlabel("t (detik)");
ylabel("Level (mm)");
plot(out.tout,out.level_2ndZN,"DisplayName","Level Tangki");
SP_2ndZN_avg = mean([max(out.level_2ndZN), min(out.level_2ndZN)]);
% plot(out.tout,ones(length(out.tout),1)*SP_2ndZN_avg,"DisplayName","Set Point Level");
plot(out.tout,out.SP_2ndZN,"DisplayName","Set Point Level");
hold off;
legend;
