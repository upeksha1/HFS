%% generate_all_figures_ASI.m
% One-script file to reproduce the figures for:
% "Active and Backstepping Control for Stabilization and Synchronization
% of a Four-Dimensional Hyperchaotic Finance System"
%
% The script generates Figures 1--18 and saves them in ./ASI_Figures.
% Notes:
%   1. Bifurcation diagrams and Lyapunov-exponent calculations may take time.
%   2. Set FAST_MODE = true for a quick test run; set FAST_MODE = false for
%      denser, publication-quality bifurcation diagrams.
%   3. All helper functions are included at the end of this same file.
%
% Suggested manuscript statement:
% Simulations were performed in MATLAB using ode45 with RelTol=1e-9 and
% AbsTol=1e-12. The random seed was fixed using rng(1) for noisy robustness
% simulations.

clear; close all; clc;

%% ----------------------- User settings -----------------------
FAST_MODE = true;        % true: faster test; false: denser bifurcation diagrams
SAVE_FIGS = true;        % save png, fig, and pdf files
OUTDIR = fullfile(pwd,'ASI_Figures');
if SAVE_FIGS && ~exist(OUTDIR,'dir')
    mkdir(OUTDIR);
end

rng(1);                  % fixed seed for reproducibility of noisy simulations

% Nominal parameter values
p.a = 0.9;
p.b = 0.2;
p.c = 1.5;
p.d = 0.2;
p.k = 0.17;

% Initial conditions
x0 = [1; 2; 0.5; 0.5];
x0_pert = [1; 2; 0.5; 0.50001];
master0 = [1; 2; 0.5; 0.5];
slave0  = [2.6; 5; 0.7; -0.85];

% Controller gains
Cabs = 6;
Ksfc = 3.5;

% Solver options
opts = odeset('RelTol',1e-9,'AbsTol',1e-12);

%% ----------------------- Figure 1: time series -----------------------
Tmain = [0 200];
sol = ode45(@(t,x) finance_rhs(t,x,p), Tmain, x0, opts);
t = linspace(Tmain(1),Tmain(2),6000);
X = deval(sol,t);

figure(1); clf;
plot(t,X(1,:),'LineWidth',1); hold on;
plot(t,X(2,:),'LineWidth',1);
plot(t,X(3,:),'LineWidth',1);
plot(t,X(4,:),'LineWidth',1);
xlabel('t'); ylabel('states');
legend('x','y','z','w','Location','best');
title('Time series of the unforced 4-D finance system'); grid on;
saveFig(gcf,OUTDIR,'Fig01_TimeSeries',SAVE_FIGS);

%% ----------------------- Figure 2: phase portraits -----------------------
idx = t >= 20;
Xt = X(:,idx);
figure(2); clf;
tiledlayout(2,2,'TileSpacing','compact','Padding','compact');
nexttile; plot3(Xt(1,:),Xt(2,:),Xt(3,:),'LineWidth',0.6); grid on; xlabel('x'); ylabel('y'); zlabel('z'); title('(x,y,z)');
nexttile; plot3(Xt(1,:),Xt(2,:),Xt(4,:),'LineWidth',0.6); grid on; xlabel('x'); ylabel('y'); zlabel('w'); title('(x,y,w)');
nexttile; plot3(Xt(1,:),Xt(3,:),Xt(4,:),'LineWidth',0.6); grid on; xlabel('x'); ylabel('z'); zlabel('w'); title('(x,z,w)');
nexttile; plot3(Xt(2,:),Xt(3,:),Xt(4,:),'LineWidth',0.6); grid on; xlabel('y'); ylabel('z'); zlabel('w'); title('(y,z,w)');
sgtitle('3-D projections of the 4-D hyperchaotic attractor');
saveFig(gcf,OUTDIR,'Fig02_PhasePortraits',SAVE_FIGS);

%% ----------------------- Figure 3: sensitivity -----------------------
sol1 = ode45(@(t,x) finance_rhs(t,x,p), Tmain, x0, opts);
sol2 = ode45(@(t,x) finance_rhs(t,x,p), Tmain, x0_pert, opts);
X1 = deval(sol1,t);
X2 = deval(sol2,t);

