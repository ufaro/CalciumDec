function out = filter_boundary(fil_num,fil_den,in,condition)

% This function filters the input with the filter constructed for
% differential operator L.

%%%% INPUTS %%%%%
% fil_num, fil_den is achieved from 'hrf_filters' function.
%
% fil_num = numerator part, finite length filtering (FIR)
% fil_den = denominator part, infinte length filtering (IIR) causal or
% uncausal
% in = input
% condition = normal/transpose (if we apply the filter to the time inversed version of the signal x(-t).
% Corresponds to the conjugate transpose)
%%%%%%%

% ZERO BOUNDARY CONDITIONS

% REMINDERS:
% causal filter : first column of fil_den
% non-causal filter :second column of fil_den
% Don't need to flip the signal in 'transpose' condition with the FIR filter. Because
% the filter coefficients are already flipped by default.
% i.e., (filter_boundary(fliplr(n),d,s,'transpose'))


%%% NOTE ON 'transpose'; 04.04.2011 
%%% old version = filter_boundary(fliplr(n),d,s,'transpose') 
%%% new version = filter_boundary(n,d,s,'transpose')
%%%%%%%%%%%%%%%%%

% if(strcmpi(condition,'transpose'))
%     fil_num = conj(fil_num);
%     fil_den = conj(fil_den);
% end


%% OLD VERSION
% shift = floor(length(fil_num)/2);
% in = [flipud(in(2:shift+1+5)); in; flipud(in(end-shift-5:end-1))]; % mirror
% boundary condition

% in = [(zeros(shift+5,1)); in; (zeros(shift+5,1))];%zero boundary
% out_full = filter(fil_num,1,in);
% if( (strcmpi(condition,'transpose')) && (mod(length(fil_num),2) == 0) )
%     out = out_full(shift*2+5:end-1-5);
% else
%     out = out_full(shift*2+1+5:end-5);
% end

%% NEW VERSION - transpose and zero boundary

if strcmpi(condition,'transpose')
    out = flipud(filter(fil_num,1,flipud(in)));
else
    out = filter(fil_num,1,in);
end
% out = out_full(shift+5+1:end-shift-5);


% denominator
if(length(fil_den)==2)
    causal = fil_den{1}; %causal part
    non_causal = fil_den{2};  %noncausal part
    %     disp('in1')
    if (length(causal)+length(non_causal)>2) % min(length(causal,noncausal)) =1, so if sum less than 2, no need to filter.
        %     if (length(non_causal)>1) (does not enter the loop)
        shiftnc = (length(non_causal)-1);
        out = [zeros(shiftnc,1);out;zeros(shiftnc,1)]; %zero boundary
        %         out = [flipud(out(2:shiftnc+1));out;flipud(in(end-shiftnc:end-1))]; % mirror boundary
        %         disp('in2')
        if(strcmpi(condition,'normal'))
            out = filter(1,causal,out); %causal
            out = flipud(filter(1,non_causal,flipud(out)))*(non_causal(end)); %ncausal
            out = out(2*shiftnc+1:end);
            %             disp('in3')
        elseif(strcmpi(condition,'transpose'));
            out = flipud(filter(1,causal,flipud(out)));
            out = filter(1,non_causal,out)*(non_causal(end));
            out = out(1:end-2*shiftnc);
            %             disp('in4')
        end
    end
end
% normalize
% out = out./filternorm(fil_num,fil_den{1},2);
end
