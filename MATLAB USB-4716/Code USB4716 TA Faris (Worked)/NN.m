n_neuronInput = 3;
n_neuronHidden = [4,1,1]; % jumlah neuron pada urutan layer eg.[jumlahNeuronLayer1,jumlahNeuronLayer2,jumlahNeuronLayer3]
n_HiddenLayer = length(n_neuronHidden); % jumlah layer bergantung ada brp kolom pada baris n_HiddenLayer
n_neuronOutput = 3;
x = [1,2,3]; % nilai input layer
y = []
% baris = layer input dan hidden saja
layerRow = 1 + n_HiddenLayer; % layer output tdk dihitung karena tidak ada weight keluar
neuronColumn = max(n_neuronHidden); % kolom = neuron hidden saja, untuk buat matrix w butuh kolom maximum isi brp
w = zeros(layerRow, neuronColumn); % baris array mulai dari layer input hingga hidden ke-n, kolom
% bias
arr_b = zeros();

% FORWARD PROPAGATION
for i=1:3 % untuk tiap neuron masukan
    for j=1:4 % ke tiap neuron tujuan
        y(j) = w(i,j)*x(i) + arr_b(j);
    end
end

% BACKWARD PROPAGATION
for i=1:4 
    for j=1:5
        w(i,j) = 
    end
end