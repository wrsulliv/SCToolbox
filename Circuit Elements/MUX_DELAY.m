% Computes the mux delay of a signal
function [y] = MUX_DELAY(x1)

    x2 = DELAY(x1);
    y = zeros(1, size(x2, 2));
    % Now send the streams through a multiplexer
    for i = 1:size(x2,2)
        rnd_bit = rand(1,1) < .5;
        if(rnd_bit == 0)
            y(1, i) = x1(1,i);
        else
            y(1, i) = x2(1,i);
        end
    end
end