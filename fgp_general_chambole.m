function [x,nv,J,lambda] = fgp_general_chambole(y,n,lambda,Nit,maxeig,d,p_fig,noise_estimate)
% Fast Gradient Projection for Generalized TV.
% By F. Isik Karahanoglu (MIPLAB, EPFL) for the paper

% F.Isik Karahanoglu, Ilker Bayram, Dimitri Van De Ville 
% "A Signal Processing Approach to Generalized 1D Total Variation"
% IEEE Transactions on Signal Processing 59(11): 5265-5274 (2011)



% Total variation filtering (denoising)
% INPUT
%   y - noisy signal (row vector)
%   n - filter taps (numerator- NOT TRANSPOSE)
%   d - filter taps (denominator)
%   lambda - regularization parameter
%   Nit - Number of iterations
%   p_fig - Plot -- takes some time...
% OUTPUT
%   x - result of denoising
%   J - objective function
% 

% Younes: Chambole stopping criterion (Feb,2018)

stop_cri = 10^(-6); %stopping criterion

if(nargin == 5) %no denominator
    d=1;
end


N = length(y);
z = zeros(N,1);
k = 1;
t = 1;
s = zeros(N,1);

J = zeros(Nit,1);

precision = 1000000;


nv = zeros(Nit,1);
Lambda = zeros(Nit,1);
precision = noise_estimate/precision;
%precision = noise_estimate;


while (k <= Nit)
    z_l = z;
    z = 1/(lambda*maxeig)*filter_boundary(n,d,y,'normal') + s - filter_boundary(n,d,filter_boundary(n,d,s,'transpose'),'normal')/maxeig;
    % clipping
    z = max(min(z,1),-1);             
    t_l = t;
    t = (1+sqrt(1+4*(t^2)))/2;
    s = z + (t_l - 1)/t*(z-z_l);  
    x = y - (lambda)*filter_boundary(n,d,z,'transpose'); % update x
    J(k) = sum(abs(x-y).^2) + lambda*sum(abs(filter_boundary(n,d,x,'normal')));
    nv(k) = sqrt(sum((x-y).^2)/N);

  if(p_fig==1),figure(101);plot(y,'-g');hold on;plot(x,'-r');pause(0.2);hold off;end
     if((k > 3) && (abs(J(k-1)-J(k-2)) < stop_cri)) % stopping criterion 
         k
         break;
     end

% 
   if(abs(nv(k) - noise_estimate)>precision);
         lambda = lambda*noise_estimate/nv(k);
        
   end
%     
    Lambda(k) = lambda;
    
     k=k+1;

end
     x = y - (lambda)*filter_boundary(n,d,z,'transpose'); % update x
end



        



    