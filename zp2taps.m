function [filter_analyze,filter_reconstruct,maxeig] = zp2taps(TR,condition,P,Z)

% computes inverse filter taps from poles and zeros


% INPUT
%   TR -  time-resolution
%   condition - 'spike': the sparsifying operator does not involve derivation
%             - 'block': the sparsifying operator involves an additional derivative
%   P         - poles vector
%   Z         - zeros vector

% OUTPUT
%   filter_analyze: sparsifying operator
%   filter_analyze: inverse operator
%   maxeig         : largest eigenvalue of the sparsifying operator


FilPoles = P*TR;
FilZeros = Z*TR;



cons=1;
hnum = cons_filter(FilZeros)*cons;
hden = cons_filter(FilPoles);

% second order approximation
%     cons=1/(norm((3/2-2*exp(a1*TR)+exp(2*a1*TR)/2)*(3/2-2*exp(a2*TR)+exp(2*a2*TR)/2)*(3/2-2*exp(a3*TR)+exp(2*a3*TR)/2)*(3/2-2*exp(a4*TR)+exp(2*a4*TR)/2)/(3/2-2*exp(psi*TR)+exp(2*psi*TR)/2))/norm(a1*a2*a3*a4/psi)); % first order
%     hnum = cons_filter2(FilZeros)*cons;
%    hden = cons_filter2(FilPoles);


causal = FilPoles(real(FilPoles)<0);
n_causal = FilPoles(real(FilPoles)>0);

% Shortest Filter, 1st order approximation
h_dc = cons_filter(causal);
h_dnc = cons_filter(n_causal);
%     % second order approximation
%     h_dc = cons_filter2(causal);
%     h_dnc = cons_filter2(n_causal);

h_d{1} = h_dc;
h_d{2} = h_dnc;

filter_reconstruct.num = hnum;
filter_reconstruct.den = h_d;


if( strcmpi(condition,'spike'))
    % if spike both filters are the same
    
    [d1,d2] = freqz(hnum,hden,1024);
    maxeig = max(abs(d1).^2);
    filter_analyze = filter_reconstruct;
    
elseif(strcmpi(condition,'block'))
    FilZeros2 = [FilZeros,0];
    
    %     hnum2 = cons_filter(FilZeros2)*cons*2*sqrt(2);
    
    % Shortest Filter, 1st order approximation
    hnum2 = cons_filter(FilZeros2)*cons;
    % second order approximation
    %         hnum2 = cons_filter2(FilZeros2)*cons;
    
    [d1,d2] = freqz(hnum2,hden,1024);
    maxeig = max(abs(d1).^2);
    
    filter_analyze.num = hnum2;
    filter_analyze.den = h_d;
    
else
    error('Unknown type of condition: Should be "SPIKE" or "BLOCK"')
end

% maxeig = maxeig./filternorm(hnum,h_d{1},2)^2;