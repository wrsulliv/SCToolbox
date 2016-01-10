
    % Plot probability vs MSE for different possible stochastic
    % de-correlators

    num_trials = 1000;
    n = 256;
    
    
    % Create buffers for the result data
    corr_data = [];
    mse_data = [];
    probability = [];

    % Simulate the isolator
    for p = 2:15
        px = p/16;
        est_mean = px*px;
        corr = 0;
        mse = 0;
        count = 0;
        for i = 1:num_trials
            input = SNG(px, n);
            
            input_d = DELAY(input);
            input = input(1:end-1);
            input_d = input_d(1:end-1);
            current_corr = sc_correlation(input, input_d);
            out_stream = AND(input, input_d);
            out_p = (sum(out_stream) / (n-1));
            current_mse = (out_p - est_mean)^2; % We do not need to calculate the Bernouli error here.
            if(isnumeric(current_corr))
                corr = corr + current_corr;
                mse = mse + current_mse;
                count = count + 1;
            end
        end
        corr_data = [corr_data corr/count];
        mse_data = [mse_data mse/count];
        probability = [probability px];
        
    end

    
    
    
    % Create buffers for the result data
    corr_data_bad_mux = [];
    mse_data_bad_mux = [];
    probability_bad_mux = [];



        % Simulate the Worst Case (The same stream)
    for p = 2:15
        px = p/16;
        est_mean = px*px;
        corr = 0;
        mse = 0;
        count = 0;
        for i = 1:num_trials
            % Generate the bit-stream
            input = SNG(px, n);
            current_corr = sc_correlation(input, input);
            out_stream = AND(input, input);
            out_p = (sum(out_stream) / n);
            current_mse = (out_p - est_mean)^2; % We do not need to calculate the Bernouli error here.
            if(isnumeric(current_corr))
                corr = corr + current_corr;
                mse = mse + current_mse;
                count = count + 1;
            end
        end
        corr_data_bad_mux = [corr_data_bad_mux corr/count];
        mse_data_bad_mux = [mse_data_bad_mux mse/count];
        probability_bad_mux = [probability_bad_mux px];
        
    end
    
   % Create buffers for the result data
    corr_data_mux = [];
    mse_data_mux = [];
    probability_mux = [];
    
    % Simulate the MUX
    for p = 2:15
        px = p/16;
        est_mean = px*px;
        corr = 0;
        mse = 0;
        count = 0;
        for i = 1:num_trials
            % Generate the bit-stream
            input = SNG(px, n);
            
            % Delay the bit-stream
            input_d = DELAY(input);
            
            % Erase the last bit of the inputs to correct for the delay ...
            %(a delay will shift the stream to the left, so the first bi
            %will not be used any longer.)
            
            input = input(1:end-1);
            input_d = input_d(1:end-1);
            input_new = MUX(input, input_d);
            current_corr = sc_correlation(input, input_new);
            out_stream = AND(input, input_new);
            out_p = (sum(out_stream) / n);
            current_mse = (out_p - est_mean)^2; % We do not need to calculate the Bernouli error here.
            if(isnumeric(current_corr))
                corr = corr + current_corr;
                mse = mse + current_mse;
                count = count + 1;
            end
        end
        corr_data_mux = [corr_data_mux corr/count];
        mse_data_mux = [mse_data_mux mse/count];
        probability_mux = [probability_mux px];
        
    end
    
    
    
    % Create buffers for the result data
    corr_data_reg = [];
    mse_data_reg = [];
    probability_reg = [];

    % Simulate the MUX
    for p = 2:15
        px = p/16;
        est_mean = px*px;
        corr = 0;
        mse = 0;
        count = 0;
        for i = 1:num_trials
            input = SNG(px, n);
            input_new = SNG(px,n);
            current_corr = sc_correlation(input, input_new);
            out_stream = AND(input, input_new);
            out_p = (sum(out_stream) / n);
            current_mse = (out_p - est_mean)^2; % We do not need to calculate the Bernouli error here.
            if(isnumeric(current_corr))
                corr = corr + current_corr;
                mse = mse + current_mse;
                count = count + 1;
            end
        end
        corr_data_reg = [corr_data_reg corr/count];
        mse_data_reg = [mse_data_reg mse/count];
        probability_reg = [probability_reg px];
        
    end
    
    % Create buffers for the result data
    corr_data_xor = [];
    mse_data_xor = [];
    probability_xor = [];

    % Simulate the MUX
    for p = 2:15
        px = p/16;
        est_mean = px*px;
        corr = 0;
        mse = 0;
        count = 0;
        for i = 1:num_trials
            input = SNG(px, n);
            input_new = SNG(px,n);
            current_corr = sc_correlation(input, input_new);
            out_stream = AND(input, input_new);
            out_p = (sum(out_stream) / n);
            current_mse = (out_p - est_mean)^2; % We do not need to calculate the Bernouli error here.
            if(isnumeric(current_corr))
                corr = corr + current_corr;
                mse = mse + current_mse;
                count = count + 1;
            end
        end
        corr_data_xor = [corr_data_xor corr/count];
        mse_data_xor = [mse_data_xor mse/count];
        probability_xor = [probability_xor px];
        
    end
    
    plot(probability, mse_data, probability_mux, mse_data_mux, probability_reg, mse_data_reg, probability_bad_mux, mse_data_bad_mux);
    
       legend('Isolator', 'Mux', 'Regeneration', 'Worst Case');
    % Create xlabel
    xlabel('Probability','FontWeight','bold','FontSize',16);

    % Create ylabel
    ylabel('MSE','FontWeight','bold','FontSize',16);

    % Create title
    title('Probability vs MSE (n=256)','FontWeight','bold','FontSize',20);
    

