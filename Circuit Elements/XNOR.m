% Computes the XNOR of two bitstreams

% Optimized = Yes

function [x1] = XNOR(x1, x2)

    x1 = (x1 - x2) == 0;

end