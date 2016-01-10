% Run a stream through the compare function
% If IN1 < IN2, then output a 1 otherwise a 0.
% In the case of an SC generator, IN1 should be the random number generated
% and IN2 should be the probability.
function [O] = COMPARE(IN1, IN2)
    O = zeros(1, size(IN1, 2));
    for i = 1:size(IN1, 2)
        if(IN1(i) < IN2(i))
            O(i) = 1;
        else
            O(i) = 0;
        end
    end
    
    
end
