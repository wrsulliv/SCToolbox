function [avg, variance] = monte_carlo_circuit_sim_two_input(I, M, N, num_trials)

    % Create buffers for the result data
    samples = [];
    
    for i = 1:num_trials
        bit_pairs = bitstream_pair_generator_input_vec_values(I, N);
        out_stream = [];
        for sample = 1:N
            funct_vec = circuit_function_selector_two_input(M);
            out_stream = [out_stream funct_vec(bit_pairs(sample))];
        end
        samples = [samples sum(out_stream)/length(out_stream)];
    end
    
    avg = mean(samples);
    variance = var(samples);
end