FeutureN=22;%Feuture Number of data
CN=23;%Column Number of data
load 'N_Features'
load('initialization.mat')
% load('results1_with.mat')
mm=30;
acc = [];
 for i=1:mm
     net = setwb(net,Best_pos_DFSABC_ds(i,:)); % initialize ANN using the weights found by DFSABC\ds
     Testing_Inp=H2(9173:11466,1:FeutureN)';
     Testing_Target=H2(9173:11466,CN)';
     predicted = net(Testing_Inp);
     [c,cm,ind,per] = confusion(Testing_Target,predicted);
     acc = [acc (cm(1,1)+cm(2,2))/sum(sum(cm))];
 end
      Fscore = (2.*Recall.*Prec)./(Recall+Prec);

     ind=find(acc==max(acc));
     ind=ind(end);
     accuracy_best=acc(ind);
     accuracy_mean = mean(acc);
     MSE_mean=mean(Best_score_DFSABC_ds);
     MSE_std=std(Best_score_DFSABC_ds);
     GlobalParamsBest=Best_pos_DFSABC_ds(ind,:);