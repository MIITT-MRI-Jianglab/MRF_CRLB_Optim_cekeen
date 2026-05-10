%% For optimizing phase increment
clc;clear;

d_fa = 600; % Number of timepoints
d_ph = d_fa-1;
d = d_ph + d_fa;
amax = 50; % Max FA (deg)

% Phase
x0_ph = deg2rad(2*ones(1,d_ph));

% FA
fa_default = deg2rad(readmatrix('MRF_FA_YJiang.txt'));
x0_fa = fa_default(1:d_fa) * deg2rad(amax)/max(fa_default);

x0 = [x0_ph x0_fa];

A0 = [zeros(1,d_ph) 1 zeros(1,d_fa-1)];
A1 = -1*eye(d) + circshift(eye(d),1,2);
A1(d_ph,:) = [];
A1(end,:) = [];
A2 = -1*A1;
A = cat(1,A0,A1,A2);

B1 = deg2rad(0.025 * ones(1,d_ph-1));
B2 = deg2rad(1 * ones(1,d_fa-1));
B = [deg2rad(5) B1 B2 B1 B2];

Aeq = [zeros(1,d_ph-1) 1 zeros(1,d_fa)];
Beq = 0;

lb = [deg2rad(0 * ones(1,d_ph)) deg2rad(0 * ones(1,d_fa))];
ub = [deg2rad(10 * ones(1,d_ph)) deg2rad(amax * ones(1,d_fa))];

%% Optimizaiton
options = optimoptions('fmincon', ...
    'Algorithm', 'sqp', ...
    'Display', 'iter', ...
    'MaxIterations', 2e3, ...
    'MaxFunctionEvaluations', 2e6, ...
    'StepTolerance', 1e-4);

tic
x = fmincon(@crb_opt_faph_objective, x0, A, B, Aeq, Beq, lb, ub, [], options);
opt_time = toc

%%
niter = d_fa;
nphase = d_ph;

flip = x(d_ph+1:end);
rfinc = x(1:d_ph);
phase = [zeros(1,niter-nphase) mod(cumsum((1:nphase).*rfinc),2*pi)];

figure
subplot(2,1,1)
plot(1:d_fa, rad2deg(flip),'Color','b','LineWidth',1)
xlim([1,d_fa]);
ylim([0,90]);
xlabel('TR Index')
ylabel(['Flip Angle (' char(176) ')'])
set(gca,'Fontsize',13)

subplot(2,1,2)
plot(1:d_ph, rad2deg(rfinc),'Color','b','LineWidth',1)
xlim([1,d_ph]);
ylim([0,12]);
xlabel('TR Index')
ylabel(['RF Phase Increment (' char(176) ')'])
set(gca,'Fontsize',13)

nTR = num2str(length(flip));
save(['crb_opt_faph_' nTR '_Body_0p55.mat'], 'flip', 'rfinc', 'phase')
