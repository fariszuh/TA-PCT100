arr_y = [];
t0 = tic;
%% INISIASI VARIABEL LEVEL
Ts = 0.01;
Kp_level = 1;
Ki_level = 0.1;
Kd_level = 0.01;
SP_level = 10; % dalam cm
y_level = 0;
e_level = 0;
sum_e_level = 0;
%% INISIASI VARIABEL FLOW
Kp_flow = 1;
Ki_flow = 0.1;
Kd_flow = 0.01;
t0 = tic;
y_flow = 0;
e_flow = 0;
sum_e_flow = 0
Gain_levelflow = 1; 
Gain_flowvalve = 1;

%% CLOSED LOOP CONTROLLER
while t-t0 < 1200
    [y_flow y_level] = ReadWrite(1,0); % read from feedback sensor, masih dalam satuan volt
    % Summing point outer loop
    e_level = SP_level - y_level; 
    sum_e_level = sum_e_level + e_level*Ts;
    delevel = (e_level(k) - e_level(k-1))/Ts;
    % Outer PID Controller
    P_level = Kp_level * e_level;
    I_level = Ki_level * sum_e_level;
    D_level = Kd_level * de_level;
    uPID_level = P_level + I_level + D_level; % sinyal kontrol ini menjadi SP dari inner loop flow
    
    % Summing point inner loop
    SP_flow = Gain_levelflow * uPID_level; % flow dalam lt/min
    e_flow = SP_flow - y_flow;
    sum_e_flow = sum_e_flow + e_flow*Ts;
    de_flow = (e_flow(k) - e_flow(k-1))/Ts;
    % Inner PID Controller
    P_flow = Kp_flow * e_flow;
    I_flow = Ki_flow * sum_e_flow;
    D_flow = Kd_flow * de_flow;
    uPID_flow = P_flow + I_flow + D_flow;
    % kirim ke valve, konversi dari lt/min ke volt MV valve
    MV_valve = Gain_flowvalve * uPID_flow;
    
    t = toc(t0);
    arr_y = [arr_y y];
    arr_t = [arr_t t];
    arr_e = [arr_e e]
end