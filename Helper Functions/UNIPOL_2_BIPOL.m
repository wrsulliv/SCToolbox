% Converts a matrix of decimal numbers between 0 and 1 to a matrix of
% decimal numbers between -1 and 1.
function out = UNIPOL_2_BIPOL(unipol_mat)
    out = unipol_mat.*2 - 1;
end