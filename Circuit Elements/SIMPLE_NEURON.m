%{
A simplified version of the neruon presented by Brown and Card, where there
is only a single XNOR gate, and no MUX.
 
Parameters: 
    signal: An 1 x stream_size vector representing a uni-polar SN
    weight: An 1 x stream_size vector representing a uni-polar SN

Details:  Defaults to a sigmoidal activation function unless 'linear' is
specified.  

%}
function neuron_out_stream = NEURON(signal, weight, fsm_states, activation_reset, linear)
    % The sig_mat matrix holds the input strings in each row, and the
    % weights are the weights for each of the signals.  Therefore, the
    % first dimension of the matrix is the number of signals.
    
    % Determine the stream size # of columns in weights or signals.
    stream_size = size(weight, 2);
    
    % Perform the synapse multiplication section of the circuit
    synapse_out_stream = XNOR(signal,weight);

    % There is no MUX needed as ther is only a single input/weight
    % combination
    
    if(linear == false)
        % Push the output of the mux into the activation function
        if (activation_reset == true)
            neuron_out_stream = FSM_AUTO_RESET(synapse_out_stream, fsm_states, stream_size);
        else
            neuron_out_stream = FSM(synapse_out_stream, fsm_states);
        end
    else
        neuron_out_stream = synapse_out_stream;
    end
    
    
end
