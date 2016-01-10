% IN is the input string to drive the FSM.  
% Note:  Both the inputs and output to the state machine are stochastic
% numbers in the bi-polar format.  

function [O] = FSM(IN, num_states)
    
    % Calculate the max value
    start_state = (num_states / 2) - 1;
    
    % Run the input string through the counter
    O = UP_DOWN_COUNTER(IN, log2(num_states));

    for i = 1:size(IN, 2)
        % Run the counter output through the comparator
        O(i) = COMPARE(start_state, O(i));
    end

 
end
