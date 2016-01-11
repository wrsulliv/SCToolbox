function z = MultiBern2TTSymQuantized(a, noOfInputs, orders, noOfR)

	%gets a multi variate Bern TT "a" and converts it to a sym TT
	%orders carries the orders of the inputs
	%note that the first input is the inner loop in "a" and the last input is the outter loop


	l_a = length(a);

	l_z = 1;
	z_orders = 2 .^ (orders-1);
	
	for i=1:noOfInputs
		l_z = l_z * (z_orders(i));
	end

	z = zeros(1, l_z);
	index = zeros(l_a, noOfInputs);

	for i = 1: l_a
		i;
		temp_i = i;
		temp_l_a = l_a;
		for j=noOfInputs:-1:1
			j;
			index(i, j) = ceil(temp_i / (temp_l_a / orders(j)));
			temp_i = temp_i - ((index(i, j) - 1) * (temp_l_a / orders(j)));
			temp_l_a = temp_l_a / orders(j);
		end

		new_index = zeros(1, noOfInputs);
		final_index = [];
		for j=1:l_z
			temp_j = j;
			temp_l_z = l_z;
			for k=noOfInputs:-1:1
				new_index(k) = ceil(temp_j / (temp_l_z / z_orders(k)));
				temp_j = temp_j - ((new_index(k) - 1) * (temp_l_z / z_orders(k)));
				temp_l_z = temp_l_z / z_orders(k);
			end
			new_index;	
			test = 1;
			for k=1:noOfInputs
				temp_index = sum(dec2bin(new_index(k)-1)-48) + 1;
				if(temp_index ~= index(i, k))
					test = 0;
				end
			end
			if (test == 1)
				final_index = [final_index, j];
			end
		end
		final_index;
		z(final_index) = a(i);
		%repititions = 1;
		%for j = 1:noOfInputs
		%	repititions = repititions * (nchoosek(orders(j), index(i, j)));
		%end

		%temp = GiveAsymValuesQuantized(a(i), repititions, noOfR)
		%temp2 =  unique(perms(temp), "rows")

	end
	return

		index = zeros(1, l_a - 1);
		if(i-1 > 0)
			index(1:i-1) = ones(1, i-1);
		end
		index = unique(perms(index), "rows");
		index = bin2dec(char(index + 48)) + 1;
		
		%z(index) = temp;
		
		z_temp = zeros(size(z,1)*size(temp2,1), l_z);

		for j=1:size(z,1)
			for k=1:size(temp2, 1)
				z_temp((j-1)*size(temp2,1)+k, :) = z(j, :);
				z_temp((j-1)*size(temp2,1)+k, index) = temp2(k, :);
			end
		end
		
		z = z_temp;
	end
