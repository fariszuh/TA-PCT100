clear; clc
g = 9.82;
Rtabung = 9; % cm
Atabung = pi*Rtabung^2;
Rpipa = 1; % cm
Apipa = pi*Rpipa^2; 
Href = 10; % SP
n = 500; 
Ts = 0.5;
h = 0; % tinggi mula2
vout = 0; % debit drain
t_nl_arr = [];
h_nl_arr = [];

for t = 0:Ts:n
    % Non Linear Model (_nl)
    vout_nl = sqrt(2*g*h_nl);
    vin_nl = Href;
    dh_nl = Apipa*(vin_nl - vout_nl)/Atabung;
    h_nl = h_nl + dh_nl*Ts; % integral dh = sum dh = h (level)
    % OPEN LOOP
    % Saving to plot response
    t_arr = [t_arr t];
    h_nl_arr = [h_nl_arr h_nl];
    
    % Linear Approximation
    tau = 2*
end
plot(t_arr,h_nl_arr)