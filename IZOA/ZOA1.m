



%%% Designed and Developed by Eva Trojovská1, Mohammad Dehghani1, and Pavel Trojovský1* %%%


function[Best_score,Best_pos,ZOA_curve]=ZOA1(SearchAgents,Max_iterations,lowerbound,upperbound,dimension,fitness)

lowerbound=ones(1,dimension).*(lowerbound);                              % Lower limit for variables
upperbound=ones(1,dimension).*(upperbound);                              % Upper limit for variables

%% INITIALIZATION
for i=1:dimension
    X(:,i) = lowerbound(i)+rand(SearchAgents,1).*(upperbound(i) - lowerbound(i));                          % Initial population
end

for i =1:SearchAgents
    L=X(i,:);
    fit(i)=fitness(L);
end
%%

for t=1:Max_iterations
    %% update the global best (fbest)
    a=2-2*(t/Max_iterations);
    A=2*a*rand-a;
    [best , location]=min(fit);
    [worst , location1]=max(fit);
    WZ=X(location1,:);
    tao = 0.618;
    
    if t==1
        PZ=X(location,:);                                           % Optimal location
        fbest=best;                                           % The optimization objective function
    elseif best<fbest
        fbest=best;
        PZ=X(location,:);
    end

    %% PHASE1: Foraging Behaviour
    for i=1:SearchAgents
        I=round(1+rand);
        X_newP1=X(i,:)+ A*rand(1,dimension).*(PZ-I.* X(i,:)-WZ); %Eq(3)
        X_newP1= max(X_newP1,lowerbound);X_newP1 = min(X_newP1,upperbound);
        
        
        % Updating X_i using (5)
        f_newP1 = fitness(X_newP1);
        if f_newP1 <= fit (i)
            X(i,:) = X_newP1;
            fit (i)=f_newP1;
        end

    end
    %% End Phase 1: Foraging Behaviour
    
    %% PHASE2: defense strategies against predators
    Ps=rand;
    k=randperm(SearchAgents,1);
    AZ=X(k,:);% attacked zebra
    r=rand(1,dimension);
    r1=rand(1,dimension);
    r=4*r.*(1-r);
    for i=1:SearchAgents
        
        if Ps<0.5
            %% S1: the lion attacks the zebra and thus the zebra chooses an escape strategy
            R=0.1;
            X_newP2= X(i,:)+ R*(2*rand(1,dimension)-1)*(1-t/Max_iterations).*X(i,:);% Eq.(5) S1
            X_newP2= max(X_newP2,lowerbound);X_newP2 = min(X_newP2,upperbound);
      
        else
            %% S2: other predators attack the zebra and the zebra will choose the offensive strategy
            
            I=round(1+rand(1,1));
            X_newP2=X(i,:)+ rand(1,dimension).*(AZ-I.* X(i,:)); %Eq(5) S2
            X_newP2= max(X_newP2,lowerbound);X_newP2 = min(X_newP2,upperbound);
             
        end
        
        f_newP2 = fitness(X_newP2); %Eq (6)
        if f_newP2 <= fit (i)
            X(i,:) = X_newP2;
            fit (i)=f_newP2;
        end

    end %
    %%黄金
    a = -pi * r;
    b = pi * r1;
    x1 = a + (1 - tao) * (b - a);
    x2 = a + tao * (b - a);

    for i = 1:SearchAgents
        I = round(1 + rand());
        X_newP3 = X(i, :) .* abs(sin(r)) + r1.* sin(r1) .* abs(x1.*PZ-I * x2.*X(i, :));
        X_newP3 = max(X_newP3,lowerbound);X_newP3 = min(X_newP3,upperbound);
        XN_fitness = fitness(X_newP3);
        
        if XN_fitness < fitness(X(i, :))
            X(i, :) = X_newP3;
            fit(i) = XN_fitness;
        end
    end
    %%淘汰
    [worst , location1]=max(fit);
    WZ=X(location1,:);
    X_newP4 = lowerbound+rand(1,dimension).*(upperbound - lowerbound);
    if fitness(X_newP4) <= worst
            WZ = X_newP4;
            worst=fitness(X_newP4);
    end
    best_so_far(t)=fbest;
    average(t) = mean (fit);
    
end %t=1:Max_iterations
Best_score=fbest;
Best_pos=PZ;
ZOA_curve=best_so_far;
end

