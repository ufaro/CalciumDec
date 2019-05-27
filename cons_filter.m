function fil = cons_filter(root)
% construct filter, possible combinations of zeros/poles
% roots are the zeros/poles
% 20.12.2010

n=length(root);
fil = zeros(1,n+1);
fil(1)=1;
    for i = 1:n;
        fil(i+1) = (-1)^i*sum(exp(sum(nchoosek(root,i),2)));
    end

end