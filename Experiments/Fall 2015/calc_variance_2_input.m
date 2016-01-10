function var = calc_variance_2_input(I, M, N)

    mean = I'*M(:,2);
    var = mean*(1-mean)/N;

end