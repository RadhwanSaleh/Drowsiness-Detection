clear all 
clc

Runno=30;
SearchAgents_no=100; % Number of search agents
lb=-10;
ub=10;
dim=1081;
Max_iteration=300; % Maximum numbef of iterations

for i=1:Runno
[Best_score_DFSABC_ds(i),Best_pos_DFSABC_ds(i,:),DFSABC_ds_cg_curve(i,:)]= DFSABC_ds(SearchAgents_no,Max_iteration,lb,ub,dim); % ABC trainer
end 
