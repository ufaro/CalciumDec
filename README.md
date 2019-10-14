# CalciumDec

% Calcium Deconvolution with Spike and Block models .
% By Younes Farouj (MIPLAB, EPFL) accompanying the paper:

% Younes Farouj, F.Isik Karahanoglu, Dimitri Van De Ville 
% "Deconvolution of Sustained Neural Activity from
%Large-Scale Calcium Imaging Data", IEEE Transactions on Medical Imaging, 2019


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
