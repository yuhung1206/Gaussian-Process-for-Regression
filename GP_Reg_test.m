clear all;
clc;
close all;
%-----constant-----%
beta_inverse = 1;

%-----load data-----%
dataSet = load('gp.mat');
data_x = dataSet.x;
data_t = dataSet.t;

%-----four combination-----%
theta = [0, 0, 0, 1 ; 1, 4, 0, 0; 1, 4, 0, 5; 1, 32, 5, 5;];
%-----theta from ARD-----%
% theta = [3.00000000000506,3.00000000125859,3.01435924527404,3.03118963392086];


%-----RMS matrix-----%
E_rms_test = zeros(5,1);
E_rms_train = zeros(5,1);

% For 4 combination of theta
for k = 1:4
    %-----calculate k_matrix & C_matrix-----
    delta = eye(60);
    k_matrix = zeros(60,60);
    for i = 1:60
       for j = 1:60
           temp = (-theta(k,2)/2)*((data_x(i)-data_x(j))^(2));
           k_matrix(i,j) = theta(k,1)*exp(temp) + theta(k,3) + theta(k,4)*(data_x(i)*data_x(j));
           C_matrix(i,j) = k_matrix(i,j) + beta_inverse*delta(i,j);
       end
    end
    %----------Testing----------%
    % Test set is last 40 data --> x[61]~x[100]
    k_vector = zeros(60,40);
    c_value = zeros(1,40);
    for i = 61:100
       for j = 1:60
           temp = 0;
           c_value(i-60) = theta(k,1)*exp(temp) + theta(k,3) + theta(k,4)*(data_x(i)*data_x(i)) + beta_inverse;
           temp = (-theta(k,2)/2)*((data_x(j)-data_x(i))^(2));
           k_vector(j,i-60) = theta(k,1)*exp(temp) + theta(k,3) + theta(k,4)*(data_x(j)*data_x(i));
       end
    end
    
    for i = 1:40
        predict_mean(i) = (k_vector(:,i)')*(pinv(C_matrix))*(data_t(1:60,1));
        predict_var(i) = c_value(i) - (k_vector(:,i)')*(pinv(C_matrix))*(k_vector(:,i));
    end
    %plot figure
    figure();
    scatter(data_x(61:100),predict_mean);
    figure_name = ['Gaussian Process (test set) for ', '\theta ', '= ', mat2str(theta(k,:))];
    title(figure_name);
    
    %----------for train set----------
    for i = 1:60
        predict_mean_train(i) = (k_matrix(:,i)')*(pinv(C_matrix))*(data_t(1:60,1));
        predict_var_train(i) = k_matrix(i,i) - (k_matrix(:,i)')*(pinv(C_matrix))*(k_matrix(:,i));
    end
    figure();
    scatter(data_x(1:60), predict_mean_train);
    figure_name = ['Gaussian Process (train set) for ', '\theta ', '= ', mat2str(theta(k,:))];
    title(figure_name);
    
    %-----root-mean-square errors-----
    % for test set
    temp = [];
    N = 40;
    temp = predict_mean' - data_t(61:100);
    temp = temp.^(2);
    sum_temp = sum(temp);
    E_rms_test(k) = sqrt((1/N)*sum_temp);
    %avg_test_rms = mean(E_rms_test');
    
    % for train set
    temp = [];
    N = 60;
    temp = predict_mean_train' - data_t(1:60);
    temp = temp.^(2);
    sum_temp = sum(temp);
    E_rms_train(k) = sqrt((1/N)*sum_temp);
    %avg_train_rms = mean(E_rms_train');
    
    %legend_name(k) = ['\theta ', '= ', mat2str(theta(k,:))];
end

plot(E_rms_test);
hold on;
plot(E_rms_train);

