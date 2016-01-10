%{
Computes the output of the stochastic Neruon presented in Brown and Card,
paper II.  The inputs and outputs are in the bi-polar format.  
Parameters: 
    signals: An num_inputs x stream_size matrix of 0s and 1s
    weights: An num_inputs x stream_size matrix of 0s and 1s

Details:  Defaults to a sigmoidal activation function unless 'linear' is
specified.  

Introspection:  This function extends the original Neuron code by also
outputing a percentage error map with the following format:

XNOR1_ERROR, XNOR2_ERROR, ... 
MUX_ERROR
FSM_ERROR

%}
function [neuron_out_stream, percent_error_map, actual_output, expected_output] = NEURON_INTROSPECTIVE(sc_signals, sc_weights, dec_signals, dec_weights, dec_weight_scale_factor, fsm_states, activation_reset, linear)
    
    % The sig_mat matrix holds the input strings in each row, and the
    % weights are the weights for each of the signals.  Therefore, the
    % first dimension of the matrix is the number of signals.
    
    % Determine the stream size # of columns in weights or signals.
    stream_size = size(sc_weights, 2);
    
    % Determine the number of elements
    num_inputs = size(sc_weights, 1);
    
    percent_error_map = zeros(3, num_inputs);

    % Prealocate synapse_out_stream for speed
    synapse_out_stream = zeros(num_inputs, stream_size);
    
    
    % Perform the synapse multiplication section of the circuit
    for i = 1:num_inputs
        %negated_weights = weights(i,:);
        %mux_out_stream = MUX(negated_weights, signals(i,:));
        %delay_out_stream = DELAY(weights(i,:));
        synapse_out_stream(i,:) = XNOR(sc_signals(i,:),sc_weights(i,:));
    end
    
    % Log the percent error
    actual_xnor = UNIPOL_2_BIPOL(S2D_ARRAY(synapse_out_stream, stream_size));
    expected_xnor = dec_signals.*dec_weights;
    percent_error_map(1,:) = PercentError(expected_xnor, actual_xnor);
    

    % Push the streams through a multiplexor
    mux_out_stream = MUX_MULTIPLE(synapse_out_stream);
    actual_mux = UNIPOL_2_BIPOL(S2D_ARRAY(mux_out_stream, stream_size));
    expected_mux = dec_weights'*dec_signals;
    percent_error_map(2,1) = PercentError(expected_mux, actual_mux);
    
    if(linear == false)
        % Push the output of the mux into the activation function
        if (activation_reset == true)
            neuron_out_stream = FSM_AUTO_RESET(mux_out_stream, fsm_states, stream_size);
        else
            neuron_out_stream = FSM(mux_out_stream, fsm_states);
        end
        
        actual_output = UNIPOL_2_BIPOL(S2D_ARRAY(neuron_out_stream, stream_size));
        expected_output = tanh(dec_weights'*dec_signals*dec_weight_scale_factor);
        percent_error_map(3, 1) = PercentError(expected_output, actual_output);
    else
        neuron_out_stream = mux_out_stream;
        actual_output = actual_mux;
        expected_output = expected_mux;
        percent_error_map(3, 1) = PercentError(expected_mux, actual_mux);
    end
    
    
    
end
