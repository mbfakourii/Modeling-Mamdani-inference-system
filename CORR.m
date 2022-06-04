function [out] = CORR(x1,x2,y,yyhat,avrage_y,avrage_yhat)
    sigma1=0;
    sigma2=0;
    sigma3=0;
    
    for i=1:length(x1')
        for j=1:length(x2)
          sigma1=sigma1 + ((y(j,i)-avrage_y)*(yyhat(j,i)-avrage_yhat));
          sigma2=sigma2 + (y(j,i)-avrage_y)^2;
          sigma3=sigma3 + (yyhat(j,i)-avrage_yhat)^2;
        end
    end
    
    
    down_sigmas=sqrt(sigma2*sigma3);
    
    out=sigma1/down_sigmas;
end