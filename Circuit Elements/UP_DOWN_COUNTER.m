% Run a stream through a function
function [O] = UP_DOWN_COUNTER(IN, bits)
    
    % Calculate the maximum value
    num_states = 2^bits;
    max = num_states - 1;
    initial_state = (num_states / 2) - 1;
    
    % Initialize the counter
    O = zeros(1,size(IN, 2));
    count = initial_state;
    
    % Process the stream
    for i = 1:size(IN, 2)
        cur_bit = IN(i);
        if(cur_bit == 1)
            count = count + 1;
            if (count > max) 
                count = max;
            end 
        else
            count = count - 1;
            if(count < 0) 
                count = 0;
            end
        end
        
        O(1,i) = count;
       
    end
    
end
