function [ multi, f_mult, x ] = Poly2Multi( poly )
%POLY2MULTI Converts a polynomial vector to a multinomial vector

    % We now need to convert the polynomial to a multilinear polynomial, so get
    % the row out of the Pascal triangle that gives us the required expansion
    % paramaters
    degree = length(poly)-1;
    p_row = abs(pascal(degree + 1, 2));
    p_row = p_row(:,1)';

    % Now, run a loop to actually convert to the multilinear polynomial
    multilinear = zeros(1, sum(p_row));
    syms x;
    f_mult = 0;
    index = 1;
    for i = 1:length(p_row)
        for j = 1:p_row(i)
            coeficient = poly(i) / p_row(i)
            multilinear(index) = coeficient;
            f_mult = f_mult + coeficient*x^(i-1);
            index = index + 1;
        end
    end
    
    multi = multilinear;

end

