%{

    Description: 
    Converts a matrix of uni-polar stochastic numbers to a matrix of 
    decimal numbers.  This function takes as input an MxN (sc_matrix) 
    (where M is the number of stochastic numbers and N is the bit-stream length)
    matrix of stochastic bit-streams in the uni-polar format.  The function
    outpus a Mx1 vector where each row corresponds to the same row of the
    input matrix.

%}

function [dec_matrix] = S2D_ARRAY(sc_matrix, N)

    % Determine the dimensions of the decimal matrix
    dec_matrix = zeros(size(sc_matrix, 1), size(sc_matrix, 2) / N);
    
     for i = 1:size(dec_matrix,1)
        for j = 1:size(dec_matrix, 2) 
            offset_j = (j-1)*N + 1;
            dec_matrix(i,j) = sum(sc_matrix(i,offset_j:offset_j+N-1)) / N;
        end
     end
    
end