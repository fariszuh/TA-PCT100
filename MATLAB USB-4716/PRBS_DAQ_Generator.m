clear; clf; clc
% input = frest.PRBS('Order',12,'NumPeriods',1,'Amplitude',0.05,'Ts',5e-6);
% plot(input)

%%
% O = 12;
% N = 2^O-1;
% pattern1 = prbs(O,N);
% 
% pattern2 = zeros(1,N);
% [pattern2(1),seed] = prbs(O,1);
% for ii = 2:N
%    [pattern2(ii),seed] = prbs(O,1,seed);
% end
% disp(isequal(pattern1,pattern2))
% plot(pattern2)
% xlim([0,70]);












arr_volt = [];
arr_time = [];
Ts = 0.1;

for timenow = 1:Ts:10
    volt = 10*(randi(2)-1);
    arr_volt = [arr_volt, volt];
    arr_time = [arr_time, timenow];
end

title("Input Signal");
hold on
stairs(arr_time, arr_volt);
xlabel("Time (s)");
ylabel("Voltage (V)");
hold off