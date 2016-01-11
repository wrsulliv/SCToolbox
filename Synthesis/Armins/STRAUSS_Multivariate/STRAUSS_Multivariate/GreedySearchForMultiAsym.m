function z = GreedySearchForMultiAsym(a, noOfInputs, orders, noOfR)

	%gets a Multivariate BernTT and finds the best sym/asym TT
	%algorithm greedy
	%first input is the inner loop 

	search_limit = 4;
	l_a = length(a);

	
	temp_filename = sprintf('octave_tempfile.blif');
	temp_modelname = sprintf('octave_tempfile');
	
		l_z = 1;
	z_orders = 2 .^ (orders-1);
	
	for i=1:noOfInputs
		l_z = l_z * (z_orders(i));
	end
	noOfX = log2(l_z);

	z = zeros(1, l_z);
	index = zeros(l_a, noOfInputs);
	final_index = zeros(l_a, l_z);

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
		%final_index = [];
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
				final_index(i, j) = 1;
			end
		end
		final_index;
		z(find(final_index(i, :))) = a(i);
		%repititions = 1;
		%for j = 1:noOfInputs
		%	repititions = repititions * (nchoosek(orders(j), index(i, j)));
		%end

		%temp = GiveAsymValuesQuantized(a(i), repititions, noOfR)
		%temp2 =  unique(perms(temp), "rows")

	end

	%assuming sym z is the current best z
	best_z = z;
	WriteBLIFWithSharing(z, noOfX, noOfR, temp_filename, temp_modelname);
	best_sop = CalculateSoP(temp_filename);
	sym_sop = best_sop

	
	for count = 1: 2
		for i = 1: l_a
			repititions = 1;
			for j = 1:noOfInputs
				repititions = repititions * (nchoosek(orders(j)-1, index(i, j)-1));
			end
				temp_values = GiveAsymValuesQuantized(a(i), repititions, noOfR);

				%test current initial asym ordering
				z_temp = best_z;
					%alaki = find(final_index(i,:))
					%temp_values
				alaki_temp_values = temp_values;
				z_temp(find(final_index(i,:))) = alaki_temp_values;
				WriteBLIFWithSharing(z_temp, noOfX, noOfR, temp_filename, temp_modelname);
				temp_sop = CalculateSoP(temp_filename);
				if(temp_sop < best_sop)
					best_z = z_temp;
					best_sop = temp_sop;
				end
			if(repititions > 1)

				%test reverse of initial asym ordering
				z_temp = best_z;
				alaki_temp_values = temp_values(length(temp_values):-1:1);
				z_temp(find(final_index(i,:))) = alaki_temp_values;
				WriteBLIFWithSharing(z_temp, noOfX, noOfR, temp_filename, temp_modelname);
				temp_sop = CalculateSoP(temp_filename);
				if(temp_sop < best_sop)
					best_z = z_temp;
					best_sop = temp_sop;
				end

							
				for search=1:search_limit
					%shuffle temp_values
					z_temp = best_z;
					alaki_temp_values = temp_values(randperm(length(temp_values)));
					z_temp(find(final_index(i,:))) = alaki_temp_values;
					WriteBLIFWithSharing(z_temp, noOfX, noOfR, temp_filename, temp_modelname);
					temp_sop = CalculateSoP(temp_filename);
					if(temp_sop < best_sop)
						best_z = z_temp;
						best_sop = temp_sop;
					end
				end
			end
			
		end
	end

	best_sop
	z = best_z;
