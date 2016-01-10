% Run a simulation which will generate many bitstreams of length n with the
% probabilities given in px1 and px2.  Two vectors are returned including
% the correlation and corresponsing output MSE

    n = 512;
    num_trials = 7000; % How many datapoints of each pair to try.
    
    % Loop for px1 = 0, 1/4, 2/4 and 3/4
    % Loop for px2 = 0, 1/4, 2/4 and 3/4

    [corr_data, mse_data] = calc_corr_vs_mse(1/4, 1/4, n, num_trials); 
    [corr_data2, mse_data2] = calc_corr_vs_mse(2/4, 1/4, n, num_trials);
    [corr_data3, mse_data3] = calc_corr_vs_mse(3/4, 1/4, n, num_trials);
    
    [corr_data4, mse_data4] = calc_corr_vs_mse(2/4, 2/4, n, num_trials); 
    [corr_data5, mse_data5] = calc_corr_vs_mse(3/4, 2/4, n, num_trials);
    
    [corr_data6, mse_data6] = calc_corr_vs_mse(3/4, 3/4, n, num_trials);
    
    plot(corr_data, mse_data, corr_data2, mse_data2, corr_data3, mse_data3, corr_data4, mse_data4, corr_data5, mse_data5, corr_data6, mse_data6);
    legend('X=.25, Y=.25','X=.5, Y=.25', 'X=.75, Y=.25', 'X=.5, Y=.5', 'X=.75, Y=.5', 'X=.75, Y=.75');
    % Create xlabel
    xlabel('SCC','FontWeight','bold','FontSize',16);

    % Create ylabel
    ylabel('MSE','FontWeight','bold','FontSize',16);

    % Create title
    title('SCC vs MSE (n=512)','FontWeight','bold','FontSize',20);

    hold on;
    
    
    for numerator_x1 = 1:(interval_denominator - 1)
        for numerator_x2 = 1:(interval_denominator - 1)

           
        end
    end

    

