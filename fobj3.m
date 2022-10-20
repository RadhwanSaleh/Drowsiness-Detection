function [mse22] = fobj3(net)
load 'N_Features'
FeutureN=22;%Feuture Number of data
CN=23;%Column Number of data
x=N_Features;
Testing_Inp=x(1:9172,1:FeutureN);
Testing_Target=x(1:9172,CN);
predicted = net(Testing_Inp');
mse22 = mean((Testing_Target - predicted').^2,'omitnan');   % Mean Squared Error
end
