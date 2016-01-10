function bit_pairs = bitstream_pair_generator_input_vec_values(I, N)

    bit_pairs = [];
    for i = 1:N
        bit_pairs = [bit_pairs discrete_distribution_sampler(I, [1 2 3 4])];
    end

end

