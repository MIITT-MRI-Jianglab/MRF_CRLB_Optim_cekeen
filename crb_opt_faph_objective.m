function objective = crb_opt_faph_objective(x)
    params.niter = ceil(length(x)/2);
    params.niso = 250;

    % Input your pulse sequence parameters here
    params.TE = 1.83; 
    params.TR = ones(1,params.niter) * 18;
    params.TI = 20.64;
    
    % Flip Angle
    params.fa = x(params.niter:end);
    
    % RF Phase
    % params.ph = mod([0 cumsum([1:params.niter-1].*rfphase)],2*pi);
    nphase = params.niter-1;
    phstart = params.niter - nphase;
    params.ph = mod(cumsum([zeros(1,phstart), (1:nphase).*x(1:params.niter-1)]),2*pi);

    params.delay = 1e6;

    % Spin properties
    % 0.55T Prostate Values (TZ/PZ)
    T1 = [600 2000];
    T2 = [80 500];

    % 0.55T Brain Values (GM/WM)
    % T1 = [500 990];
    % T2 = [75 115];

    % 3T Brain Values (GM/WM)
    % T1 = [800 1300];
    % T2 = [70 105];
    
    % Calculate CRB
    crbmat = zeros(3,3);
    w = diag([2e-5 5e-4 3e1]); % Weights from Zhao et al. Magn Reson Med. 2019
    parfor l = 1:length(T1)
        w = diag([1/T1(l)^2 T2(l)^2,0]); % Alternative CRLB weights
        crbmat = crbmat + w*calc_crlb_mex(params,T1(l),T2(l),1);
    end
    objective = crbmat(1,1) + crbmat(2,2);
end
