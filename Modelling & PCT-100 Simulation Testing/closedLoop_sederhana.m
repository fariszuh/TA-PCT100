clear; clc; close all
s = tf('s');
K = 1;
Td = 5;
T1 = 3;
T2 = 5;
lr = 0.1;
% send AO to driver STM
sys = ((K*exp(-Td*s)) / ((T1*s+1)*(T2*s+1)))^2;
Ts = 0.05;
sys_d = c2d(sys,Ts)

A = cell2mat(sys_d.Numerator);
B = cell2mat(sys_d.Denominator);
[x_1,x_2,x_3,x_4] = deal(0);
[y_1,y_2,y_3,y_4] = deal(0);
diffTime = 0;
tic;
u = 1;
arr_t = [];
arr_yk = [];
format compact
timeNow = 0;
prev_timeNow = 0;
runTime = 2;
while(timeNow < runTime)
    timeNow = toc
    if timeNow - prev_timeNow >= 0.05
%     if 1
        x_1 = u;
        xk = [x_1; x_2; x_3; x_4];
        yk = [y_1; y_2; y_3; y_4];
        
        yk = A(2:length(A))*xk - B(2:length(B))*yk;
        arr_t = [arr_t,timeNow];
        arr_yk = [arr_yk,yk];
        
        x_2 = x_1; 
        x_3 = x_2;
        x_4 = x_3;
        y_1 = yk;
        y_2 = y_1;
        y_3 = y_2; 
        y_4 = y_3;
        prev_timeNow = timeNow;
    end
end

[y_cont,t_cont] = step(sys,runTime);

figure, title("Continous vs Discrete TF");
hold on;
xlabel("Time (s)");
ylabel("Flow (lt/min)");
plot(arr_t, arr_yk,"DisplayName","Pers.Beda");
% plot(t_cont,y_cont,"DisplayName","Sys continous");
legend;
hold off;
