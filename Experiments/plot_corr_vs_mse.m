function [corr_data, mse_data] = calc_corr_vs_mse(px1, px2, n, num_trials)         

    % Caclulate the expected mean
    est_mean = px1*px2;

    % Create buffers for the result data
    corr_data = [];
    mse_data = [];
    mse_count = [];

    for i = 1:num_trials
        x1 = SNG_NO_FLUC(px1, n);
        x2 = SNG_NO_FLUC(px2, n);
        corr = sc_correlation(x1, x2);
        out_stream = AND(x1, x2);
        out_p = (sum(out_stream) / n);
        mse = (out_p - est_mean)^2; % We do not need to calculate the Bernouli error here.
        if(isnumeric(corr))
            % Add the values to the data vectors
            I = find(corr_data==corr);
            if(~isempty(I))
               mse_data(1,I) = mse_data(1,I)+mse;
               mse_count(1,I) = mse_count(1,I)+1;
            else
                corr_data = [corr_data corr];
                mse_data = [mse_data mse]; 
                mse_count = [mse_count 1];
            end
        end
    end
    
    % Sort the elements
    mse_avg = mse_data./mse_count;
    [corr_data_sort,ind]=sort(corr_data, 2, 'descend');
    mse_avg_sort=mse_avg(ind);
    
    corr_data = corr_data_sort;
    mse_data = mse_avg;

end