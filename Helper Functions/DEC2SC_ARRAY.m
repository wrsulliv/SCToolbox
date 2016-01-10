%{
Converts a matrix of unipolar decimal values (in the range [0:1]) to a matrix of
stochastic numbers.

Optimized = Yes

%}
function sc_array = DEC2SC_ARRAY(dec_array, sc_stream_length)

    %  Preallocate the sc_array for performance
    sc_array = zeros(size(dec_array, 1), sc_stream_length*size(dec_array, 2));
    
    for i = 1:size(dec_array,1)
        for j = 1:size(dec_array, 2) 
            offset_j = (j-1)*sc_stream_length + 1;
            sc_array(i,offset_j:offset_j+sc_stream_length-1) = SNG(dec_array(i,j), sc_stream_length);
        end
    end
end