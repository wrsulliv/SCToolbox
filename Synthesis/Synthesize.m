function [f_mult, x, f, f_star, f_star_star, scale_factor] = Synthesize( poly, max_iterations)
%Synthesize Converts from a single variable polynomial to a truth table
%(f_star_star) The intermediate steps are returned as well.  

% Step One:  Format the target function as a multilinear polynomial:
[multi, f_mult, x] = Poly2Multi(poly);

% Step Two: Compute the inverse Fourier transform to obtain f.
% Computes the inverse fourier transform of a given multi-linear polynomial
% where P is the multi-linear polynomial in column form
P = multi';
f = hadamard(length(P))*P;

% Step Three: Scale the elements of f to match the IBP interval,
% yeilding f*.  Since IBP is in the range -1 to 1, we simply divide the
% function by the element with the largest absolute value.
scale_factor = 1;
aboveOne = f > 1;
belowNegativeOne = f < -1;
if (sum(aboveOne) + sum(belowNegativeOne)) > 0
    scale_factor = max(abs(f));
    f_star = f / scale_factor;
else
    f_star = f;
end


% Step Four: Since f* may contain elements besides +1 and -1, we modify
% f* to obtain f**.

f_star_star = Modify(f_star, max_iterations);

% Step Five: Optimize f** via standard combinational design procedures.



end

