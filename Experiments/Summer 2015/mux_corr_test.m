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

function [corr_data, mse_mean, mse_var, corr_percentage, corr_global_avg, mse_global_avg] = mux_corr_test(px1, px2, n, num_trials)         

    % Caclulate the expected mean
    est = (px1+px2)/2;
    %est = px1*px2;

    % Create buffers for the result data
    corr_data = [];
    mse_samples = zeros(num_trials);
    bucket_counter = [];
    mse_global_avg = 0;
    corr_global_avg = 0;
    
    for i = 1:num_trials
        x1 = SNG_NO_FLUC(px1, n);
        x2 = SNG_NO_FLUC(px2, n);
        corr = sc_correlation(x1, x2);
        corr_global_avg = corr_global_avg + corr;

        out_stream = MUX(x1, x2);
        out_p = (sum(out_stream) / n);
        %CHANGED THIS:  mse = (out_p - est)^2;
        unipol_mux_out = out_p;
        mse_global_avg = mse_global_avg + unipol_mux_out;
        % Add the values to the data vectors
        I = find(corr_data==corr);
        if(~isempty(I))
           current_entry_bucket = I;
           num_current_entries = bucket_counter(I);
           mse_samples(current_entry_bucket, num_current_entries+1) = unipol_mux_out;
           bucket_counter(I) = bucket_counter(I)+1;
        else
            corr_data = [corr_data; corr];
            current_entry_bucket = length(corr_data);
            mse_samples(current_entry_bucket, 1) = unipol_mux_out; 
            bucket_counter = [bucket_counter; 1];
        end
    end
    

    % Calculate the global averages.
    mse_global_avg = mse_global_avg / num_trials;
    corr_global_avg = corr_global_avg / num_trials;
    
    % Calculate the mean and variance vectors
    num_buckets = length(corr_data);
    mse_mean = zeros(1, num_buckets);
    mse_var = zeros(1, num_buckets);
    for bucket = 1:num_buckets
        num_samples_in_bucket = bucket_counter(bucket);
        mse_mean(bucket) = mean(mse_samples(bucket, 1:num_samples_in_bucket));
        mse_var(bucket) = var(mse_samples(bucket, 1:num_samples_in_bucket));
    end
    
    % Sort the elements
    [corr_data,ind]=sort(corr_data, 1, 'descend');
    mse_mean = mse_mean(ind);
    mse_var = mse_var(ind);
    corr_percentage = bucket_counter(ind)./num_trials;
   



end