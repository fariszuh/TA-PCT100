clear; clc; clf
Fx_kiri = importdata("Data Point Kiri.txt");
voltValve = Fx_kiri(:,1);
Kv_per_Kvs = Fx_kiri(:,2);
clear Fx_kiri;
plot(voltValve,Kv_per_Kvs);
% mencari nilai Kv/Kvs
voltInput = 5;
for i=1:length(voltValve)
    if voltValve(i) >= voltInput
        voltIndex = i;
        volt_min = voltValve(i-1);
        volt_max = voltValve(i);
        Kv_min = Kv_per_Kvs(i-1);
        Kv_max = Kv_per_Kvs(i);
        gradien = (Kv_max - Kv_min)/(volt_max - volt_min);
        Kv_estimated = gradien*(voltInput - volt_max) + Kv_max;
        break;
    end
end

% mencari flow
Q = Kv_estimated