function z = BernsteinFunctionVariable(input_vector, coeffs);

	if(length(input_vector) != ndims(coeffs))
		printf('In the Bernstein function, length of inputs and the coeffs are not the same\n');
		z = -1;
		return;
	end

	if(sum(input_vector == -1) > 0)
		printf('In the Bernstein function, there was a -1 input, i.e., out of bound input\n');
		z = -1;
		return;
	end

	sumsum = 0;

	nel = numel( coeffs );
	sz = size( coeffs );
	szargs = cell( 1, ndims( coeffs ) ); % We'll use this with ind2sub in the loop

	for i=1:nel
	    [ szargs{:} ] = ind2sub( sz, i ); % Convert linear index back to subscripts
		mult_term = 1;
		for j = 1: ndims(coeffs)
			index = [szargs{1, j}];
			mult_term = mult_term * BernTerm(input_vector(j), index-1, sz(j) - 1);
		end
		
		temp = mult_term * coeffs(i);
		sumsum = sumsum + temp;
	end

	z = sumsum;

end
