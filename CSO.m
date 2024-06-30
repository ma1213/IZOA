
%% cat swarm optimization -CSO -2006
function [bestf,bestx,BestCost]=CSO(nPop,MaxIt,lb,ub,nVar,CostFunction)

%%  Parameters
SMP=3;%0.25*nPop;
SRD=0.2;
CDC=0.2;
nb=round(nVar*CDC);
MR=0.3;
num_seek=round(MR*nPop);
num_track=nPop-num_seek;
cat=randperm(nPop);
w_cat=0.5;
vmax_cat=4;
one_vel_cat=rand(nPop,nVar)-0.5;
zero_vel_cat=rand(nPop,nVar)-0.5;
%********************************
%% Initialization
% Define Empty Structure to Hold Particle Data
empty_cat.Position=[];
empty_cat.flag=[];
empty_cat.Velocity=[];
empty_cat.Cost=[];
pop=repmat(empty_cat,nPop,1);
vel_cat=rand(nPop,nVar)-0.5;

% Initialize Global Best

GlobalBest.Cost=inf;
for i=1:nPop
    % Initialize Velocity
    pop(i).Position=lb+(ub-lb).*rand(1,nVar);
    pop(i).Velocity = rand(1,nVar);
    % Evaluate Solution
    pop(i).Cost=CostFunction(pop(i).Position);
    y=find(cat==i);
    if(y<=num_seek)
        pop(i).flag=1;
    else
        pop(i).flag=0;
    end
    % Update Global Best
    if pop(i).Cost<=GlobalBest.Cost
        GlobalBest=pop(i);
    end
end
% Define Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);
c1=1;c2_cat=1;
%%  Main Loop
for it=1:MaxIt
    oneadd_cat=zeros(nPop,nVar);
    zeroadd_cat=zeros(nPop,nVar);
    dd3_cat=c2_cat*rand;
    %******************************************************
    for t_i=1:nPop
        for g_i=1:nVar
            if(GlobalBest.Position(g_i)==0)
                oneadd_cat(t_i,g_i)=oneadd_cat(t_i,g_i)-dd3_cat;
                zeroadd_cat(t_i,g_i)=zeroadd_cat(t_i,g_i)+dd3_cat;
            else
                oneadd_cat(t_i,g_i)=oneadd_cat(t_i,g_i)+dd3_cat;
                zeroadd_cat(t_i,g_i)=zeroadd_cat(t_i,g_i)-dd3_cat;
            end
        end
    end
    one_vel_cat=w_cat*one_vel_cat+oneadd_cat;
    zero_vel_cat=w_cat*zero_vel_cat+zeroadd_cat;
    
    for t_i=1:nPop
        for g_i=1:nVar
            if(abs(vel_cat(t_i,g_i))>vmax_cat)
                one_vel_cat(t_i,g_i)=vmax_cat*sign(one_vel_cat(t_i,g_i));
                zero_vel_cat(t_i,g_i)=vmax_cat*sign(zero_vel_cat(t_i,g_i));
            end
        end
    end
    
    for t_i=1:nPop
        for g_i=1:nVar
            if(pop(t_i).Position(g_i)==1)
                vel_cat(t_i,g_i)=zero_vel_cat(t_i,g_i);
            else
                vel_cat(t_i,g_i)=one_vel_cat(t_i,g_i);
            end
        end
    end
    veln_cat=logsig(vel_cat);
    %******************************************************
    for i=1:nPop
        if(pop(i).flag==0)
            for r2=1:nVar
                if(rand<veln_cat(i,r2))
                    pop(i).Position(r2)=GlobalBest.Position(r2);
                else
                    pop(i).Position(r2)=pop(i).Position(r2);
                end
            end
            pop(i).Cost = CostFunction(pop(i).Position);
        else
            copy_cat=repmat(pop(i).Position,SMP,1);
            pop(i).Position=mutate(copy_cat,nVar,nb,SRD,CostFunction);
        end

        % Update Global Best
        if pop(i).Cost<=GlobalBest.Cost
            GlobalBest=pop(i);
        end
    end
    % Store Best Cost Ever Found
    BestCost(it)=GlobalBest.Cost;
    bestf = GlobalBest.Cost;
    bestx = GlobalBest.Position;
    num_seek=round(MR*nPop);
    num_track=nPop-num_seek;
    cat=randperm(nPop);
    for ii=1:nPop
        y=find(cat==ii);
        if(y<=num_seek)
            pop(ii).flag=1;
        else
            pop(ii).flag=0;
        end
    end
end
end %  CAT 


function z=mutate(x,nvar,nb,srd,CostFunction)

costv=zeros(1,size(x,1));
P=costv;
costv(1)=CostFunction(x(1,:));
for i=2:size(x,1)
    j=randsample(nvar,nb)';
    A=zeros(nvar);
    A(j)=1;
    r=find(A==1);
    x(i,:)=x(1,:);
    for t=1:numel(r)
        if(rand<srd)
            x(i,r(t))=1-x(i,r(t));
        end
    end
    costv(i)=CostFunction(x(i,:));
end
if(max(costv) == min(costv))
    P=ones(1,size(x,1));
else
    P=abs(costv-max(costv))/(max(costv)-min(costv));
end
P=P./sum(P);

r1=RouletteWheelSelection(P);
z=x(r1,:);

end
function j=RouletteWheelSelection(P)
r=rand;
C=cumsum(P);
j=find(r<=C,1,'first');
end