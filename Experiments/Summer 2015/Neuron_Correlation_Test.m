% This experiment demontrates the idea that correlation between layers in a
% the SC neural network will not affect the output.  Each layer will
% compute correctly if the input pairs at each XNOR gate are independent.  

num_iterations = 1000;
N = 10000;
norm_c = 1;
fsm_states = 2*3*norm_c;

i = rand(6, 2);
i = [.1 .3; .7 .8; .9 .8; .1 .1; .2 .3; .8 .6];
i(3, :) = 1; % Set the bias to be multilied by ones
i(6, :) = 1; % Set the bias to be multilied by ones

w = [.2 .5; .3 .9; .7 .4; .1 .5; .2 .9; .8 .3]*norm_c;
%w = rand(6, 2)*norm_c;
w_normalized = w./norm_c;
    
%  The layers, neurons, weights and inputs are indexed starting at 1.
% The jth weight to the ith neuron in layer k is given by: w(j+2*(i-1), k)
% The jth input to the ith neuron in layer k is given by: i(j+2*(i-1), k)
% The biases are built into the weight and input matrices.
    
corr = [];
percent_error = [];
percent_error_count = [];
for iteration = 1:num_iterations
    iteration
i_sc = SNG_USERDEF_MATRIX(i, N);
w_sc = SNG_USERDEF_MATRIX(w, N);

i_actual = UNIPOL_2_BIPOL(S2D_ARRAY(i_sc, N));
w_actual = UNIPOL_2_BIPOL(S2D_ARRAY(w_sc, N));

% Run the feedforward simulation with a single hidden layer of 2 sigmoidal
% neurons and an output layer with a single sigmoidal neuron.  
OUT_1 = NEURON(i_sc(1:3, 1:N), w_sc(1:3, 1:N), fsm_states, false, false);
OUT_2 = NEURON(i_sc(4:6, 1:N), w_sc(4:6, 1:N), fsm_states, false, false);
O = NEURON([OUT_1; OUT_2; ones(1, N)], w_sc(1:3, N+1:end), fsm_states, false, false);
o_actual = UNIPOL_2_BIPOL(S2D_ARRAY(O, N));

% Now compute the expected
out_1 = tanh(i_actual(1:3, 1)'*w_actual(1:3, 1));
out_2 = tanh(i_actual(4:6, 1)'*w_actual(4:6, 1));
o_expected = tanh([out_1 out_2 1]*w_actual(1:3, 2));

sc_corr = sc_correlation(OUT_1, OUT_2);
current_percent_error = PercentError(o_expected, o_actual);
    
        if(isnumeric(corr))
            % Add the values to the data vectors
            I = find(corr==sc_corr);
            if(~isempty(I))
               percent_error(1,I) = percent_error(1,I)+current_percent_error;
               percent_error_count(1,I) = percent_error_count(1,I)+1;
            else
                corr = [corr sc_corr];
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