figure(3); clf;
plot(t,X1(1,:),'LineWidth',1); hold on;
plot(t,X2(1,:),'k--','LineWidth',1);
xlabel('t'); ylabel('x(t)');
legend('w(0)=0.5','w(0)=0.50001','Location','best');
title('Sensitivity to initial conditions'); grid on;
saveFig(gcf,OUTDIR,'Fig03_Sensitivity',SAVE_FIGS);

%% ----------------------- Figure 4: Lyapunov exponents -----------------------
if FAST_MODE
    Tlyap = 120; dtGS = 0.02; Tdiscard = 20;
else
    Tlyap = 250; dtGS = 0.01; Tdiscard = 20;
end
[stepNo, LErun, DKYrun, LEfinal, DKYfinal] = lyapunov_qr_finance(p,x0,Tlyap,dtGS,Tdiscard);
fprintf('Final Lyapunov exponents: %.7f %.7f %.7f %.7f\n',LEfinal);
fprintf('Final Kaplan-Yorke dimension: %.7f\n',DKYfinal);

figure(4); clf;
tiledlayout(2,1,'TileSpacing','compact','Padding','compact');
nexttile;
plot(stepNo,LErun,'LineWidth',1); grid on;
xlabel('QR reorthonormalization step'); ylabel('\lambda_i');
legend('\lambda_1','\lambda_2','\lambda_3','\lambda_4','Location','best');
title('Convergence of Lyapunov exponents');
nexttile;
plot(stepNo,DKYrun,'LineWidth',1); grid on;
xlabel('QR reorthonormalization step'); ylabel('D_{KY}');
title('Running Kaplan--Yorke dimension');
saveFig(gcf,OUTDIR,'Fig04_Lyapunov_DKY',SAVE_FIGS);

%% ----------------------- Figure 5: bifurcation diagrams -----------------------
if FAST_MODE
    vals.a = linspace(0.05,1.50,90);
    vals.b = linspace(0.05,0.60,90);
    vals.c = linspace(0.50,2.20,90);
    vals.d = linspace(0.05,1.00,90);
    vals.k = linspace(0.02,0.35,90);
    T_bif = 260; T_trans = 100; dt_bif = 0.05; n_keep = 250;
else
    vals.a = linspace(0.05,1.50,180);
    vals.b = linspace(0.05,0.60,180);
    vals.c = linspace(0.50,2.20,180);
    vals.d = linspace(0.05,1.00,180);
    vals.k = linspace(0.02,0.35,180);
    T_bif = 500; T_trans = 150; dt_bif = 0.03; n_keep = 1000;
end

fprintf('Computing bifurcation diagrams... This may take some time.\n');
B_a = bifurcation_scan('a',vals.a,p,x0,T_bif,T_trans,dt_bif,n_keep,opts);
B_b = bifurcation_scan('b',vals.b,p,x0,T_bif,T_trans,dt_bif,n_keep,opts);
B_c = bifurcation_scan('c',vals.c,p,x0,T_bif,T_trans,dt_bif,n_keep,opts);
B_d = bifurcation_scan('d',vals.d,p,x0,T_bif,T_trans,dt_bif,n_keep,opts);
B_k = bifurcation_scan('k',vals.k,p,x0,T_bif,T_trans,dt_bif,n_keep,opts);

figure(5); clf;
tiledlayout(3,2,'TileSpacing','compact','Padding','compact');
plotBifTile(B_a,'a');
plotBifTile(B_b,'b');
plotBifTile(B_c,'c');
plotBifTile(B_d,'d');
plotBifTile(B_k,'k');
sgtitle('Bifurcation diagrams via Poincare section w=0, \dot{w}>0');
saveFig(gcf,OUTDIR,'Fig05_BifurcationDiagrams',SAVE_FIGS);

%% ----------------------- Figure 6: enlarged bifurcations and trajectories -----------------------
figure(6); clf;
tiledlayout(2,2,'TileSpacing','compact','Padding','compact');
nexttile; scatter(B_a.param,B_a.xcross,3,'.'); grid on; xlabel('a'); ylabel('x at crossings'); title('Bifurcation in a');
nexttile; plot_phase_for_param('a',[0.9 1.4],p,x0,opts); title('Representative trajectories for a');
nexttile; scatter(B_b.param,B_b.xcross,3,'.'); grid on; xlabel('b'); ylabel('x at crossings'); title('Bifurcation in b');
nexttile; plot_phase_for_param('b',[0.10 0.25],p,x0,opts); title('Representative trajectories for b');
sgtitle('Enlarged bifurcation views and representative regimes');
saveFig(gcf,OUTDIR,'Fig06_BifurcationRepresentative',SAVE_FIGS);

