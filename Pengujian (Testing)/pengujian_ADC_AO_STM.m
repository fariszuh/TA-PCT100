clc; clear; close all;

src = "D:\OneDrive - Institut Teknologi Sepuluh Nopember\Tugas Akhir\TA PCT100\Datasets\";
% Pengujian ramp AI STM32 dengan AO USB 4716
dest_folderAI = "Pengujian AI USB4716\";
file_AI = "USB4716_AI_Ramp.mat";
file_location_AI = src + dest_folderAI;
load(file_location_AI + file_AI);
%% PARSE AI USB4716
k_AI0_naik_start = 77;
k_AI0_naik_end = 1045;
k_AI0_turun_start = 1092;
k_AI0_turun_end = 2061;
timestamp_AI0_naik = arr_time(k_AI0_naik_start:k_AI0_naik_end)' - arr_time(k_AI0_naik_start);
timestamp_AI0_turun= arr_time(k_AI0_turun_start:k_AI0_turun_end)' - arr_time(k_AI0_naik_start) - (arr_time(k_AI0_turun_start) - arr_time(k_AI0_naik_end));
volt_AI0_naik = arr_volt_AI0(k_AI0_naik_start:k_AI0_naik_end)';
volt_AI0_turun = arr_volt_AI0(k_AI0_turun_start:k_AI0_turun_end)';

k_AI1_naik_start = 77;
k_AI1_naik_end = 1040;
k_AI1_turun_start = 1100;
k_AI1_turun_end = 2061;
timestamp_AI1_naik = arr_time(k_AI1_naik_start:k_AI1_naik_end)' - arr_time(k_AI1_naik_start);
timestamp_AI1_turun= arr_time(k_AI1_turun_start:k_AI1_turun_end)' - arr_time(k_AI1_naik_start) - (arr_time(k_AI1_turun_start) - arr_time(k_AI1_naik_end));
volt_AI1_naik = arr_volt_AI1(k_AI1_naik_start:k_AI1_naik_end)';
volt_AI1_turun = arr_volt_AI1(k_AI1_turun_start:k_AI1_turun_end)';

k_AI_USB = 1:length(arr_time); % untuk lihat k

%% PARSE AO STM32
[k,timestamp,volt_AO0,volt_AO1] = loadDatasets(file_location_AI);
k_AO0_naik_start = 54;
k_AO0_naik_end = 1116;
k_AO0_turun_start = 1172;
k_AO0_turun_end = 2224;
timestamp_AO0_naik = timestamp(k_AO0_naik_start:k_AO0_naik_end) - timestamp(k_AO0_naik_start);
timestamp_AO0_turun= timestamp(k_AO0_turun_start:k_AO0_turun_end) - timestamp(k_AO0_naik_start) - (timestamp(k_AO0_turun_start) - timestamp(k_AO0_naik_end));
volt_AO0_naik = volt_AO0(k_AO0_naik_start:k_AO0_naik_end);
volt_AO0_turun = volt_AO0(k_AO0_turun_start:k_AO0_turun_end);

k_AO1_naik_start = 54;
k_AO1_naik_end = 1116;
k_AO1_turun_start = 1172;
k_AO1_turun_end = 2224;
timestamp_AO1_naik = timestamp(k_AO1_naik_start:k_AO1_naik_end) - timestamp(k_AO1_naik_start-1);
timestamp_AO1_turun= timestamp(k_AO1_turun_start:k_AO1_turun_end) - timestamp(k_AO1_naik_start) - (timestamp(k_AO1_turun_start) - timestamp(k_AO1_naik_end));
volt_AO1_naik = volt_AO1(k_AO1_naik_start:k_AO1_naik_end);
volt_AO1_turun = volt_AO1(k_AO1_turun_start:k_AO1_turun_end);

%% PLOT
figure;
title("Pengujian Channel 0 (AO0) STM32 dengan AI0 USB4716");
hold on;
xlabel("t (detik)");
ylabel("V (volt)");
time_AI0_USB = [timestamp_AI0_naik; timestamp_AI0_turun];
% dikali 22/10 karena AO STM mensuplai 22VDC Max
volt_AI0_USB = [volt_AI0_naik;volt_AI0_turun]*22/10;
plot(time_AI0_USB,volt_AI0_USB,"DisplayName","AI0 USB4716");
% plot(k_AI_USB,arr_volt_AI1,"DisplayName","AO0 USB4716");

time_AO0_STM = [timestamp_AO0_naik;timestamp_AO0_turun]*1/1000;
volt_AO0_STM = [volt_AO0_naik;volt_AO0_turun];
plot(time_AO0_STM,volt_AO0_STM,"DisplayName","AO0 STM32");
% plot(k,volt_AO1,"DisplayName","AO STM32");
legend;
hold off;

figure;
title("Pengujian Channel 1 (AO1) STM32 dengan AI1 USB4716");
hold on;
xlabel("t (detik)");
ylabel("V (volt)");
time_AI1_USB = [timestamp_AI1_naik; timestamp_AI1_turun];
volt_AI1_USB = [volt_AI1_naik;volt_AI1_turun];
plot(time_AI1_USB,volt_AI1_USB,"DisplayName","AI1 USB4716");

time_AO1_STM = [timestamp_AO1_naik;timestamp_AO1_turun]*1/1000;
volt_AO1_STM = [volt_AO1_naik;volt_AO1_turun];
plot(time_AO1_STM,volt_AO1_STM,"DisplayName","AO1 STM32");
% plot(k,volt_AI1,"DisplayName","AI STM32");
legend;
hold off;

% error_AI1 = (volt_AO1_USB - volt_AI1_STM);
% MSE_AI1 = sum(error_AI1.^2)/length(error_AI1)
%% LOAD DATASETS
function [k,timestamp,MV_volt_FCValve, MV_volt_drain] = loadDatasets(file_location_AO)
    T = readmatrix(file_location_AO + "WRITE.TXT");

    k = T(:,1);
    timestamp = T(:,2);
    MV_volt_FCValve = T(:,3);
    MV_volt_drain = T(:,4);
%     volt_flow = T(:,5)*10/2303;
%     volt_level = T(:,6)*10/2303;
%     lr = T(:,8);
%     alpha = T(:,9);
% %     SP = T(:,10);
%     e = T(:,11);
end