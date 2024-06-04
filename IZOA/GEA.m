% Geyser Algorithm (GEA)
function [BestCost,BestSol,Convergence_curve]=GEA(SearchAgents_no,Tmax,ub,lb,dim,fobj)

%%%%-------------------Definitions--------------------------%%
VarMin=lb;                 % Decision Variables Lower Bound
VarMax=ub;             % Decision Variables Upper Bound
nVar=dim;                     % Number of Decision Variables
VarSize=[1 nVar];            % Decision Variables Matrix Size
Nc=40;                       %Number of Channles
FEs=Tmax;                  % Maximum Number of Function Evoulations
nPop=SearchAgents_no;                     % Number of Geyser (Swarm Size)
Convergence_curve=zeros(1,Max_iter);
%% Initialization
Geyser.Position=[];          % Empty Geyser Structure
Geyser.Cost=[];
pop=repmat(Geyser,nPop,1);   % Initialize Population Array
BestSol.Cost=inf;            
%%
pop=initialization(SearchAgents_no,dim,ub,lb); % Initialize the positions of spider wasps
it=0; %% Function evaluation counter 

%%---------------------Evaluation-----------------------%%
while it<=FEs
        for i=1:nPop
            %%%%%%%%%%%%%%%  Implementing Eq(3)   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            for ii=1:nPop
                D1(ii)=sum(pop(i).Position.*pop(ii).Position)/ (((sum(pop(i).Position.^2)*sum(pop(ii).Position.^2)))^0.5); % Eq(3)
                if ii==i
                    D1(ii)=inf;
                end
            end
            S1=min(D1);
            [~,j1]=find(S1==D1);
            
            %%%% Calculating the pressure value in Eq(6)  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            [CS, Sortorder]=sort([pop.Cost]);
            dif=(CS(end)-CS(1));            % fmax-fmin  Eq(6)
            G=((pop(i).Cost-CS(1))/dif);    % f(i)-fmin  Eq(6)
            if dif==0
                G=0;
            end
            if it==1
                it=2;
            end
            P_i(i)=(((G^(2/it))-(G^((it+1)/it)))^0.5)*((it/(it-1))^0.5);  % Pi Eq(6)
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%  Search for channels using Roulette wheel selection   %%%%%
            ImpFitness=0;
            for ii=1:Nc
                ImpFitness=ImpFitness+pop(ii).Cost;
            end
            p=[];
            if ImpFitness==0
                ImpFitness=1e-320;
            end
            for ii=1:Nc
                p(ii)=pop(ii).Cost/ImpFitness;    % Eq(1)
            end
            if sum(p)==0
                i1=1;
            else
                i1=RouletteWheelSelection((p));
            end
            flag=0;
            %%%%%%%%%%%%%%%  Implementing Eq(5)   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            newsol.Position=pop(j1(1)).Position+(rand(VarSize)).*(pop(i1).Position-pop(j1(1)).Position)+(rand(VarSize)).*(pop(i1).Position-pop(i).Position);
            newsol.Position=max(newsol.Position,VarMin);
            newsol.Position=min(newsol.Position,VarMax);
            newsol.Cost=CostFunction(newsol.Position);
            it=it+1;
            if newsol.Cost<=pop(i).Cost
                pop(i)=newsol;
                flag=0;
            end
            if newsol.Cost<=BestSol.Cost
                BestSol=newsol;
            end
            BestCost(it)=BestSol.Cost;
            if   flag==0
                i2=RouletteWheelSelection((1-p));  % Implementing Roulette wheel selection by Eq(7)
            %%%%%%%%%%%%%%%  Implementing Eq(8)   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                newsol.Position=pop(i2).Position+rand*(P_i(i)-rand)*unifrnd(1*VarMin,1*VarMax,VarSize);
                newsol.Position=max(newsol.Position,VarMin);
                newsol.Position=min(newsol.Position,VarMax);
                newsol.Cost=CostFunction(newsol.Position);
                it=it+1;
                if newsol.Cost<=pop(i).Cost
                    pop(i)=newsol;
                end
                if newsol.Cost<=BestSol.Cost
                    BestSol=newsol;
                end
                BestCost(it)=BestSol.Cost;
            end
        end
        [~, Sortorder]=sort([pop.Cost]);
        pop=pop(Sortorder);
%         if mod(it,100)==0
%             disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
%         end
end

function i=RouletteWheelSelection(p)

    c=cumsum(p);
    r=rand();
    i=find(r<=c,1,'first');

end



