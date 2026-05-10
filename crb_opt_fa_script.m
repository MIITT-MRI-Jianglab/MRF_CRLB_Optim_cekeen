clc;clear;

%% For optimizing phase increment
d_fa = 600; % Number of timepoints
amax = 50; % Max FA (deg)

fa_default = deg2rad(readmatrix('MRF_FA_YJiang.txt'));
x0 = fa_default * deg2rad(amax)/max(fa_default);

A0 = [1 zeros(1,d_fa-1)];
A1 = -1*eye(d_fa) + circshift(eye(d_fa),1,2);
A1(end,:) = [];
A2 = -A1;
A = cat(1, A0, A1, A2);
B = deg2rad(1*ones(1,size(A,1)));
B(1) = deg2rad(5);

lb = deg2rad(0 * ones(1,d_fa));
ub = deg2rad(amax * ones(1,d_fa));

%% Optimizaiton
options = optimoptions('fmincon', ...
    'Algorithm', 'sqp', ...
    'Display', 'iter', ...
    'MaxIterations', 2e3, ...
    'MaxFunctionEvaluations', 2e6, ...
    'StepTolerance', 1e-4);

tic
x = fmincon(@crb_opt_fa_objective, x0, A, B, [], [], lb, ub, [], options);
opt_time = toc

%%
flip = x;

figure
plot(1:d_fa, rad2deg(flip),'Color','b','LineWidth',1)
xlim([1,d_fa]);
ylim([0,90]);
xlabel('TR Index')
ylabel(['Flip Angle (' char(176) ')'])
set(gca,'Fontsize',13)

nTR = num2str(length(flip));
save(['crb_opt_fa_' nTR '_Body_0p55.mat'], 'flip')