% This is the same as FSM, except that once each sc number passes through, 
% the FSM is reset back to zero.
% IN is the input string to drive the FSM.  num_states is the number of
% states in the FSM.  (The number of flip-flops is log_2(num_states))

function [O] = FSM_AUTO_RESET(IN, num_states, sc_stream_length)
    
    % Reformulate the input to a matrix where each row is a stochastic
    % number
    sc_matrix = vec2mat(IN, sc_stream_length);
    
    % Calculate the max value
    start_state = (num_states / 2) - 1;
        
    for i = 1:size(sc_matrix, 1)

        % Run the input string through the counter
        O(i,:) = UP_DOWN_COUNTER(sc_matrix(i,:), log2(num_states));
        for j = 1:sc_stream_length
            % Run the counter output through the comparator
            O(i,j) = COMPARE(start_state, O(i,j));
        end
    end
    
    % Compact the O matrix to a single string
    O = reshape(O',[1,size(sc_matrix, 1)*size(sc_matrix,2)]);

 
end