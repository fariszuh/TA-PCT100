%% READ DATASETS
clc; clear; close all
folderDatasets = "D:\OneDrive - Institut Teknologi Sepuluh Nopember\Tugas Akhir\TA PCT100\Datasets\";
folderKarakteristik = "Karakteristik Pompa\";

% file datasets
voltage_FC = 22;
arr_voltage_pompa = [2,4,6,8,10];
arr_k = [];
arr_timestamp = [];
arr_MV_volt_FCvalve = [];
arr_MV_volt_pompa = [];
arr_volt_flow = [];
arr_volt_level = [];
length_k_last = 0;
strLegend = zeros(length(arr_voltage_pompa));
for i = 1:length(arr_voltage_pompa)
    src = folderDatasets + folderKarakteristik + arr_voltage_pompa(i) + "Vpompa_" + voltage_FC + "Vfc.txt";
    T = readmatrix(src);
    k = T(:,1);
    length_k = length(k);
    if length_k > length_k_last
        arr_k(length_k_last : length_k,i) = zeros(length - length_k);
        arr_k = [arr_k, k];
    else
        arr_k = [arr_k, k];
    end
    length_k_last = length(k);

    timestamp = T(:,2);
    arr_timestamp = [arr_timestamp, timestamp];
    
    MV_volt_FCValve = T(:,3);
    arr_MV_volt_FCvalve = [arr_MV_volt_FCvalve, MV_volt_FCValve];
    
    MV_volt_pompa = T(:,4);
    arr_MV_volt_pompa = [arr_MV_volt_pompa, MV_volt_pompa];
    
    bit_flow = T(:,5);
    bit_level = T(:,6);
    clear T;
    volt_flow = bit_flow * 3.3 / 4096;
    volt_level = bit_level * 3.3 / 4096;
    arr_volt_flow = [arr_volt_flow, volt_flow];
    arr_volt_level = [arr_volt_level, volt_level];
    
    strLegend(i) = "V_{pompa} = " + arr_voltage_pompa(i) + "V";
end

figure, title("Flow Meter vs Input Pompa");
xlabel('k');
ylabel('V_{FT} (volt)');
hold on
plot(k,arr_volt_flow(:,1),"DisplayName",strLegend(1));
hold off
legend;
clear folderDatasets folderKarakteristik;

%% CONVERT TABLE
T = readmatrix(src);
k = T(:,1);
timestamp = T(:,2);
MV_volt_FCValve = T(:,3);
MV_volt_pompa = T(:,4);
bit_flow = T(:,5);
bit_level = T(:,6);
clear T;
volt_flow = bit_flow * 3.3 / 4096;
volt_level = bit_level * 3.3 / 4096;

figure, title("Flow vs Input Pompa");
plot(k,volt_flow,"DisplayName","V_{FT}");
hold on
plot(k,volt_flow,"DisplayName","V_{FT} = 2V");


% subplot(2,1,1);
% plot(k,volt_flow,"DisplayName","V_{FT}");
% hold on
% plot(k,MV_volt_pompa,"DisplayName","V_{pompa}");
% % plot(k,MV_volt_FCValve);
% hold off
% title('Flow vs Input Pompa');
% xlabel('k');
% ylabel('Volt');
% legend
% % 
% subplot(2,1,2);
% hold on
% plot(k,volt_level,"DisplayName","V_{LT}");
% plot(k,MV_volt_pompa,"DisplayName","V_{pompa}");
% % plot(k,MV_volt_FCValve);
% hold off
% title('Level vs Input Pompa');
% xlabel('k');
% ylabel('Volt');
% legend