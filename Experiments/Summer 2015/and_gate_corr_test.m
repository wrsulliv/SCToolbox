%{

Description:
    This function takes as input two probabilities (px1, px2), the
    bit-stream length (n) and the number of trials to perform (num_trials).
    Each time a bitstream with a specific SCC value is generated, the
    corresponding error is recorded within a bucket corresponding to that
    SCC.  After all the trials have been run, each MSE bucket is averaged.
    The circuit used is an AND gate.

Notes:
    This is similar to the experiment performed by Chen in the correlation
    paper. 

%}

function [corr_data, mse_mean, bucket_counter, corr_global_avg, mse_global_avg] = and_gate_corr_test(px1, px2, n, num_trials)         

    % Caclulate the expected mean
    est_mean = px1*px2;

    % Create buffers for the result data
    corr_data = [];
    mse_mean = [];
    bucket_counter = [];
    mse_global_avg = 0;
    corr_global_avg = 0;
    
    for i = 1:num_trials
        x1 = SNG_NO_FLUC(px1, n);
        x2 = SNG_NO_FLUC(px2, n);
        corr = sc_correlation(x1, x2);
        corr_global_avg = corr_global_avg + corr;
     
        out_stream = AND(x1, x2);
        out_p = (sum(out_stream) / n);
        mse = out_p - est_mean; % We do not need to calculate the Bernouli error here.
        mse_global_avg = mse_global_avg + mse;
        % Add the values to the data vectors
        I = find(corr_data==corr);
        if(~isempty(I))
           mse_mean(1,I) = mse_mean(1,I)+mse;
           bucket_counter(1,I) = bucket_counter(1,I)+1;
        else
            corr_data = [corr_data corr];
            mse_mean = [mse_mean mse]; 
            bucket_counter = [bucket_counter 1];
        end
    end
    
    % Sort the elements
    mse_column_averages = mse_mean./bucket_counter;
    %mse_variance = var(mse_mean);
    [corr_data_sort,ind]=sort(corr_data, 2, 'descend');
    mse_avg_sort=mse_column_averages(ind);
    bucket_counter = bucket_counter(ind);
    
    corr_data = corr_data_sort;
    mse_mean = mse_avg_sort;
    mse_global_avg = mse_global_avg / num_trials;
    corr_global_avg = corr_global_avg / num_trials;

end