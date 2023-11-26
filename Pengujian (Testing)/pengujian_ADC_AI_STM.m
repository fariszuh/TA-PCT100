clc; clear; close all;

src = "D:\OneDrive - Institut Teknologi Sepuluh Nopember\Tugas Akhir\TA PCT100\Datasets\";
% Pengujian ramp AI STM32 dengan AO USB 4716
dest_folderAO = "Pengujian AO USB4716\";
file_AO = "USB4716_AO_Ramp.mat";
file_location_AO = src + dest_folderAO;
load(file_location_AO + file_AO);
%% PARSE AO USB4716
k_AO0_naik_start = 1;
k_AO0_naik_end = 954;
k_AO0_turun_start = 1048;
k_AO0_turun_end = 2018;
timestamp_AO0_naik = arr_time(k_AO0_naik_start:k_AO0_naik_end)' - arr_time(k_AO0_naik_start);
timestamp_AO0_turun= arr_time(k_AO0_turun_start:k_AO0_turun_end)' - arr_time(k_AO0_naik_start) - (arr_time(k_AO0_turun_start) - arr_time(k_AO0_naik_end));
volt_AO0_naik = arr_voltRamp_AO0(k_AO0_naik_start:k_AO0_naik_end)';
volt_AO0_turun = arr_voltRamp_AO0(k_AO0_turun_start:k_AO0_turun_end)';

k_AO1_naik_start = 1;
k_AO1_naik_end = 952;
k_AO1_turun_start = 1048;
k_AO1_turun_end = 2018;
timestamp_AO1_naik = arr_time(k_AO1_naik_start:k_AO1_naik_end)' - arr_time(k_AO1_naik_start);
timestamp_AO1_turun= arr_time(k_AO1_turun_start:k_AO1_turun_end)' - arr_time(k_AO1_naik_start) - (arr_time(k_AO1_turun_start) - arr_time(k_AO1_naik_end));
volt_AO1_naik = arr_voltRamp_AO1(k_AO1_naik_start:k_AO1_naik_end)';
volt_AO1_turun = arr_voltRamp_AO1(k_AO1_turun_start:k_AO1_turun_end)';

k_AO_USB = 1:length(arr_time); % untuk lihat k

%% PARSE AI STM32
[k,timestamp,volt_AI0,volt_AI1] = loadDatasets(file_location_AO);
k_AI0_naik_start = 89;
k_AI0_naik_end = 638;
k_AI0_turun_start = 1903;
k_AI0_turun_end = 2478;
timestamp_AI0_naik = timestamp(k_AI0_naik_start:k_AI0_naik_end) - timestamp(k_AI0_naik_start);
timestamp_AI0_turun= timestamp(k_AI0_turun_start:k_AI0_turun_end) - timestamp(k_AI0_naik_start) - (timestamp(k_AI0_turun_start) - timestamp(k_AI0_naik_end));
volt_AI0_naik = volt_AI0(k_AI0_naik_start:k_AI0_naik_end);
volt_AI0_turun = volt_AI0(k_AI0_turun_start:k_AI0_turun_end);

k_AI1_naik_start = 90;
k_AI1_naik_end = 636;
k_AI1_turun_start = 1904;
k_AI1_turun_end = 2477;
timestamp_AI1_naik = timestamp(k_AI1_naik_start:k_AI1_naik_end) - timestamp(k_AI1_naik_start-1);
timestamp_AI1_turun= timestamp(k_AI1_turun_start:k_AI1_turun_end) - timestamp(k_AI1_naik_start) - (timestamp(k_AI1_turun_start) - timestamp(k_AI1_naik_end));
volt_AI1_naik = volt_AI1(k_AI1_naik_start:k_AI1_naik_end);
volt_AI1_turun = volt_AI1(k_AI1_turun_start:k_AI1_turun_end);

figure;
title("Pengujian Channel 0 (AI0) STM32 dengan AO0 USB4716");
hold on;
xlabel("t (detik)");
ylabel("V (volt)");
time_AO0_USB = [timestamp_AO0_naik; timestamp_AO0_turun];
volt_AO0_USB = [volt_AO0_naik;volt_AO0_turun];
plot(time_AO0_USB,volt_AO0_USB,"DisplayName","AO0 USB4716");

time_AI0_STM = [timestamp_AI0_naik;timestamp_AI0_turun]*2.02/1000;
volt_AI0_STM = [volt_AI0_naik;volt_AI0_turun];
plot(time_AI0_STM,volt_AI0_STM,"DisplayName","AI0 STM32");
% plot(k,volt_AI1,"DisplayName","AI STM32");
legend;
hold off;

figure;
title("Pengujian Channel 1 (AI1) STM32 dengan AO1 USB4716");
hold on;
xlabel("t (detik)");
ylabel("V (volt)");
time_AO1_USB = [timestamp_AO1_naik; timestamp_AO1_turun];
volt_AO1_USB = [volt_AO1_naik;volt_AO1_turun];
plot(time_AO1_USB,volt_AO1_USB,"DisplayName","AO1 USB4716");

time_AI1_STM = [timestamp_AI1_naik;timestamp_AI1_turun]*2.02/1000;
volt_AI1_STM = [volt_AI1_naik;volt_AI1_turun];
plot(time_AI1_STM,volt_AI1_STM,"DisplayName","AI1 STM32");
% plot(k,volt_AI1,"DisplayName","AI STM32");
legend;
hold off;

% error_AI1 = (volt_AO1_USB - volt_AI1_STM);
% MSE_AI1 = sum(error_AI1.^2)/length(error_AI1)
%% LOAD DATASETS
function [k,timestamp,volt_flow,volt_level] = loadDatasets(file_location_AO)
    T = readmatrix(file_location_AO + "WRITE.TXT");

    k = T(:,1);
    timestamp = T(:,2);
%     MV_volt_FCValve = T(:,3);
%     MV_volt_drain = T(:,4);
    volt_flow = T(:,5)*10/2303;
    volt_level = T(:,6)*10/2303;
%     lr = T(:,8);
%     alpha = T(:,9);
% %     SP = T(:,10);
%     e = T(:,11);
end