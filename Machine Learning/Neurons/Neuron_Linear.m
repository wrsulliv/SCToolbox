% dec_signals_mat: A matrix where each column corresponds to a sample of
% the inputs

% dec_weights_mat: A matrix where each column corresponds to a vector of
% weights (usually the same, but can be changed on each sample if desired)

function out = LinearNeuron(dec_signals_mat, dec_weights_mat)
    % Multiply the weights and signals
    mult_mat = dec_signals_mat.*dec_weights_mat;
    sum_vect = sum(mult_mat, 1);
    %out = tanh(sum_vect*fsm_states/2);
    out = sum_vect;

end