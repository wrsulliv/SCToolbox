function [probability] = Prob_given_n_tol(n, tol)

    % Set up the variables to test
    %n = 17; % Bitstream size
    w = floor(tol*n);
    m = floor(n/2); % Try for p = .5 for now.
    p = m/n; % Given probability

    % Run the theoretical analysis to get an estimate for the probabilty
    sum_total = 0;
    for i = 1:w
        sum_total = sum_total + (p^i)*(1-p)^(-i)*nchoosek(n, m+i) + p^(-i)*(1 - p)^(i)*nchoosek(n, m-i);
    end
    sum_total = p^(m)*(1-p)^(-m)*(1-p)^n*(sum_total + nchoosek(n,m));
    probability = sum_total;

end

