function []=plot_Predictive(base, mean, var, data_x, data_t, theta)

    U = mean + sqrt(var);
    L = mean - sqrt(var);
    L = fliplr(L);
    test = [base fliplr(base)];
    figure();
    F = fill(test, [U L], 'c');
    set(F,'EdgeColor','none');
    hold on;
    plot(base, mean,'LineWidth',2,'MarkerEdgeColor','b');
    hold on;
    scatter(data_x, data_t, 15);
    xlabel('x');
    ylabel('t');
    figure_name = ['Gaussian Process for \theta = ', mat2str(theta)];
    title(figure_name);
    
end