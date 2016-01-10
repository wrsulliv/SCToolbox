% This experiment is used to show how correlation errors propogate through
% a single neuron.  This script compares the results of montecarlo
% simulation to the result of an expression.  

format long;
num_iterations = 5000;
N = 10000;
norm_c = 3;
num_mux_inputs = 3;
fsm_states = 2*num_mux_inputs*norm_c;
% Remember that fsm_states = 2*num_mux_inputs*norm_c.



    
%  The layers, neurons, weights and inputs are indexed starting at 1.
% The jth weight to the ith neuron in layer k is given by: w(j+2*(i-1), k)
% The jth input to the ith neuron in layer k is given by: i(j+2*(i-1), k)
% The biases are built into the weight and input matrices.
    
corr = [];
percent_error = [];
percent_error_count = [];
for iteration = 1:num_iterations
    
    i = rand(num_mux_inputs, 1);
w = rand(num_mux_inputs, 1)*norm_c;
w(num_mux_inputs,1) = 1; % set the weight to 1 for the bias term
w_normalized = w./norm_c;

    iteration
i_sc = SNG_USERDEF_MATRIX(i, N);
w_sc = SNG_USERDEF_MATRIX(w_normalized, N);

i_actual = S2D_ARRAY(i_sc, N);
w_actual = S2D_ARRAY(w_sc, N);
scc_actual_one = sc_correlation(i_sc(1,:), w_sc(1, :));
scc_actual_two = sc_correlation(i_sc(2,:), w_sc(2, :));
scc_actual_bias = sc_correlation(i_sc(3,:), w_sc(3, :));

% Estimate the output
M = [0 1; 1 0; 1 0;  0 1]; % construct the circuit matrix

estimated_first_xnor = UNIPOL_2_BIPOL(calc_correlated_output(i_actual(1), w_actual(1), scc_actual_one, M));
actual_first_xnor = UNIPOL_2_BIPOL(S2D_ARRAY(XNOR(i_sc(1,:), w_sc(1, :)), N));
estimated_second_xnor = UNIPOL_2_BIPOL(calc_correlated_output(i_actual(2), w_actual(2), scc_actual_two, M));
actual_second_xnor = UNIPOL_2_BIPOL(S2D_ARRAY(XNOR(i_sc(2,:), w_sc(2, :)), N));
estimated_bias = UNIPOL_2_BIPOL(calc_correlated_output(i_actual(3), w_actual(3), scc_actual_bias, M));
actual_bias_xnor = UNIPOL_2_BIPOL(S2D_ARRAY(XNOR(i_sc(3,:), w_sc(3, :)), N));

estimated_mux_out = (estimated_bias + estimated_first_xnor + estimated_second_xnor)/3;

estimated_output = tanh((fsm_states/2)*estimated_mux_out);
%estimated_output = estimated_mux_out;

% Run the feedforward simulation with a single hidden layer of 2 sigmoidal
% neurons and an output layer with a single sigmoidal neuron.  
O = NEURON(i_sc(1:3, 1:N), w_sc(1:3, 1:N), fsm_states, false, false);
o_actual = UNIPOL_2_BIPOL(S2D_ARRAY(O, N));

% Now compute the expected
%o_expected = tanh(i_actual(1:3, 1)'*w_actual(1:3, 1));

current_percent_error = (estimated_output - o_actual)^2;
    
        if(isnumeric(corr))
            % Add the values to the data vectors
            I = find(corr==scc_actual_one);
            if(~isempty(I))
               percent_error(1,I) = percent_error(1,I)+current_percent_error;
               percent_error_count(1,I) = percent_error_count(1,I)+1;
            else
                corr = [corr scc_actual_one];
                percent_error = [percent_error current_percent_error]; 
                percent_error_count = [percent_error_count 1];
            end
        end
        
end

% Sort the elements
percent_error = percent_error ./ percent_error_count;
[corr_sort,ind]=sort(corr, 2, 'descend');
percent_error_sort=percent_error(ind);

plot(corr_sort, percent_error_sort);