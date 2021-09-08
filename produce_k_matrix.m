function [ C_matrix, k_matrix]=produce_k_matrix(theta,data_x,data_length)
    %theta = [0, 0, 0, 1 ];
    beta_inverse = 1;
  
    %-----calculate k_matrix & C_matrix-----
    delta = eye(data_length);
    k_matrix = zeros(data_length,data_length);
    for i = 1:data_length
       for j = 1:data_length
           temp = (-theta(2)/2)*((data_x(i)-data_x(j))^(2));
           k_matrix(i,j) = theta(1)*exp(temp) + theta(3) + theta(4)*(data_x(i)*data_x(j));
           C_matrix(i,j) = k_matrix(i,j) + beta_inverse*delta(i,j);
       end
    end


end