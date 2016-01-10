% This is not a stochastic computing function
% This function will give the correct output of a neuron with 
% an activatoin function equal to tanh(x*((#FSM States)/2)).
% The values of the weights and signals should be in the range [-1:1] as
% this is the range of representable bi-polar values, and the purpose of
% this code is to test the stochastic Neuron.
function out = NEURON_TEST(dec_signals_mat, dec_weights_mat, fsm_states)
    % Multiply the weights and signals
    mult_mat = dec_signals_mat.*dec_weights_mat;
    sum_vect = sum(mult_mat, 1)./size(dec_signals_mat, 1); % When adding, we need to normalize
    %out = tanh(sum_vect*fsm_states/2);
    out = logsig(sum_vect);
    %plot(out);
end