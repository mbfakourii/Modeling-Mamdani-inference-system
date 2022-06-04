function [out] = FVU(x1,x2,y,yyhat,avrage)
    sigma1=0;
    sigma2=0;
    
    for i=1:length(x1')
        for j=1:length(x2)
          sigma1=sigma1 + (yyhat(j,i) - y(j,i))^2;
          sigma2=sigma2 + (y(j,i) - avrage)^2;
        end
    end
    
    out=sigma1/sigma2;
end