%% ----------------------- Figures 7--8: synchronization before control -----------------------
y0_sync = [master0; slave0];
solUnc = ode45(@(t,y) sync_rhs_uncontrolled(t,y,p), [0 100], y0_sync, opts);
ts = linspace(0,100,5000);
Yunc = deval(solUnc,ts);
M = Yunc(1:4,:); S = Yunc(5:8,:); E = S-M;

figure(7); clf;
tiledlayout(2,2,'TileSpacing','compact','Padding','compact');
stateNames = {'x','y','z','w'};
for i=1:4
    nexttile;
    plot(ts,M(i,:),'LineWidth',1); hold on;
    plot(ts,S(i,:),'--','LineWidth',1);
    xlabel('t'); ylabel(stateNames{i}); grid on;
    title(sprintf('%s_1 and %s_2',stateNames{i},stateNames{i}));
    if i==1, legend('master','slave','Location','best'); end
end
sgtitle('Master and slave states before synchronization');
saveFig(gcf,OUTDIR,'Fig07_BeforeSynchronizationStates',SAVE_FIGS);

figure(8); clf;
plot(ts,E,'LineWidth',1); grid on;
xlabel('t'); ylabel('e_i(t)'); legend('e_1','e_2','e_3','e_4','Location','best');
title('Uncontrolled synchronization error components');
saveFig(gcf,OUTDIR,'Fig08_UncontrolledErrors',SAVE_FIGS);

%% ----------------------- Figure 9: ABS stabilization -----------------------
solABSstab = ode45(@(t,x) abs_stab_rhs(t,x,p,Cabs), [0 100], x0, opts);
tc = linspace(0,100,5000);
XabsStab = deval(solABSstab,tc);

figure(9); clf;
plot(tc,XabsStab,'LineWidth',1); grid on;
xlabel('t'); ylabel('states'); legend('x','y','z','w','Location','best');
title(sprintf('ABS stabilization, C=%g',Cabs));
saveFig(gcf,OUTDIR,'Fig09_ABS_Stabilization',SAVE_FIGS);

%% ----------------------- Figure 10: SFC stabilization -----------------------
% Shifted initial condition around P0=(0,1/b,0,0)
X0sfc = [x0(1); x0(2)-1/p.b; x0(3); x0(4)];
solSFC = ode45(@(t,Xs) sfc_rhs(t,Xs,p,Ksfc), [0 100], X0sfc, opts);
Xsfc = deval(solSFC,tc);

figure(10); clf;
plot(tc,Xsfc,'LineWidth',1); grid on;
xlabel('t'); ylabel('shifted states'); legend('X','Y','Z','W','Location','best');
title(sprintf('SFC stabilization at P_0, K=%g',Ksfc));
saveFig(gcf,OUTDIR,'Fig10_SFC_Stabilization',SAVE_FIGS);

%% ----------------------- Figures 11--13: ABS synchronization -----------------------
solABSsync = ode45(@(t,y) sync_rhs_abs(t,y,p,p,Cabs,false,[],0), [0 100], y0_sync, opts);
Yabs = deval(solABSsync,ts);
Mabs = Yabs(1:4,:); Sabs = Yabs(5:8,:); Eabs = Sabs-Mabs;

figure(11); clf;
tiledlayout(2,2,'TileSpacing','compact','Padding','compact');
for i=1:4
    nexttile;
    plot(ts,Mabs(i,:),'LineWidth',1); hold on;
    plot(ts,Sabs(i,:),'--','LineWidth',1);
    xlabel('t'); ylabel(stateNames{i}); grid on;
    title(sprintf('%s_1 vs %s_2',stateNames{i},stateNames{i}));
    if i==1, legend('master','slave','Location','best'); end
