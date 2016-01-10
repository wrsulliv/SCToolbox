% An SC random number generator, this will generate (m) bit-streams of length
% (n) with uni-polar value (p)

% Optimized = Yes

function y = SNG_MATRIX(p, n, m)
    y = rand(m,n)<p;
end

