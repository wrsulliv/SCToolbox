% Returns a probablity occupation vector holding the probabilty of being in
% each of the given states.  This equation from pg. 6 of Brown, Stochastic Neural
% Computation I

% Parameters
% X = The probability of generating a 1 from the Bernouli sequence.
% num_state = The number of states in the FSM.
function O = calc_state_probability(X, num_states)
    X_hat = 1-X;
    N = num_states;
    O = zeros(1,num_states);
    for i = 0:num_states-1
        numerator = (X^i)*(X_hat^(N-1-i));
        denominator = sum((X*ones(1,N)).^(0:N-1).*((X_hat*ones(1,N)).^(N-1:-1:0)));
        O(i+1) = numerator / denominator;
    end
end