end
sgtitle('ABS synchronization: aligned states');
saveFig(gcf,OUTDIR,'Fig11_ABS_SyncStates',SAVE_FIGS);

figure(12); clf;
plot(ts,Eabs,'LineWidth',1); grid on;
xlabel('t'); ylabel('e_i(t)'); legend('e_1','e_2','e_3','e_4','Location','best');
title('ABS synchronization: error components');
saveFig(gcf,OUTDIR,'Fig12_ABS_SyncErrors',SAVE_FIGS);

figure(13); clf;
plot(ts,vecnorm(Eabs,2,1),'LineWidth',1.2); grid on;
xlabel('t'); ylabel('||e(t)||_2');
title('ABS synchronization: average/error norm');
saveFig(gcf,OUTDIR,'Fig13_ABS_AverageError',SAVE_FIGS);

%% ----------------------- Figures 14--16: AC synchronization -----------------------
solACsync = ode45(@(t,y) sync_rhs_ac(t,y,p,p,false,[],0), [0 100], y0_sync, opts);
Yac = deval(solACsync,ts);
Mac = Yac(1:4,:); Sac = Yac(5:8,:); Eac = Sac-Mac;
Uac = compute_controls_ac(Yac,p);

figure(14); clf;
plot(ts,Eac,'LineWidth',1); grid on;
xlabel('t'); ylabel('e_i(t)'); legend('e_1','e_2','e_3','e_4','Location','best');
title('AC synchronization: error components');
saveFig(gcf,OUTDIR,'Fig14_AC_SyncErrors',SAVE_FIGS);

figure(15); clf;
tiledlayout(2,2,'TileSpacing','compact','Padding','compact');
for i=1:4
    nexttile;
    plot(ts,Mac(i,:),'LineWidth',1); hold on;
    plot(ts,Sac(i,:),'--','LineWidth',1);
    xlabel('t'); ylabel(stateNames{i}); grid on;
    title(sprintf('%s_1 vs %s_2',stateNames{i},stateNames{i}));
    if i==1, legend('master','slave','Location','best'); end
end
sgtitle('AC synchronization: aligned states');
saveFig(gcf,OUTDIR,'Fig15_AC_SyncStates',SAVE_FIGS);

figure(16); clf;
plot(ts,Uac,'LineWidth',1); grid on;
xlabel('t'); ylabel('u_i(t)'); legend('u_1','u_2','u_3','u_4','Location','best');
title('AC synchronization: control inputs');
saveFig(gcf,OUTDIR,'Fig16_AC_ControlInputs',SAVE_FIGS);

%% ----------------------- Figures 17--18: robustness -----------------------
sigmaNoise = 1e-3;
% Example response-system parameter mismatch: alternating +/-10%.
pSlave = p;
pSlave.a = 1.10*p.a; pSlave.b = 0.90*p.b; pSlave.c = 1.10*p.c; pSlave.d = 0.90*p.d; pSlave.k = 1.10*p.k;

% Precompute measurement noise on a grid and interpolate inside the RHS.
tNoise = linspace(0,100,20001);
noiseABS = randn(8,numel(tNoise));
noiseAC  = randn(8,numel(tNoise));

solABSrob = ode45(@(t,y) sync_rhs_abs(t,y,p,pSlave,Cabs,true,struct('t',tNoise,'eta',noiseABS),sigmaNoise), [0 100], y0_sync, opts);
solACrob  = ode45(@(t,y) sync_rhs_ac(t,y,p,pSlave,true,struct('t',tNoise,'eta',noiseAC),sigmaNoise), [0 100], y0_sync, opts);
YabsRob = deval(solABSrob,ts);
YacRob  = deval(solACrob,ts);
EabsRob = YabsRob(5:8,:)-YabsRob(1:4,:);
EacRob  = YacRob(5:8,:)-YacRob(1:4,:);
UabsRob = compute_controls_abs(YabsRob,p,Cabs);
UacRob  = compute_controls_ac(YacRob,p);

figure(17); clf;
semilogy(ts,vecnorm(EabsRob,2,1),'LineWidth',1.2); hold on;
semilogy(ts,vecnorm(EacRob,2,1),'LineWidth',1.2);
grid on; xlabel('t'); ylabel('||e(t)||_2');
legend('ABS','AC','Location','best');
title('Robust synchronization under +/-10% mismatch and measurement noise');
saveFig(gcf,OUTDIR,'Fig17_Robust_ErrorNorm',SAVE_FIGS);

