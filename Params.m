% Workspace Params
J = 0.01;
b = 0.1;
R = 1;
L = 0.5;
K = 0.01;

% State-space parameter
A = [-b/J K/J;
    -K/L -R/L];
B = [0;
    1/L];
C = [1 0];
D = 0;

% Plant
MotorSys = ss(A, B, C, D);
Ts = 0.2;
MotorSys_Dis = c2d(MotorSys, Ts); % Discrete-time

% Simulation Time
t = 0:Ts:30;

% reference
step(MotorSys_Dis, t)

% mpc development
mpcobj = setmpcsignals(MotorSys_Dis, 'MV', 2); % signals
mpcobj.MV = struct('Min', -inf, 'Max', inf, 'RateMin', -inf, 'RateMax', inf);

getindist(mpcobj) % input disturbance model
getoutdist(mpcobj) % output disturbance model

% reference
r = ones(size(t), 1);

% simulation
sim(mpcobj, size(t), r)