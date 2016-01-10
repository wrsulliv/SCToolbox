% dec_signals_mat: A matrix where each column corresponds to a sample of
% the inputs

% dec_weights_mat: A matrix where each column corresponds to a vector of
% weights (usually the same, but can be changed on each sample if desired)

% scale: Determines by how much to scale the Sigmoid function

function out = SigmoidNeuron(dec_signals_mat, dec_weights_mat, scale)
    % Multiply the weights and signals
    mult_mat = dec_signals_mat.*dec_weights_mat;
    sum_vect = sum(mult_mat, 1); 
    out = tanh(sum_vect*scale);
    % The above statement is equivelent to: out = 2/(1+exp(-2*sum_vect*scale))-1

end