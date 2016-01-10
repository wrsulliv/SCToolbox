function var = calc_variance_2_input_orig_method(I, M, N)

m = 2; % Number of inputs
input_combos = m^2; % Number of input combinations
num_functions = input_combos^2; % Number of functions


f = zeros(input_combos, num_functions);
%  Calculate the f vectors
index_counter = 1;
for one_one = 0:1
    for one_zero = 0:1
        for zero_one = 0:1
            for zero_zero = 0:1
                f(:, index_counter) = [zero_zero; zero_one; one_zero; one_one];
                index_counter = index_counter + 1;
            end
        end
    end
end
    
    
%  Now, determine the probability vector
p_f = zeros(1, num_functions);
for current_function = 1:num_functions
    prob = 1;
    for current_input_combo = 1:input_combos     
        prob = prob*M(current_input_combo, f(current_input_combo,current_function)+1);
    end
    p_f(current_function) = prob;
end


var = 0;
mean = 0;
for k = 1:num_functions
    mean = mean + I'*f(:,k)*p_f(k);
end

    var = mean*(1 - mean)^2 + (1 - mean)*(0 - mean)^2;

end