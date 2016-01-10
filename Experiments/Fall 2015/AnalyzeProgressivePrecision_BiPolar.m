function [ current_N, did_keep_tolerance ] = AnalyzeProgressivePrecision_BiPolar(bitstream, tolerance, start_N)
    %Output the number of bits required to achieve the desired tolerance with
    %the provided bitstream.  Output -1 if the desired tolerance cannot be
    %achieved.
    current_N = start_N;
    did_keep_tolerance = true;
    while (1 == 1)
        
        % Check the boundary case to see if we've used the whole stream
        if (current_N > length(bitstream)/2)
            current_N = length(bitstream);
            did_keep_tolerance = false;
            return
        end
        
        first_block = bitstream(1:current_N);
        second_block = bitstream(current_N+1:2*current_N);

        % Now that we have the stochastic outputs, we need to convert these
        % to decimal again.
        dec_out_first_uni = S2D_ARRAY(first_block, current_N);
        dec_out_second_uni = S2D_ARRAY(second_block, current_N);

        % Convert the decimal numbers back to the original space
        dec_out_first_bi = UNIPOL_2_BIPOL(dec_out_first_uni);
        dec_out_second_bi = UNIPOL_2_BIPOL(dec_out_second_uni);

        change = abs(dec_out_first_bi - dec_out_second_bi);
        if (change < tolerance)
            return;
        else
            current_N = current_N*2;
        end
    end
end

