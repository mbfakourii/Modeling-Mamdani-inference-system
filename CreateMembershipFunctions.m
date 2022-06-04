function out=CreateMembershipFunctions(x,n,Type)

    if nargin<3
        Type='';
    end
    
    if isempty(Type)
        Type='trimf';
    end

    xmin=min(x);
    xmax=max(x);
    
    a=linspace(xmin,xmax,n);
    
    out=cell(n,2);
    
    Type=lower(Type);
    
    switch Type
        case 'trimf'
            dx=(xmax-xmin)/(n-1);
            for i=1:n
                out{i,1}=Type;
                out{i,2}=a(i) + [-dx 0 +dx];
            end
            
        case 'gaussmf'
            sigma=0.5*(xmax-xmin)/(n-1);
            for i=1:n
                out{i,1}=Type;
                out{i,2}=[sigma a(i)];
            end
            
    end
    
end