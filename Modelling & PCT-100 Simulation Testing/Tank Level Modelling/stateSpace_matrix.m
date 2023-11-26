% matrix 3x3 untuk simulink state space
r_tabung = 0.9; % dalam cm
A_tabung = pi*r_tabung^2;
K_fc = 1.258;
wn = 4.41;
zeta = 1.458;

% ditulis dalam bentuk xdot = Ax + Bu + d
A = [0 1 0; 
    -1*wn^2 -2*zeta*wn 0;
    1/A_tabung 0 0];
% tampak polenya negatif -> system stabil
poles = eig(A)
B = [0; K_fc*wn^2; 0];
C = [0 0 1;
    1 0 0];
D = [0; 0; -1/A_tabung];

p1 = -1 + 1i;
p2 = -1 - 1i;
p3 = -5;
K = place(A,B,[p1 p2 p3])

