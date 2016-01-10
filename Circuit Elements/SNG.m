% An SC random number generator, this will generate a bit-stream of length
% n with probability p

% Optimized = Yes

function y = SNG(p, n)
    y = rand(1,n)<p;
end