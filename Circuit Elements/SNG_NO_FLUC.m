% An SC random number generator:  This will keep generating bit streams
% until a random stream is generated which has the given probablity.
% Effectively, this function removes the random fluctuations from the
% bit-stream while leaving the bits in random locations with the correct
% encoded value.
function [y] = SNG_NO_FLUC(p, n)
    y = -1;
    while(sum(y)/n ~= p)
        y = rand(1,n)<p;
    end
end
