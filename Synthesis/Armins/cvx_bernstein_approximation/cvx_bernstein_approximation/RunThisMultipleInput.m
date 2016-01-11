function error = RunThisMultipleInput(a, order, complete_a);
    
    
    no_inputs = size(a, 2) - 1;
    x = a(:, 1:no_inputs);
    z = a(:, no_inputs+1);

    complete_x = complete_a(:, 1:no_inputs);
    complete_z = complete_a(:, no_inputs+1);

    

    input_offset = floor(min(x)) - 0;
    output_offset = floor(min(z)) - 0;
    
    x = x - repmat(input_offset, size(x, 1), 1);
    z = z - output_offset;
    complete_x = complete_x - repmat(input_offset, size(complete_x, 1), 1);
    complete_z = complete_z - output_offset;
    
    input_scale = (2*ones(1,length(input_offset))).^(ceil(log2(max(x))) + 0);
    output_scale = 2^(ceil(log2(max(z))) + 0);

    
    x = x ./ repmat(input_scale, size(x, 1), 1);
    z = z / output_scale;
    complete_x = complete_x ./ repmat(input_scale, size(complete_x, 1), 1);
    complete_z = complete_z / output_scale;

  
    
    
    degrees = ones(1,no_inputs) * order;
    
    
    M = BernsteinVectorGenerator(x, degrees);
    complete_M = BernsteinVectorGenerator(complete_x, degrees);
    coeff_len = size(M, 2);
    
    cvx_begin
        cvx_precision best
        variable A(coeff_len, 1)
        minimize(norm((((z*output_scale) + output_offset) - (((M*A)*output_scale) + output_offset)), 1)) %./ ((z*output_scale) + output_offset)
        subject to
        zeros(coeff_len,1) <= A <= ones(coeff_len,1)
    cvx_end
    
    %A;
    A
    
    complete_z_new = complete_M*A;
    
    %err = (complete_z - complete_z_new).^2;% ./ complete_z;
    
    
    
    complete_z_new = (complete_z_new * output_scale) + output_offset;
    complete_z = (complete_z * output_scale) + output_offset;
    complete_x = (complete_x .* repmat(input_scale, size(complete_x, 1), 1)) + repmat(input_offset, size(complete_x, 1), 1);
    
    max(complete_z)
    max(complete_z_new)
    %[z, z_new, z - z_new]
    
    %[complete_x complete_z complete_z_new abs(complete_z - complete_z_new)];
    %subplot(1, 2, 1);
    %scatter3(complete_x(:, 1), complete_x(:, 2), complete_z);
    %hold off;
    %plot(complete_x, complete_z);
    %subplot(1, 2, 2);
    %scatter3(complete_x(:, 1), complete_x(:, 2), complete_z_new);
    %hold on;
    %plot(complete_x, complete_z_new);
    
    %absolute relative error
    err = abs((complete_z - complete_z_new) ./ complete_z);
    
    %saturate error
    index = find(err > 1);
    err(index) = 1;
    
    abs_relative_error = mean(err);
    %error = sqrt(error);
    
    %error relative to range
    err = abs((complete_z - complete_z_new) ./ (max(complete_z) - min(complete_z)));
    error_relative_to_range = mean(err);
    
    %error = error_relative_to_range;
    error = abs_relative_error;
    
    %expected error, input_offset_input_scale, output_offset, output_scale
    %order, weights
    fp = fopen('output.txt', 'w');
    
    fprintf(fp, '%f\n%d\n', error, length(input_offset));
    
    %fprintf(fp, '\ninput offsets:\n');
    for i=1:length(input_offset)
        fprintf(fp, '%f\n', input_offset(i));
    end
    
    %fprintf(fp, '\ninput scales:\n');
    for i=1:length(input_scale)
        fprintf(fp, '%f\n', input_scale(i));
    end

    for i=1:length(input_scale)
        fprintf(fp, '%d\n', order);
    end
    
    fprintf(fp, '%f\n', output_offset);
    fprintf(fp, '%f\n', output_scale);
    
    fprintf(fp, '%d\n', length(A));
    
    %fprintf(fp, '\nweights:\n');
    for i=1:length(A)
        fprintf(fp, '%f\n', A(i));
    end
    
    %fflush(fp);
    fclose(fp);
    %max(z_new)
    %min(z_new)
    
    %error = sqrt(mean((z - M*A).^2));
    %error = mean(abs(z - M*A));
    
end