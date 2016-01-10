% Converts the binary row vector b to a positive decimal number
function de = bi2de(b)
    de = 0;
    for i = 1:length(b)
        de = de + b(i)*2^(length(b) - i);
    end
    
end