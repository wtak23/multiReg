%% may28_synthetic_data.m 
% (05/28/2014)
%=========================================================================%
% - create synthetic dataset for regression
% - use synthetic data to test my ADMM elastic-net alg
%=========================================================================%
%%
clear all
purge
load('Results_tak.mat', 'ConnMean', 'ConnVar')
load('graph_info347_2d.mat', 'coord','adjmat')
load('sim_anom_node_info_8nn.mat', 'anom_nodes')
%% set options
% set SNR devel (same as cohen's d) http://en.wikipedia.org/wiki/Cohen%27s_d#Cohen.27s_d 
% http://www.3rs-reduction.co.uk/html/6__power_and_sample_size.html
ntr = 1000;
nts = 250;

p = nchoosek(coord.num_nodes,2);
%% create dataset
% randn('seed',0)
%=========================================================================%
% create design matrix
%=========================================================================%
Xtr = randn(ntr,p);
Xts = randn(nts,p);

%=========================================================================%
% create ground truth weight vector
%=========================================================================%
wtrue = zeros(p,1);
wtrue(anom_nodes.idx_conn)= 1 + rand(size(anom_nodes.idx_conn));
% w= 10 + rand(p,1);

% normalize weight vector
% w=w/norm(w);
% norm(w)
% return

% figure,imexpb
% subplot(121),tplot(w)
% subplot(122),imcov(tak_dvecinv(w,0))
% return

%=========================================================================%
% additive noise model
%=========================================================================%
snr=0;
ytr = Xtr*wtrue + snr*randn(ntr,1);
yts = Xts*wtrue + snr*randn(nts,1);

%% apply regression
%=========================================================================%
% set options
%=========================================================================%
% options.lambda=0; % L1 penalty weight
% options.gamma =5; % L2 penalty weight

options.lambda=2^-5; % L1 penalty weight
options.gamma =2^-5; % L2 penalty weight

%% set algorithm options (this block doesn't need to be touched)
options.rho=1; % augmented lagrangian parameters

% termination criterion
options.termin.maxiter = 500;   % <- maximum number of iterations
options.termin.tol = 1e-8;      % <- relative change in the primal variable
options.termin.progress = 500;   % <- display "progress" (every k iterations...set to inf to disable)
options.termin.silence = false; % <- display termination condition

tic
output=tak_admm_enet_regr(Xtr,ytr,options,wtrue);
toc
fval1=output.fval(1)
fval_end=output.fval(end)
% [norm(ytr)^2,norm(ytr-Xtr*output.w)^2]
%%
west=output.w;
purge
nnz(west)
figure,imexpb
subplot(131),tplot(log10(output.fval)), title('log10(function value)')
subplot(132),tplot(log10(output.wdist)), title('log10(||wtrue-west||)')
subplot(133),tplot(log10(output.rel_changevec)), title('log10(wnew-wold)')

figure,imexpb
subplot(131),imcov(tak_dvecinv(wtrue,0)); title(['wtrue (nnz=',num2str(nnz(wtrue)),')'])
subplot(132),imcov(tak_dvecinv(west,0));  title(['west (nnz=',num2str(nnz(west)),')'])
subplot(133),imcov(tak_dvecinv(west,0)~=0);  title(['west (support)'])

figure,imexpb
subplot(141),tplot(wtrue)
subplot(142),tplot(west)
subplot(143),tplot2(wtrue,west), legend('wtrue','west'),title('')
subplot(144),tplot(abs(wtrue-west)),title('|wtrue-west|')
% tplottl(abs(w+output.v))
drawnow