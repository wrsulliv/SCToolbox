

   % n = 512;
    num_trials = 7000; % How many datapoints of each pair to try.
    
    % Loop for px1 = 0, 1/4, 2/4 and 3/4
    % Loop for px2 = 0, 1/4, 2/4 and 3/4

    [corr_data, mse_data] = calc_corr_vs_mse(3/4, 1/4, 16, num_trials); 
    [corr_data2, mse_data2] = calc_corr_vs_mse(1/4, 3/4, 32, num_trials);
    [corr_data3, mse_data3] = calc_corr_vs_mse(1/4, 3/4, 64, num_trials);
    
    [corr_data4, mse_data4] = calc_corr_vs_mse(1/4, 3/4, 128, num_trials); 
    [corr_data5, mse_data5] = calc_corr_vs_mse(1/4, 3/4, 256, num_trials);
    
    [corr_data6, mse_data6] = calc_corr_vs_mse(1/4, 3/4, 512, num_trials);
    
    
    plot(corr_data, mse_data, corr_data2, mse_data2, corr_data3, mse_data3, corr_data4, mse_data4, corr_data5, mse_data5, corr_data6, mse_data6);
    legend('n=16', 'n=32', 'n=64', 'n=128', 'n=256', 'n=512');
    % Create xlabel
    xlabel('SCC','FontWeight','bold','FontSize',16);

    % Create ylabel
    ylabel('MSE','FontWeight','bold','FontSize',16);

    % Create title
    title('SCC vs MSE - p(x)=.25 and p(y)=.75','FontWeight','bold','FontSize',20);

    hold on;
    
    
    for numerator_x1 = 1:(interval_denominator - 1)
        for numerator_x2 = 1:(interval_denominator - 1)

           
        end
    end

    

