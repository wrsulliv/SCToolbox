%{
Computes the output of the stochastic Neruon presented in Brown and Card,
paper II.  The inputs and outputs are in the bi-polar format.  
Parameters: 
    signals: An num_inputs x stream_size matrix of 0s and 1s
    weights: An num_inputs x stream_size matrix of 0s and 1s

Details:  Defaults to a sigmoidal activation function unless 'linear' is
specified.  

%}
function neuron_out_stream = NEURON(signals, weights, fsm_states, activation_reset, linear)
    % The sig_mat matrix holds the input strings in each row, and the
    % weights are the weights for each of the signals.  Therefore, the
    % first dimension of the matrix is the number of signals.
    
    % Determine the stream size # of columns in weights or signals.
    stream_size = size(weights, 2);
    
    % Determine the number of elements
    num_inputs = size(weights, 1);

    % Prealocate synapse_out_stream for speed
    synapse_out_stream = zeros(num_inputs, stream_size);
    
    % Perform the synapse multiplication section of the circuit
    for i = 1:num_inputs
        %negated_weights = weights(i,:);
        %mux_out_stream = MUX(negated_weights, signals(i,:));
        %delay_out_stream = DELAY(weights(i,:));
        synapse_out_stream(i,:) = XNOR(signals(i,:),weights(i,:));
    end

    % Push the streams through a multiplexor
    mux_out_stream = MUX_MULTIPLE(synapse_out_stream);
    
    if(linear == false)
        % Push the output of the mux into the activation function
        if (activation_reset == true)
            neuron_out_stream = FSM_AUTO_RESET(mux_out_stream, fsm_states, stream_size);
        else
            neuron_out_stream = FSM(mux_out_stream, fsm_states);
        end
    else
        neuron_out_stream = mux_out_stream;
    end
    
    
end
