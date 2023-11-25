clear; clc
s = tf('s');
global t y e_y e_y_1 e_y_2;

K = 1;
Td = 5;
T1 = 3;
T2 = 5;
lr = 0.1;
Ts = 0.05;
sys_c = ((K*exp(-Td*s)) / ((T1*s+1)*(T2*s+1)))^1;
sys_d = c2d(sys_c,Ts,'linear-square')
sys_d.Variable = 'z^-1'
sys_d_num = cell2mat(sys_d.Numerator)
sys_d_denom = cell2mat(sys_d.Denominator)

w_input = rand(3,3); % 1x3, weight ke hidden j ialah baris dari w_input
v_hidden = rand(1,3);
delta2 = zeros(1,3);
x_input = [0;0;0]; % 3x1, [e(t),e(t-1),e(t-2)]
hj = [0;0;0];
%% NN STC
y_r = 10; % y ref
y = 0;
u = 0;
e_u = u;
e_y = 0;
e_y_1 = 0;
e_y_2 = 0;
diffTime = 0;
tic;

while diffTime < 20 
    diffTime = toc;
    e_y = y_r - y
    x_input = [e_y; e_y_1; e_y_2]
    % calculate Sj / summing dari weight input layer
    % baris 1 untuk neuron 1, baris 2 untuk neuron 2 hidden layer Sj hj
    for j_hiddenLayer = 1:3
        Sj = w_input(j_hiddenLayer,:) * x_input; % summing hidden neuron ke-j
        hj(j_hiddenLayer) = 1/(1 + exp(-1*Sj));
    end
    
    r = v_hidden * hj;
    u = 1/(1+exp(-1*r));
    % send AO to driver STM
    y = 0;
%     [y,t] = lsim(sys,u,20);

%     e_u = ud - u;
    % retro propagation
    MSE = 0.5*(e_y^2);
    delta1 = e_y*u*(1-u);

    for j_hiddenLayer = 1:3
        v_hidden(j_hiddenLayer) = v_hidden(j_hiddenLayer) + lr * dey_deu * delta1 * hj(j_hiddenLayer);
        delta2(j_hiddenLayer) = delta1 * v_hidden(j_hiddenLayer) * hj(j_hiddenLayer) * (1 - hj(j_hiddenLayer));
        
        for i_inputLayer = 1:3
            w_inputLayer(j_hiddenLayer,i_inputLayer) = w_inputLayer(j_hiddenLayer,i_inputLayer) + lr * dey_deu * delta2(j_hiddenLayer) * x(i_inputLayer);
        end
    end    
    dey_deu = (y(diffTime) - y(diffTime - 2))/(timestamp_13p5Vfc(diffTime) - timestamp_13p5Vfc(diffTime - 2));
    
    e_y_1 = e_y;
    e_y_2 = e_y_1;
    
end

t
y
