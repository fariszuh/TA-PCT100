level_perbandingan = sim('perbandingan_3TFlevel.slx');
%% Perbandingan
mmlevel_pole = level_perbandingan.level_perbandingan(:,1);
mmlevel_ogata = level_perbandingan.level_perbandingan(:,2);
mmlevel_simulink = level_perbandingan.level_perbandingan(:,3);
t = level_perbandingan.tout;

Vpompa = 2.5;
Vfc = 15;
Vdrain = 0;

% Konversi V_FT ke lt/min
[k_2p5Vfc_ori,timestamp_2p5Vfc_ori,MV_volt_FCValve_2p5Vfc_ori,MV_volt_pompa_2p5Vfc_ori,volt_flow_2p5Vfc_ori,volt_level_2p5Vfc_ori] = loadDatasets(Vpompa,Vfc,Vdrain);
% hapus data NaN, tapi buat k_2p5Vfc baru
indexNaN = isnan(k_2p5Vfc_ori) | isnan(volt_flow_2p5Vfc_ori) | isnan(volt_level_2p5Vfc_ori);
k_2p5Vfc = [];
timestamp_2p5Vfc = [];
MV_volt_FCValve_2p5Vfc = [];
MV_volt_pompa_2p5Vfc = [];
volt_flow_2p5Vfc = [];
volt_level_2p5Vfc = [];
loop_time = 0;
loop_k = 1;
for k=1:length(k_2p5Vfc_ori)
    if(k < 1970)
        continue; % skip initial start step time
    elseif(k == 17000)
        break;
    end
    if(indexNaN(k) == 0)
        k_2p5Vfc = [k_2p5Vfc; loop_k];
        timestamp_2p5Vfc = [timestamp_2p5Vfc; loop_time];
        MV_volt_FCValve_2p5Vfc = [MV_volt_FCValve_2p5Vfc; MV_volt_FCValve_2p5Vfc_ori(k)];
        MV_volt_pompa_2p5Vfc = [MV_volt_pompa_2p5Vfc; MV_volt_pompa_2p5Vfc_ori(k)];
        volt_flow_2p5Vfc = [volt_flow_2p5Vfc; volt_flow_2p5Vfc_ori(k)];
        volt_level_2p5Vfc = [volt_level_2p5Vfc; volt_level_2p5Vfc_ori(k)];
        loop_k = loop_k + 1;
        loop_time = loop_time + 50; % dalam ms
    end
end

% Konversi V_LT ke mm
m_LT_inv = 17.518911838790935;
c_LT_inv = 42.177984886649874;
mmlevel_2p5Vfc = m_LT_inv*volt_level_2p5Vfc + c_LT_inv;

figure;
title("Openloop pada Steady Point h=61.651mm, Pembebanan Nominal");
xlabel("t (detik)");
ylabel("Level (mm)");
hold on;
plot(t,mmlevel_pole,'g',"DisplayName","Identifikasi Manual Valve");
plot(t,mmlevel_ogata,'r',"DisplayName","Model RC");
plot(t,mmlevel_simulink,'b',"DisplayName","Blok Diagram");
plot(timestamp_2p5Vfc/1000,mmlevel_2p5Vfc,'m',"DisplayName","Plant Sebenarnya");
legend;
hold off;

%% LOAD DATASETS
function [k,timestamp,MV_volt_FCValve,MV_volt_pompa,volt_flow,volt_level] = loadDatasets(Vpompa,Vfc,Vdrain)
    folderDatasets = "D:\OneDrive - Institut Teknologi Sepuluh Nopember\Tugas Akhir\TA PCT100\Datasets\";
    folderKarakteristik = "with Manual Valve\Run 16 Menit\";

    src = folderDatasets + folderKarakteristik + Vpompa + "Vpompa_" + Vfc + "Vfc_" + Vdrain + "Vdrain.txt";
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