function [avg, variance] = functional_monte_carlo_circuit_sim_two_input(I, M, N, num_trials)

m = 2; % Number of inputs
input_combos = m^2; % Number of input combinations
num_functions = input_combos^2; % Number of functions

    % Create buffers for the result data
    count = zeros(1, num_functions);
    var_vec = zeros(1, num_functions);
    samples = [];
    for i = 1:num_trials
        bit_pairs = bitstream_pair_generator_input_vec_values(I, N);
        for sample = 1:N
                [funct_vec, funct_num] = circuit_function_selector_two_input(M);
                out_stream = funct_vec(bit_pairs(sample));
                result = sum(out_stream)/length(out_stream);
                var_vec(funct_num) = var_vec(funct_num) + result; 
                count(funct_num) = count(funct_num) + 1;
                samples = [samples result];
        end
    end
    
   
    function_means = var_vec ./ count;
    function_means(isnan(function_means))=0;
    avg = mean(samples);
    variance = 0;
    for func = 1:num_functions
        variance = variance + (count(func)/length(samples))*(function_means(func) - avg)^2;
    end
end