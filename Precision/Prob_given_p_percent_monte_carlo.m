% Gives an estimate for the probablity of generating a specific unipolar value
% within a certain pecent error from the given value.  

function [probability] = Prob_given_p_percent_monte_carlo(px, percent_error_tolerance, N, avg_steps)

    % Run the Monte Carlo simulation to get an estimate for the probabilty
    % of being within the given tolerance
    probability = 0;
    for run = 1:avg_steps
        bitstream = SNG(px, N);
        dec_number = S2D(bitstream);
        percent_error = 100*abs((dec_number - px)/px);
        if(percent_error <= percent_error_tolerance)
            probability = probability + 1;
        end
    end
    
    probability = probability / avg_steps;
    

end