figure(18); clf;
plot(ts,vecnorm(UabsRob,2,1),'LineWidth',1.2); hold on;
plot(ts,vecnorm(UacRob,2,1),'LineWidth',1.2);
grid on; xlabel('t'); ylabel('||u(t)||_2');
legend('ABS','AC','Location','best');
title('Robust synchronization: control effort');
saveFig(gcf,OUTDIR,'Fig18_Robust_ControlEffort',SAVE_FIGS);

%% ----------------------- Summary metrics -----------------------
fprintf('\nScript finished. Figures saved in: %s\n',OUTDIR);

% Optional: print basic actuator peak/RMS values for nominal synchronization
Uabs = compute_controls_abs(Yabs,p,Cabs);
peakABS = max(abs(Uabs),[],2); rmsABS = sqrt(mean(Uabs.^2,2));
peakAC = max(abs(Uac),[],2);  rmsAC  = sqrt(mean(Uac.^2,2));
fprintf('\nNominal synchronization actuator metrics:\n');
fprintf('ABS peak: %.4g %.4g %.4g %.4g\n',peakABS);
fprintf('ABS RMS : %.4g %.4g %.4g %.4g\n',rmsABS);
fprintf('AC  peak: %.4g %.4g %.4g %.4g\n',peakAC);
fprintf('AC  RMS : %.4g %.4g %.4g %.4g\n',rmsAC);

%% =======================================================================
%                          Local functions
% =======================================================================

function dx = finance_rhs(~,x,p)
    dx = zeros(4,1);
    dx(1) = x(3) + (x(2)-p.a)*x(1) + x(4);
    dx(2) = 1 - p.b*x(2) - x(1)^2;
    dx(3) = -x(1) - p.c*x(3);
    dx(4) = -p.d*x(1)*x(2) - p.k*x(4);
end

function J = finance_jacobian(x,p)
    J = [x(2)-p.a, x(1), 1, 1;
         -2*x(1), -p.b, 0, 0;
         -1, 0, -p.c, 0;
         -p.d*x(2), -p.d*x(1), 0, -p.k];
end

function dx = abs_stab_rhs(~,x,p,C)
    phi4 = 3*x(1) + 5*x(2) + 3*x(3) + x(4);
    v = -(5*x(1) + 10*x(2) + 9*x(3) + 4*x(4)) - C*phi4;
    % Under the static prefeedback, the closed loop is the integrator chain.
    dx = [x(2); x(3); x(4); v];
    % Equivalently, finance_rhs + the four ABS control inputs gives this dx.
end

function dX = sfc_rhs(~,X,p,K)
    % Shifted variables X=(X,Y,Z,W), where Y = y - 1/b.
    Xv = X(1); Yv = X(2); Zv = X(3); Wv = X(4);
    Xdot = Zv + (Yv + 1/p.b - p.a)*Xv + Wv;
    Ydot = -p.b*Yv - Xv^2;
    Zdot = -Xv - p.c*Zv;
    Wdot = -(p.d/p.b)*Xv - p.d*Xv*Yv - p.k*Wv - K*Xdot;
    dX = [Xdot; Ydot; Zdot; Wdot];
end

function dy = sync_rhs_uncontrolled(~,y,p)
    m = y(1:4);
    s = y(5:8);
    dy = [finance_rhs(0,m,p); finance_rhs(0,s,p)];
end

function dy = sync_rhs_abs(t,y,pMaster,pSlave,C,useNoise,noiseData,sigma)
    mTrue = y(1:4);
    sTrue = y(5:8);
    if useNoise
        eta = interp1(noiseData.t',noiseData.eta',t,'linear','extrap')';
        m = mTrue + sigma*eta(1:4);
        s = sTrue + sigma*eta(5:8);
    else
        m = mTrue;
        s = sTrue;
    end
    e = s - m;
    phi4 = 3*e(1) + 5*e(2) + 3*e(3) + e(4);
    u = zeros(4,1);
    u(1) = pMaster.a*e(1) + e(2) - e(3) - e(4) - s(2)*s(1) + m(2)*m(1);
    u(2) = pMaster.b*e(2) + (m(1)+s(1))*e(1) + e(3);
    u(3) = e(1) + pMaster.c*e(3) + e(4);
    u(4) = -pMaster.d*m(2)*m(1) + pMaster.d*s(2)*s(1) + pMaster.k*e(4) ...
           - 5*e(1) - 10*e(2) - 9*e(3) - 4*e(4) - C*phi4;
    dm = finance_rhs(t,mTrue,pMaster);
    ds = finance_rhs(t,sTrue,pSlave) + u;
    dy = [dm; ds];
