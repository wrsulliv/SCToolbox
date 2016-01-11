function z = BernsteinVectorGenerator(input_vector, input_orders);

	%if(length(input_vector) != length(input_orders))
	%	printf('In the Bernstein vector generator, length of inputs and the orders are not the same\n');
	%	z = -1;
	%	return;
	%end

	sumsum = 0;

	nel = prod(input_orders);
	sz = input_orders;
	szargs = cell( 1, length(input_orders) ); % We'll use this with ind2sub in the loop
	z = ones(length(input_vector), nel);

	for i=1:nel
	    [ szargs{:} ] = ind2sub( sz, i ); % Convert linear index back to subscripts
		%mult_term = 1;
		for j = 1: length(input_orders)
			index = [szargs{1, j}];
			z(:, i) = z(:, i) .* BernTerm(input_vector(:, j), index-1, sz(j) - 1);
		end
		%z(i) = mult_term;		
	end

end
