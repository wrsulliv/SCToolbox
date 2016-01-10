%{ 
Multiplexes the stochastic bits in the 'inputs' array
Parameters: 
    inputs: A MxN array of 0s and 1s, where M is the number of inputs, and
    N is the stream length.

Optimized = Yes

%}

function out = MUX_MULTIPLE(inputs)

    % Define variables to hold the sizes
    bitstream_length = size(inputs, 2);
    number_of_inputs = size(inputs, 1);
    
    % Create the string of random numbers
    input_select = randi([1 number_of_inputs], 1, bitstream_length);
    
    % Preallocate the output string for performance
    out = zeros(1, bitstream_length);
    
    % Now send the streams through a multiplexer
    for i = 1:bitstream_length
        out(1,i) = inputs(input_select(i), i);
    end
    
end