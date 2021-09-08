clear all;
clc;
close all;
%-----constant-----%
beta_inverse = 1;
eta = 0.1;

%-----load data-----%
dataSet = load('gp.mat');
data_x = dataSet.x;
data_t = dataSet.t;

%-----theta initial-----%
theta = [3, 3, 3, 3];
theta_old = [3, 3, 3, 3];

%----------ARD----------%
data_length = 60;
stop_flag = false;
[ C_matrix, k_matrix] = produce_k_matrix(theta,data_x(1:data_length),data_length);
% for de_theta_0
temp = []
for i = 1:60
   temp = [temp, data_x(1:data_length)];
end
temp = temp - temp';

de_theta_3 = data_x(1:data_length)*(data_x(1:data_length)'); %no need to update
de_theta_2 = ones(data_length,data_length); %no need to update
store_theta = [];
count = 1;

while (stop_flag == false)&&(count<1000)
    
    de_theta_0 = exp(-(theta(2)/2)*(abs(temp)^(2)));
    de_theta_1 = -(1/2)*(abs(temp)^(2))*theta(1)*de_theta_0;
    
    de_ln_p_0 = (1/2)*trace(inv(C_matrix)*de_theta_0) + (1/2)*(data_t(1:data_length)')*inv(C_matrix)*(de_theta_0)*inv(C_matrix)*data_t(1:data_length);
    de_ln_p_1 = (1/2)*trace(inv(C_matrix)*de_theta_1) + (1/2)*(data_t(1:data_length)')*inv(C_matrix)*(de_theta_1)*inv(C_matrix)*data_t(1:data_length);
    de_ln_p_2 = (1/2)*trace(inv(C_matrix)*de_theta_2) + (1/2)*(data_t(1:data_length)')*inv(C_matrix)*(de_theta_2)*inv(C_matrix)*data_t(1:data_length);
    de_ln_p_3 = (1/2)*trace(inv(C_matrix)*de_theta_3) + (1/2)*(data_t(1:data_length)')*inv(C_matrix)*(de_theta_3)*inv(C_matrix)*data_t(1:data_length);
    
    store_theta = [store_theta theta'];
    theta_old = theta;
    
    theta(1) = theta_old(1) + eta*de_ln_p_0;
    theta(2) = theta_old(2) + eta*de_ln_p_1;
    theta(3) = theta_old(3) + eta*de_ln_p_2;
    theta(4) = theta_old(4) + eta*de_ln_p_3;
    
    diff = abs(theta_old - theta);
    
    if sum(diff)<0.1
        stop_flag = true;
        count = count + 1
    end
    [ C_matrix, k_matrix] = produce_k_matrix(theta,data_x(1:data_length),data_length);
    
    
end