end

function dy = sync_rhs_ac(t,y,pMaster,pSlave,useNoise,noiseData,sigma)
    mTrue = y(1:4);
    sTrue = y(5:8);
    if useNoise
        eta = interp1(noiseData.t',noiseData.eta',t,'linear','extrap')';
        m = mTrue + sigma*eta(1:4);
        s = sTrue + sigma*eta(5:8);
    else
        m = mTrue;
        s = sTrue;
    end
    e = s - m;
    u = zeros(4,1);
    u(1) = (pMaster.a-1)*e(1) - e(3) - e(4) - s(2)*s(1) + m(2)*m(1);
    u(2) = (m(1)+s(1))*e(1) + (pMaster.b-1)*e(2);
    u(3) = e(1) + (pMaster.c-1)*e(3);
    u(4) = -pMaster.d*m(2)*m(1) + pMaster.d*s(2)*s(1) + (pMaster.k-1)*e(4);
    dm = finance_rhs(t,mTrue,pMaster);
    ds = finance_rhs(t,sTrue,pSlave) + u;
    dy = [dm; ds];
end

function U = compute_controls_abs(Y,p,C)
    n = size(Y,2); U = zeros(4,n);
    for j=1:n
        m = Y(1:4,j); s = Y(5:8,j); e = s-m;
        phi4 = 3*e(1) + 5*e(2) + 3*e(3) + e(4);
        U(1,j) = p.a*e(1) + e(2) - e(3) - e(4) - s(2)*s(1) + m(2)*m(1);
        U(2,j) = p.b*e(2) + (m(1)+s(1))*e(1) + e(3);
        U(3,j) = e(1) + p.c*e(3) + e(4);
        U(4,j) = -p.d*m(2)*m(1) + p.d*s(2)*s(1) + p.k*e(4) ...
                 - 5*e(1) - 10*e(2) - 9*e(3) - 4*e(4) - C*phi4;
    end
end

function U = compute_controls_ac(Y,p)
    n = size(Y,2); U = zeros(4,n);
    for j=1:n
        m = Y(1:4,j); s = Y(5:8,j); e = s-m;
        U(1,j) = (p.a-1)*e(1) - e(3) - e(4) - s(2)*s(1) + m(2)*m(1);
        U(2,j) = (m(1)+s(1))*e(1) + (p.b-1)*e(2);
        U(3,j) = e(1) + (p.c-1)*e(3);
        U(4,j) = -p.d*m(2)*m(1) + p.d*s(2)*s(1) + (p.k-1)*e(4);
    end
end

function [steps, LErun, DKYrun, LEfinal, DKYfinal] = lyapunov_qr_finance(p,x0,Tmax,h,Tdiscard)
    n = 4;
    x = x0(:);
    Q = eye(n);
    t = 0;
    sumLog = zeros(n,1);
    count = 0;
    LErun = [];
    DKYrun = [];
    steps = [];
    N = round(Tmax/h);
    Ndiscard = round(Tdiscard/h);
    for kstep = 1:N
        Y = [x; Q(:)];
        Y = rk4_aug_step(Y,h,p);
        x = Y(1:n);
        Q = reshape(Y(n+1:end),n,n);
        [Q,R] = qr(Q,0);
        diagR = diag(R);
        % Avoid sign ambiguity in QR
        sgn = sign(diagR); sgn(sgn==0)=1;
        Q = Q*diag(sgn);
        diagR = diagR.*sgn;
        t = t + h;
        if kstep > Ndiscard
            sumLog = sumLog + log(abs(diagR));
            count = count + 1;
            le = sumLog/(count*h);
            LErun(:,end+1) = le; %#ok<AGROW>
            DKYrun(end+1) = kaplan_yorke(le); %#ok<AGROW>
            steps(end+1) = count; %#ok<AGROW>
        end
    end
    LEfinal = LErun(:,end);
    DKYfinal = DKYrun(end);
