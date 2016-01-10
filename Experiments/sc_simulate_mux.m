% Run a simulation which will generate many random bitstreams with the
% probabilities given in px1 and px2.  Two vectors are returned including
% the correlation and corresponsing output MSE
function [corr_data, mse_data] = sc_simulate_mux(px1, px2, n)

    % Caclulate the estimated mean
    est_mean = px1*px2;
    
    % Generate two matrices where the rows are vectors
    num_trials = 5000;
    X1 = zeros(num_trials,n);
    X2 = zeros(num_trials,n);
    
    num_x1_entries = 0;
    num_x2_entries = 0;
    
    while num_x1_entries ~= num_trials
        row = SNG(px1, n);
        if(sum(row) / n == px1)
            X1(num_x1_entries + 1,:) = row;
            num_x1_entries = num_x1_entries + 1;
        end
    end
    
    while num_x2_entries ~= num_trials
        row = SNG(px2, n);
        if(sum(row) / n == px2)
            X2(num_x2_entries + 1,:) = row;
            num_x2_entries = num_x2_entries + 1;
        end
    end
    
    % Create buffers for the result data
    corr_data = [];
    mse_data = [];
   
    for i = 1:num_trials
        corr = sc_correlation(X1(i,:), X2(i,:));
        out_p = (sum(AND(X1(i,:), X2(i,:))) / n);
        mse = (out_p - est_mean)^2;

        if(isnumeric(corr))
            % Add the values to the data vectors
            corr_data = [corr_data corr];
            mse_data = [mse_data mse];
            
        end
    end
    
    
end
