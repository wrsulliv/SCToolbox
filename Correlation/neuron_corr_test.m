%{

Description:
    This function takes as input two uni-polar values (v1, v2) which can
    be accurately represented with a bit-stream length of length (n) 
    and the number of trials to perform (num_trials).  It also takes the
    number of states in the FSM which would normally be set depending on
    the number of weights and the maximum weight value.
    
    Each time a bitstream with a specific SCC value is generated, the
    corresponding error is recorded within a bucket corresponding to that
    SCC.  After all the trials have been run, each MSE bucket is averaged.
    The circuit used is stochastic neuron.

Notes:
    This is similar to the experiment performed by Chen in the correlation
    paper. 

%}

function [corr_data, mse_data] = neuron_corr_test(signal, weight, n, num_trials, fsm_states)         

    % Caclulate the expected mean
    
    x = UNIPOL_2_BIPOL(signal)*UNIPOL_2_BIPOL(weight);
    est_mean = tanh((fsm_states/2)*x);

    % Create buffers for the result data
    corr_data = [];
    mse_data = [];
    mse_count = [];
    
    for i = 1:num_trials
        signal_bitstream = SNG_NO_FLUC(signal, n);
        weight_bitstream = SNG_NO_FLUC(weight, n);
        corr = sc_correlation(signal_bitstream, weight_bitstream);
        activation_reset = false;
        linear = false;
        out_stream = SIMPLE_NEURON(signal_bitstream, weight_bitstream, fsm_states, activation_reset, linear);
        out_val = UNIPOL_2_BIPOL(S2D(out_stream));
        mse = (out_val - est_mean)^2; % We do not need to calculate the Bernouli error here.
        
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
    
    % Sort the elements
    mse_avg = mse_data./mse_count;
    [corr_data_sort,ind]=sort(corr_data, 2, 'descend');
    mse_avg_sort=mse_avg(ind);
    
    corr_data = corr_data_sort;
    mse_data = mse_avg_sort;

end