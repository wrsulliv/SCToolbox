% WARNING:  This is a version of the NEURON that is for trial and testing.  
%  It may not behave properly.  

%{
Computes the output of the stochastic Neruon presented in Brown and Card,
paper II.  The inputs and outputs are in the bi-polar format.  
Parameters: 
    signals: An num_inputs x stream_size matrix of 0s and 1s
    weights: An num_inputs x stream_size matrix of 0s and 1s

%}
function neuron_out_stream = NEURON_PLAY(signals, weights, N)
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
        delay_out_stream = DELAY(weights(i,:));
        synapse_out_stream(i,:) = XNOR(signals(i,:),delay_out_stream);
    end

    % Push the streams through a multiplexor
    mux_out_stream = MUX_MULTIPLE(synapse_out_stream);
    
    % Multiply the stream together
    %mult_mux = XNOR(XNOR(mux_out_stream, DELAY(mux_out_stream)), 1 - DELAY(XNOR(mux_out_stream, DELAY(mux_out_stream))));
    %mult_mux = XNOR(mult_mux, 1 - mux_out_stream);
    dec_mux_out = S2D_ARRAY(mux_out_stream, N);
    threshold_list = dec_mux_out < 0.5;
    threshold_list = DEC2SC_ARRAY(threshold_list, N);

    mult_mux = XNOR(XNOR(mux_out_stream, DELAY(NOT(mux_out_stream))), threshold_list);
    add_mux = MUX(mult_mux, mux_out_stream);
    neuron_out_stream = add_mux;

    
    
end
