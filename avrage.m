function [avrage] = avrage(x1,x2,y)
    total=0;
    size=0;
    
    for i=1:length(x1')
        for j=1:length(x2)
            total=total+y(j,i);
            size=size+1;
        end
    end
    
    avrage=total/size;
end