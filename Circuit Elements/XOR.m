% Computes the inverse of a bit-stream
function [x1] = XOR(x1, x2)

    for i = 1:size(x2,2)
        if(x2(i) ~= x1(i))
            x1(i) = 1;
        else
            x1(i) = 0;
        end
        
    end
    

end