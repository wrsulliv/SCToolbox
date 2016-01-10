% Adds the signal x1 and x2
function [x1] = MUX(x1, x2)

    %y = zeros(1, size(x2, 2));
    % Now send the streams through a multiplexer
    for i = 1:size(x2,2)
        rnd_bit = rand(1,1) < .5;
        if(rnd_bit == 1)
            x1(1, i) = x2(1,i);
        end
    end
    
end