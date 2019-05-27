function [Denoised,Deconvolved] = CalDeconv(Fluo,fpsec,rise,decay,typ)

% Calcium Deconvolution with Spike and Block models .
% By Younes Farouj (MIPLAB, EPFL) accompanying the paper:

% Younes Farouj, F.Isik Karahanoglu, Dimitri Van De Ville 
% "Deconvolution of Sustained Neural Activity from
%Large-Scale Calcium Imaging Data"


% INPUT
%   Fluo -  Raw Fluorescence trace (matrix: cells x time)
%   fpsec - frame per second (aquisition rate in Hz)
%   rise - rise time of the Calcium indicator (seconds)
%   decay - decay time of the Calcium indicator (seconds)
%   typ - hypothesized activity model: 'block' or 'spike'

% OUTPUT
%   Denoised: filtered signal
%   Deconvolved: filtered signal + undone from calcium dynamics
% 

%%  parameters for the algorithm (can be changed by user)

nb_temp_iter=20000;   % maximum iterations number for forward-backward 
                      % minimization
                      
lam0 =1.1;            % weight of the regulrization parameter


% filter taps for Daubechies wavelet (used if wavelet toolbox is not available)
g=[0    -0.12941    -0.22414     0.83652    -0.48296]';

nor = 1/.6745;     %   ki factor for (unbiased) estimation of noise level (normal dist) 


%%

N=size(Fluo,1);  % number of cells
T=size(Fluo,2);   % number of time points

TR   = 1/fpsec;    % fpsec to time-resolution
tau1 = 1/rise;     % exponential const 1
tau2 = 1/decay;    % exponential const 2


if(strcmpi(typ,'spike') ||strcmpi(typ,'block') )
[filter_analyze,filter_reconstruct,maxeig] = zp2taps(TR,typ,[],[-tau1 -tau2]);
else
    error('Unknown type of condition: Should be "spike" for spikes or "block" for blocks')
end  


Denoised = zeros(N,T);
Deconvolved = zeros(N,T);


for t=1:N

noisy_sig = Fluo(N,:)';
    
  

[coef,len] = wavedec(noisy_sig',1,'db6'); % using wavedec is faster
coef(1:len(1)) = [];

%coef=cconv(noisy_sig,g);   % if wavelet toolbox is not available use cconv

lambda = mad(coef,1)*nor;
lambda=lam0*lambda;

Denoised(N,:) = fgp_general_chambole(noisy_sig,filter_analyze.num,lambda,nb_temp_iter,maxeig,filter_analyze.den,0,lambda);
Deconvolved(N,:) = filter_boundary(filter_reconstruct.num,filter_reconstruct.den,Denoised(N,:),'normal');   
    

end




end
