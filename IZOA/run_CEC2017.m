clc
clear
close all
%%
nPop=50; % ��Ⱥ��

Max_iter=1000; % ����������

dim = 10; % ��ѡ 2, 10, 30, 50, 100
delete Results\Results1.txt
diary Results\Results1.txt

%%  ѡ����
for j=1:30
    Function_name=j; % �������� 1 - 30
    [lb,ub,dim,fobj] = Get_Functions_cec2017(Function_name,dim);

%% �����㷨
    
    [Best_score,Best_pos,cg_curve]=ZOA1(nPop,Max_iter,lb,ub,dim,fobj);
    
    fprintf('f%d:��The value of Best_score is %d.\n',Function_name, Best_score);
end
diary off
%% plot
figure('Position',[400 200 300 250])
semilogy(cg_curve,'Color','r','Linewidth',1)
%     plot(cg_curve,'Color','r','Linewidth',1)
title(['Convergence curve, Dim=' num2str(dim)])
xlabel('Iteration');
ylabel(['Best score F' num2str(Function_name) ]);
axis tight
grid on
box on
set(gca,'color','none')
legend('ZOA')

