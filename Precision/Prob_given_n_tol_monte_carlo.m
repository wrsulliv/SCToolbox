% Has the same function as the Prob_given_n_tol function, but it performs
% the function using Monte Carlo simulation.

function [probability] = Prob_given_n_tol_monte_carlo(n, tol)

    avg_steps = 100000;
    % Set up the variables to test
    %n = 17; % Bitstream size
    w = floor(tol*n);
    m = floor(n/2); % Try for p = .5 for now.
    p = m/n; % Given probability

    % Run the Monte Carlo simulation to get an estimate for the probabilty
    % of being within the given tolerance
    probability = 0;
    for run = 1:avg_steps
        number = SNG(p, n);
        dec_number = S2D(number);
        if((dec_number >= p - tol) && (dec_number <= p + tol))
            probability = probability + 1;
        end
    end
    
    probability = probability / avg_steps;
    

end