end

function Ynew = rk4_aug_step(Y,h,p)
    k1 = aug_rhs(Y,p);
    k2 = aug_rhs(Y + 0.5*h*k1,p);
    k3 = aug_rhs(Y + 0.5*h*k2,p);
    k4 = aug_rhs(Y + h*k3,p);
    Ynew = Y + (h/6)*(k1 + 2*k2 + 2*k3 + k4);
end

function dY = aug_rhs(Y,p)
    n = 4;
    x = Y(1:n);
    M = reshape(Y(n+1:end),n,n);
    dx = finance_rhs(0,x,p);
    J = finance_jacobian(x,p);
    dM = J*M;
    dY = [dx; dM(:)];
end

function DKY = kaplan_yorke(LE)
    LE = sort(LE(:),'descend');
    s = cumsum(LE);
    j = find(s >= 0,1,'last');
    if isempty(j)
        DKY = 0;
    elseif j >= length(LE)
        DKY = length(LE);
    else
        DKY = j + s(j)/abs(LE(j+1));
    end
end

function B = bifurcation_scan(paramName,paramVals,p0,x0,Tend,Ttrans,dt,nKeep,opts)
    P = [];
    Xc = [];
    for i=1:numel(paramVals)
        p = p0;
        p.(paramName) = paramVals(i);
        try
            sol = ode45(@(t,x) finance_rhs(t,x,p), [0 Tend], x0, opts);
            tg = Ttrans:dt:Tend;
            X = deval(sol,tg);
            w = X(4,:);
            x = X(1,:);
            crosses = [];
            for j=1:(numel(tg)-1)
                if w(j) < 0 && w(j+1) >= 0
                    alpha = -w(j)/(w(j+1)-w(j)+eps);
                    xcross = x(j) + alpha*(x(j+1)-x(j));
                    crosses(end+1) = xcross; %#ok<AGROW>
                end
            end
            if numel(crosses) > nKeep
                crosses = crosses(end-nKeep+1:end);
            end
            P = [P; paramVals(i)*ones(numel(crosses),1)]; %#ok<AGROW>
            Xc = [Xc; crosses(:)]; %#ok<AGROW>
        catch ME
            warning('Bifurcation scan failed for %s=%g: %s',paramName,paramVals(i),ME.message);
        end
    end
    B.param = P;
    B.xcross = Xc;
end

function plotBifTile(B,label)
    nexttile;
    scatter(B.param,B.xcross,3,'.'); grid on;
    xlabel(label); ylabel('x at crossings'); title(sprintf('parameter %s',label));
end

function plot_phase_for_param(paramName,paramVals,p0,x0,opts)
    hold on; grid on;
    colors = lines(numel(paramVals));
    for i=1:numel(paramVals)
        p = p0; p.(paramName) = paramVals(i);
        sol = ode45(@(t,x) finance_rhs(t,x,p), [0 180], x0, opts);
        tg = linspace(60,180,3000);
        X = deval(sol,tg);
        plot(X(4,:),X(1,:),'LineWidth',0.8,'Color',colors(i,:));
    end
    xlabel('w'); ylabel('x');
    legend(arrayfun(@(v) sprintf('%s=%.3g',paramName,v),paramVals,'UniformOutput',false),'Location','best');
end

function saveFig(figHandle,outdir,name,doSave)
    if ~doSave, return; end
    set(figHandle,'Color','w');
    try
        exportgraphics(figHandle,fullfile(outdir,[name '.png']),'Resolution',300);
        exportgraphics(figHandle,fullfile(outdir,[name '.pdf']),'ContentType','vector');
    catch
        print(figHandle,fullfile(outdir,[name '.png']),'-dpng','-r300');
        print(figHandle,fullfile(outdir,[name '.pdf']),'-dpdf','-bestfit');
    end
    try
        savefig(figHandle,fullfile(outdir,[name '.fig']));
    catch
        % savefig not available in very old MATLAB versions
    end
end
