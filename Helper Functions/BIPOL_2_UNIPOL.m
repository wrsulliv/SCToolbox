% Converts a matrix of decimal numbers between -1 and 1 to a matrix of
% decimal numbers between 0 and 1.

% Optimized = Yes

function out = BIPOL_2_UNIPOL(bipol_mat)
    out = (bipol_mat + 1)./2;
end