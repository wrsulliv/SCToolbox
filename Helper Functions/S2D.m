% Stochastic to Decimal
function [O] = S2D(IN)

    bits = size(IN, 2);
    O = sum(IN)/bits;
    
end

