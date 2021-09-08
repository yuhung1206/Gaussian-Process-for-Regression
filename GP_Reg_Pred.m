clear all;
clc;
close all;
%-----constant-----%
beta_inverse = 1;

%-----load file data-----%
dataSet = load('gp.mat');
data_x = dataSet.x;
data_t = dataSet.t;

%-----four combination-----%
%theta =  { Linear , square-exp, exp-quadractic, exp-quadractic }
theta = [0, 0, 0, 1 ; 1, 4, 0, 0; 1, 4, 0, 5; 1, 32, 5, 5;];  
%theta = [1, 1, 0, 0 ;1, 1, 0, 1 ; 1, 1, 1, 0 ;3, 3, 3, 3 ;]; 
%theta = [0.987457901625491,16.7366198205525,-4858.36099077796,3298.59055790658];
%theta = [5,5,5,5];

% Iteration through 4 hyperparameters in theta array
for k = 1:4 
    %-----calculate k_matrix & C_matrix -----%
    % take first 60 data fro training --> calculate their kernel matrix
    delta = eye(60);
    k_matrix = zeros(60,60);
    for i = 1:60
       for j = 1:60
           temp = (-theta(k,2)/2)*((data_x(i)-data_x(j))^(2));
           k_matrix(i, j) = theta(k, 1)*exp(temp) + theta(k, 3) + theta(k, 4)*(data_x(i)*data_x(j));
           C_matrix(i, j) = k_matrix(i, j) + beta_inverse*delta(i, j);
       end
    end
    
    x_label = [0 : 0.01 : 2]; % x is limited in [0,2]
    k_vector = zeros(60, length(x_label));
    c_value = zeros(1, length(x_label));
    for i = 1 : length(x_label)
        temp = (-theta(k, 2)/2) * ( ( x_label(i) - x_label(i) )^(2) );
        c_value(i) = theta(k, 1)*exp(temp) + theta(k,3) + theta(k,4)*( x_label(i)*x_label(i) ) + beta_inverse;
       for j = 1:60
           temp = ( -theta(k, 2)/2 )*( ( data_x(j) - x_label(i) )^(2) );
           k_vector(j, i) = theta(k,1)*exp(temp) + theta(k, 3) + theta(k, 4)*(data_x(j)*x_label(i));
       end
    end

    for i = 1:length(x_label)
        predict_mean(i) = (k_vector(:, i)')*(pinv(C_matrix))*(data_t(1:60, 1));
        predict_var(i) = c_value(i) - (k_vector(:, i)')*(pinv(C_matrix))*(k_vector(:, i));
    end

    %----------plot_Predictive----------%
    plot_Predictive(x_label, predict_mean, predict_var, data_x, data_t, theta(k, :));
    
end
