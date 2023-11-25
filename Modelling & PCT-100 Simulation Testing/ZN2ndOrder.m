clc; clear; close all
G_FT = 6.940753740463935; % satuan dalam mm3/(Volt.ms)

[k_13p5Vfc,timestamp_13p5Vfc,MV_volt_FCValve_13p5Vfc,MV_volt_pompa_13p5Vfc,volt_flow_13p5Vfc,volt_level_13p5Vfc] = loadDatasets(10,13.5);
% potong array untuk mendapat nilai steady state
indexSplitMin = 55;
indexSplitMax = 170;
indexMulaiSS = 115;
volt_flow_13p5Vfc = volt_flow_13p5Vfc;
k_13p5Vfc = k_13p5Vfc(1:indexSplitMax);

ltpmin_13p5Vfc = G_FT*volt_flow_13p5Vfc(1:indexSplitMax) *6*(10^-2);
SI_13p5Vfc = stepinfo(ltpmin_13p5Vfc(indexMulaiSS:length(ltpmin_13p5Vfc)));
SI_13p5Vfc_ss = mean([SI_13p5Vfc.SettlingMin,SI_13p5Vfc.SettlingMax])

mm_level_13p5Vfc = 17.518911838790935*volt_level_13p5Vfc(1:indexSplitMax) + 42.177984886649874;

% FIND INFLECTION POINT
arr_de1 = [];
for i = [1:length(ltpmin_13p5Vfc)]
    if i == 1
        continue;
    end
    de1 = ltpmin_13p5Vfc(i) - ltpmin_13p5Vfc(i-1);
    arr_de1 = [arr_de1; de1];
end
%%
arr_de2 = [];
prev_inflectionPoint = 1000;
for j = [1:length(arr_de1)]
    if j == 1
        continue;
    end
    de2 = arr_de1(j) - arr_de1(j-1);
    arr_de2 = [arr_de2; de2];
    inflectionPoint = min(abs(arr_de2));
    if inflectionPoint < prev_inflectionPoint
        inflectp = j;
    end
    prev_inflectionPoint = inflectionPoint;
end
inflect_arr_de1 = 1 + inflectp;
m = arr_de1(inflect_arr_de1);
b = ltpmin_13p5Vfc(inflect_arr_de1+1) - m*(inflect_arr_de1+1);

inflectionPoint

y_pgl = m * k_13p5Vfc + b;

%%
u_13p5Vfc = 13.5;
% K = SI_13p5Vfc_ss/u_13p5Vfc;
% s = tf('s');
% sys_FC = K*exp(-1*L*s)/(T*s + 1)
% [y_hat,t_hat] = step(sys_FC,timestamp_13p5Vfc(indexSplitMax)/1000); % step until indexSplitMax in seconds

figure, title("Plot FC Valve saat Vpompa=10V vs k");
hold on;
xlabel("k");
ylabel("Flow rate (lt/min)");
plot(k_13p5Vfc,ltpmin_13p5Vfc,"DisplayName","Vfc=13.5V");
plot(k_13p5Vfc,y_pgl,"DisplayName","PGL");
% plot(t_hat,y_hat);
legend;
hold off;

%% LOAD DATASETS
function [k,timestamp,MV_volt_FCValve,MV_volt_pompa,volt_flow,volt_level] = loadDatasets(Vpompa,Vfc)
    folderDatasets = "D:\OneDrive - Institut Teknologi Sepuluh Nopember\Tugas Akhir\TA PCT100\Datasets\";
    folderKarakteristik = "Karakteristik Flow Control Valve\";
%     folderKarakteristik = "Karakteristik Pompa\";
    src = folderDatasets + folderKarakteristik + Vpompa + "Vpompa_" + Vfc + "Vfc.txt";
    T = readmatrix(src);
    k = T(:,1);  
    timestamp = T(:,2);
    MV_volt_FCValve = T(:,3);
    MV_volt_pompa = T(:,4);
    bit_flow = T(:,5);
    bit_level = T(:,6);

    % scaling langsung dikali 10V bukan 3.3V, karena sudah dlm bentuk bit
    volt_flow = bit_flow * 10 / 4096; 
    volt_level = bit_level * 10 / 4096;
end