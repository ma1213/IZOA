clc
clear
close all
%%
nPop=50; % 种群数
Runs = 30; 
Max_iter=1000; % 最大迭代次数
ZOA_Best=zeros(33,Runs);
WOA_Best=zeros(33,Runs);
PSO_Best=zeros(33,Runs);
GoldSA_Best=zeros(33,Runs);
FSO_Best=zeros(33,Runs);
IZOA_Best=zeros(33,Runs);
AVOA_Best=zeros(33,Runs);
COA_Best=zeros(33,Runs);
SWO_Best=zeros(33,Runs);
ABO_Best=zeros(33,Runs);
DBO_Best=zeros(33,Runs);
SOA_Best=zeros(33,Runs);
MCWOA_Best=zeros(33,Runs);
TSA_Best=zeros(33,Runs);
DA_Best=zeros(33,Runs);
SMA_Best=zeros(33,Runs);
dim = 10; % 可选 2, 10, 30, 50, 100
excelFile = 'optimization_results_test.xlsx';
%%  选择函数
for funNum=[1:30]
    [lb,ub,dim,fobj] = Get_Functions_cec2017(funNum,dim);
    for r=1:1:Runs
        [ZOA_Best(funNum,r),ZOA_Best_pos,ZOA_cg_curve]=ZOA(nPop,Max_iter,lb,ub,dim,fobj);
        [WOA_Best(funNum,r),WOA_Best_pos,WOA_cg_curve]=WOA(nPop,Max_iter,lb,ub,dim,fobj);
        [PSO_Best(funNum,r),PSO_Best_pos,PSO_cg_curve]=PSO(nPop,Max_iter,lb,ub,dim,fobj);
        [GoldSA_Best(funNum,r),GoldSA_Best_pos,GoldSA_cg_curve]=GoldSA(nPop,Max_iter,lb,ub,dim,fobj);
        [RSO_Best(funNum,r),RSO_Best_pos,RSO_cg_curve]=RSO(nPop,Max_iter,lb,ub,dim,fobj);
        [IZOA_Best(funNum,r),IZOA_Best_pos,IZOA_cg_curve]=ZOA1(nPop,Max_iter,lb,ub,dim,fobj);
        [AVOA_Best(funNum,r),AVOA_Best_pos,AVOA_cg_curve]=AVOA(nPop,Max_iter,lb,ub,dim,fobj);
        [COA_Best(funNum,r),COA_Best_pos,COA_cg_curve]=COA(nPop,Max_iter,lb,ub,dim,fobj);
        [SWO_Best(funNum,r),SWO_Best_pos,SWO_cg_curve]=SWO(nPop,Max_iter,lb,ub,dim,fobj);
        [ABO_Best(funNum,r),ABO_Best_pos,ABO_cg_curve]=ABO(nPop,Max_iter,lb,ub,dim,fobj);
        [DBO_Best(funNum,r),DBO_Best_pos,DBO_cg_curve]=DBO(nPop,Max_iter,lb,ub,dim,fobj);
        [SOA_Best(funNum,r),SOA_Best_pos,SOA_cg_curve]=SOA(nPop,Max_iter,lb,ub,dim,fobj);
        [MCWOA_Best(funNum,r),MCWOA_Best_pos,MCWOA_cg_curve]=MCWOA(nPop,Max_iter,lb,ub,dim,fobj);
        [TSA_Best(funNum,r),TSA_Best_pos,TSA_cg_curve]=TSA(nPop,Max_iter,lb,ub,dim,fobj);
        [DA_Best(funNum,r),DA_Best_pos,DAcg_curve]=DA(nPop,Max_iter,lb,ub,dim,fobj);
        [SMA_Best(funNum,r),SMA_Best_pos,SMA_cg_curve]=SMA(nPop,Max_iter,lb,ub,dim,fobj);
    end
    % 创建一个包含结果的表格，其中每一列对应一个优化算法的结果
    results = table(ZOA_Best(funNum,:)', WOA_Best(funNum,:)', PSO_Best(funNum,:)', GoldSA_Best(funNum,:)', RSO_Best(funNum,:)', IZOA_Best(funNum,:)', ...
        AVOA_Best(funNum,:)',COA_Best(funNum,:)',SWO_Best(funNum,:)',ABO_Best(funNum,:)',DBO_Best(funNum,:)',SOA_Best(funNum,:)',MCWOA_Best(funNum,:)', ...
        TSA_Best(funNum,:)',DA_Best(funNum,:)',SMA_Best(funNum,:)',...
        'VariableNames', {'ZOA', 'WOA', 'PSO', 'GoldSA', 'RSO', 'IZOA', 'AVOA', 'COA', 'SWO','ABO','DBO','SOA', 'MCWOA','TSA','DA','SMA'});

    % 创建一个工作表名称
    sheetName = ['Function_', num2str(funNum)];

    % 使用writetable将结果写入Excel文件
    writetable(results, excelFile, 'Sheet', sheetName);
end
