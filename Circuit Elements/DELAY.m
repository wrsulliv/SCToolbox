% Computes the delay of a signal.  
% IMPORTANT NOTE:  The output will include one random bit at the beginning
% of the string representing the random initial state of the flip-flop.
% The last bit of x1 will be removed.
function [y] = DELAY(x1)

    x2 = x1(2:size(x1, 2));
    rnd_bit = rand(1,1) < .5;
    y = [x2 rnd_bit];
    
end

