function [results, required_bitstream_length_each_sample] = SC_NN_Sim(nnData, maxN, startN, tolerance)

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Prepare for SC
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Find the normalization constant for all the weights / bias vectors
all_w = getwb(nnData.net);
norm_c = max(abs(all_w));
min_weight = min(abs(all_w));

% Note that we can get a lower bound for N (bit-stream length) by:
% N > 1/min_weight;

% There is no upper bound on N, but in general, the larger N, the more 
% computation time, but the more accurate. 

%norm_c = 1;

%{
    How do I access the neural network weights?

    The biases for each layer are stored in net.b{l}
    The bias to the kth neuron in the lth layer is net.b{l}(k) 

    The weights to the input layer are in a different variable than the weights
    to the other layers.  To get the weights to the input layer, use
    net.IW{1}(k,w) where k is the neuron and w is the weight.  

    Now, for non-input layers, to get the weights to layer i from layer j, use 
    net.LW{i,j}(k,w) where w is the weight and k is the neuron. 

%}

% Divide the weights and biases to scale between -1 and 1.
sc_b = gdivide(nnData.net.b, norm_c);
sc_IW = gdivide(nnData.net.IW, norm_c);
sc_LW = gdivide(nnData.net.LW, norm_c);



FSM_STATES_I = ceil(norm_c*2*nnData.numInputsToNeuronsInLayer(1));
FSM_STATES_HO = ceil(norm_c*2*nnData.numInputsToNeuronsInLayer(2));
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Perform the Feedforward
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    results = [];
    %results_debug = [];
    required_bitstream_length_each_sample = [];
    network_percent_error_map = zeros(nnData.numOfLayers, max(nnData.numNodesInLayer)); % Create a map to show which neurons have the most error
    for sample = 1:nnData.numTest
        
        % Get the sample point
        x = [nnData.phi_test(sample,:)'; 1];
        
        % Convert the input to the Uni-Polar range
        dec_signals_squished = BIPOL_2_UNIPOL(x);

        % Convert the decimal values to stochastic numbers
        sc_signals = DEC2SC_ARRAY(dec_signals_squished, maxN);

        % Start the feedforward propogation
        % At the output of each layer we should get a vector which represents
        % the input to the next layer
        current_input_debug = x; % Used to perform my own feedforward in software without the NN Toolbox
        current_output_debug = [];
        current_input_normal = sc_signals;
        current_output = [];
        required_bitstream_length_vec = [];
        for l = 1:nnData.numOfLayers
            current_output = [];
            current_output_debug = [];
            for k = 1:nnData.numNodesInLayer(l)

                %  Differentiate between the input layer weights and other
                %  layers
                if(l == 1)
                    % For the first layer the three correlation types
                    % remain the same.

                    % We need to generate the sc weight matrix which is
                    % (size(phi, 2) + 1) x (N)
                    weights = [sc_IW{1}(k,:)'; sc_b{l}(k)];
                    dec_weights_squished = BIPOL_2_UNIPOL(weights);
                    sc_weights = DEC2SC_ARRAY(dec_weights_squished, maxN);
                    neuron_out = NEURON(current_input_normal, sc_weights, FSM_STATES_I,true, false);
                    current_output = [current_output; neuron_out];
                    
                    %  DEBUGGING
%                     actual_output = UNIPOL_2_BIPOL(S2D_ARRAY(neuron_out, N))
%                     expected_output = tanh(current_input_debug'*(weights*norm_c))
%                     neuron_percent_error_hidden = abs(100*(actual_output - expected_output)/expected_output)
%                     current_output_debug = [current_output_debug; expected_output];
%                     network_percent_error_map(l, k) = network_percent_error_map(l, k) + neuron_percent_error_hidden;

%                     min_val = min(abs(weights.*x))
%                     blah = 1;
                elseif(l == nnData.numOfLayers)
                    weights = [sc_LW{l,l-1}(k,:)'; sc_b{l}(k)];
                    dec_weights_squished = BIPOL_2_UNIPOL(weights);
                    sc_weights = DEC2SC_ARRAY(dec_weights_squished, maxN);
                    neuron_out = NEURON(current_input_normal, sc_weights, 0, false, true);
                    [required_bitstream_length, did_keep_tolerance] = AnalyzeProgressivePrecision_BiPolar(neuron_out, tolerance, startN);
                    required_bitstream_length_vec = [required_bitstream_length_vec required_bitstream_length];
                    current_output = [current_output; neuron_out];
                    
                    %  DEBUGGING
%                     actual_output = UNIPOL_2_BIPOL(S2D_ARRAY(neuron_out, N))
%                     expected_output = current_input_debug'*(weights)/numInputsToNeuronsInLayer(l);
%                     neuron_percent_error_output = abs(100*(actual_output - expected_output)/expected_output)
%                     current_output_debug = [current_output_debug; expected_output];
%                     network_percent_error_map(l, k) = network_percent_error_map(l, k) + neuron_percent_error_output;
                else
                    weights = [sc_LW{l,l-1}(k,:)'; sc_b{l}(k)];
                    dec_weights_squished = BIPOL_2_UNIPOL(weights);
                    sc_weights = DEC2SC_ARRAY(dec_weights_squished, maxN);
                    neuron_out = NEURON(current_input_normal, sc_weights, FSM_STATES_HO, true, false);
                    current_output = [current_output; neuron_out];
                    
                    %  DEBUGGING
%                     actual_output = UNIPOL_2_BIPOL(S2D_ARRAY(neuron_out, N))
%                     expected_output = tanh(current_input_debug'*(weights*norm_c))
%                     neuron_percent_error_hidden = abs(100*(actual_output - expected_output)/expected_output)
%                     current_output_debug = [current_output_debug; expected_output];
%                     network_percent_error_map(l, k) = network_percent_error_map(l, k) + neuron_percent_error_hidden;
                end

            end

            
            % Update the current input
            current_input_normal = [current_output; ones(1, maxN)];
            current_input_debug = [current_output_debug; 1];
        end

        % Determine the required bitstream length for the current sample
        required_bitstream_length_final = max(required_bitstream_length_vec);
        required_bitstream_length_each_sample = [required_bitstream_length_each_sample required_bitstream_length_final];
        
        % Adjust (current_output)
        current_output = current_output(:, 1:required_bitstream_length);
        
        % Now that we have the stochastic outputs, we need to convert these
        % to decimal again.
        dec_out = S2D_ARRAY(current_output, required_bitstream_length);

        % Convert the decimal numbers back to the original space
        dec_out = UNIPOL_2_BIPOL(dec_out);

        % Use the softmax function to get a valid posterior distribution
        output = softmax(dec_out)';
        %output_debug = softmax(current_output_debug)';

        output = output - max(output);
        %output_debug = output_debug - max(output_debug);
        
        output = (output >= 0);
        %output_debug = (output_debug >= 0);
        
        results = [results; output];
        %results_debug = [results_debug; output_debug];
        
    end
    
    required_bitstream_length_each_sample;
    avg_length_per_samples = mean(required_bitstream_length_each_sample);
end