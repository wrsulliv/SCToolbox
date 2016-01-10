% An SC random number generator, this will generate (m) bit-streams of length
% (n) with a definite uni-polar value of (p)

% Optimized = No

function matrix = SNG_MATRIX_NO_FLUC(p, n, m)
    counter = 0;
    matrix = zeros(m, n);
    while(counter < m)
        y = rand(1,n)<p;
        if(abs(S2D(y) - p) < 0.00001)
            counter = counter + 1;
            matrix(counter, :) = y;
        end
    end
end