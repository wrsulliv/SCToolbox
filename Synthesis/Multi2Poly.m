function [ poly ] = Multi2Poly( multi)
%MULTI2POLY Converts a multilinear polynomial to a single variable
%polynomial.  The multilinear polynomial may have auxilary inputs whose
%value is assumes to be (0.5).

% Determine the degree of the original polynomial
% sum(multi) = 2^n:  where n is the degree

    degree = log2(length(multi));
    p_row = abs(pascal(degree + 1, 2));
    p_row = p_row(:,1)';

    poly = [];
    index = 1;
    for i = 1: length(p_row)
        poly_element = 0;
        for j = 1:p_row(i)
            poly_element = poly_element + multi(index);
            index = index + 1;
        end
        poly = [poly poly_element];
    end

end

