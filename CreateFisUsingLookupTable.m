function fis=CreateFisUsingLookupTable(data,nmf,mftype)

    P=size(data,1);     % Total Number of Data Records

    x=data(:,1:end-1);  % Input Data
    nx=size(x,2);
    
    y=data(:,end);      % Target Data
    
    %% Check Input Arguments
    
    if nargin<2 || isempty(nmf)
        nmf=3*ones(1,nx+1);
    end
    
    if nargin<3 || isempty(mftype)
        mftype=cell(1,nx+1);
        for i=1:nx+1
            mftype{i}='gaussmf';
        end
    end
    
    %% 1: Create MFs
    
    A=cell(nx,1);
    for i=1:nx
        A{i}=CreateMembershipFunctions(x(:,i),nmf(i),mftype{i});
    end

    B=CreateMembershipFunctions(y,nmf(end),mftype{end});
    
    %% 2: Create Rules Matrix
    
    if nx>1
        SSize=nmf(1:end-1);
    else
        SSize=[nmf(1) 1];
    end
    S=cell(SSize);
    S=S(:);
    
    nRules=numel(S);
    for r=1:nRules
        S{r}=zeros(1,nmf(end));
    end

    %% 3: Calculate Score of Rules
    
    XIND=zeros(nRules,nx);
    
    for r=1:nRules
        
        xind=cell(1,nx);
        [xind{1:nx}]=ind2sub(SSize,r);
        xind=cell2mat(xind);
        
        XIND(r,:)=xind;
        
        for yind=1:nmf(end)
            
            bmf=B{yind,1};
            bparam=B{yind,2};
            
            s=zeros(1,P);
            for p=1:P
                s(p)=feval(bmf,y(p),bparam);
                
                for i=1:nx
                    amf=A{i}{xind(i),1};
                    aparam=A{i}{xind(i),2};
                    s(p)=s(p)*feval(amf,x(p,i),aparam);
                end
                
            end
            
            S{r}(yind)=sum(s);
            
            % S{r}(yind)=max(s);
            
        end
    end
    
    %% 4: Delete Extra Rules
    
    R=zeros(size(S));
    Keep=true(size(S));
    for r=1:nRules
        [Smax, R(r)]=max(S{r});
        if Smax==0
            Keep(r)=false;
        end
    end
    
    Rules=[XIND R];
    Rules(:,end+1)=1;
    Rules(:,end+1)=1;
    
    Rules=Rules(Keep,:);
    
    %% 5: Create FIS
    
    fis=newfis('Lookup Table FIS','mamdani');
    
    for i=1:nx
        fis=addvar(fis,'input',['x' num2str(i)],[min(x(:,i)) max(x(:,i))]);
        for j=1:nmf(i)
            fis=addmf(fis,'input',i,...
                ['A(' num2str(i) ',' num2str(j) ')'],...
                A{i}{j,1},A{i}{j,2});
        end
    end
    
    fis=addvar(fis,'output','y',[min(y) max(y)]);
    for j=1:nmf(end)
        fis=addmf(fis,'output',1,['B' num2str(j)],B{j,1},B{j,2});
    end
    
    fis=addrule(fis,Rules);
    
end