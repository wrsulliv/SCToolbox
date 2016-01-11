function [ multi ] = Poly2Multi( poly )
%POLY2MULTI Converts a polynomial vector to a multinomial vector

    % We now need to convert the polynomial to a multilinear polynomial, so get
    % the row out of the Pascal triangle that gives us the required expansion
    % paramaters
    num_inputs = length(poly)-1;
    p_row = abs(pascal(num_inputs + 1, 2));
    p_row = p_row(:,1)';

    multi = zeros(1, 2^num_inputs);
    for input = 0:2^num_inputs-1
        bin = de2bi(input);
        num_signals = sum(bin);
        n_choose_k = p_row(num_signals+1);
        poly_coef = poly(num_signals+1);
        multi(input+1) = poly_coef/n_choose_k;
    end
    
%     % Now, run a loop to actually convert to the multilinear polynomial
%     multilinear = zeros(1, sum(p_row));
%     syms x;
%     f_mult = 0;
%     index = 1;
%     for i = 1:length(p_row)
%         for j = 1:p_row(i)
%             coeficient = poly(i) / p_row(i)
%             multilinear(index) = coeficient;
%             f_mult = f_mult + coeficient*x^(i-1);
%             index = index + 1;
%         end
%     end
%     
%     multi = multilinear;

end

