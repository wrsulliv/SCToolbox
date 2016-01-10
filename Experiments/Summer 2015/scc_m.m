%{
    Description: This function calculates the SCC of multiple stochastic
    bit-streams (IN) where each (IN) is a matrix and each row is a
    bit-stream.

    This is done using a variation of the SCC measure given by Alaghi.  
    Specifically, 
    this is done by calculating the numerator and denominator as:
    numerator = actual(all_inputs) - expected(all_inputs)
    denominator = min(all_inputs) - expected(all_inputs): If numerator is > 0
    denominator = max(0, sum(all_inputs) - 1): If numerator <= 0
%}

function [scc_m, min_val, max_val] = scc_m(IN)
    input_values = S2D_ARRAY(IN);
    actual = S2D_ARRAY(AND_MAT(IN));
    expected = prod(input_values);
    
    numerator = actual - expected;
    max_val = min(input_values) - expected;
    
    % To calculate the maximum negative error, we need to determine what
    % the minimum overlap will be of all N numbers.  This cen be done by
    % determening the minimum overlap of a pair, then using this new value
    % with another input and continuing in this way until all the inputs
    % are checked.
    current = input_values(1);
    for i = 2:length(input_values)
        current = max(0, sum([current, input_values(i)]) - 1);
    end
    
    min_val = expected - current;
    
    if(numerator > 0)
        denominator = max_val;
    else
        denominator = min_val;
    end
    
    if (numerator == 0)
        scc_m = 0;
    else
        scc_m = numerator/denominator;
    end

end