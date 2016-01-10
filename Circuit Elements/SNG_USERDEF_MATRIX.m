% Creates a matrix of SNs with bitstream length N

function S_mat = SNG_USERDEF_MATRIX(M, N)
    S_mat = zeros(size(M, 1), size(M,2)*N);
    for i = 1:size(M,1)
        for j = 1:size(M,2)
            S = SNG(M(i,j), N);
            start_j_position = (j-1)*N + 1;
            end_j_position = start_j_position + N - 1;
            S_mat(i, start_j_position:end_j_position) = S;
        end
    end
end

