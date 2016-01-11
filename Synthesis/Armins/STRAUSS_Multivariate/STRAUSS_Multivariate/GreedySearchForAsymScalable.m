function z = GreedySearchForAsymScalable(a, noOfR)

	%gets a BernTT and finds the best sym/asym TT
	%algorithm greedy fast

	l_a = length(a);
	l_z = 2 ^ (l_a - 1);
	temp_filename = sprintf('octave_tempfile.blif');
	temp_modelname = sprintf('octave_tempfile');
	noOfX = length(a) - 1;

	z = zeros(1, l_z);
	z = Bern2TTSymQuantized(a, noOfR);
	%z(2) = 5
	for count = 1: 2
		for i = 1: l_a
			temp = GiveAsymValuesQuantized(a(i), nchoosek(l_a-1, i-1), noOfR)
			limit = 10;
			limit2 = 120
			if(nchoosek(l_a-1, i-1) > limit)
				temp2 = zeros(limit2, size(temp, 2))
				for j = 1: limit2
					temp2(j, :) = temp(randperm(size(temp, 2)))
				end
			else
				temp2 = perms(temp)
			end
			printf('\n\n******* I am here!! ******\n\n');
			fflush(stdout);
			temp2 =  unique(temp2, "rows");
			index = zeros(1, l_a - 1);
			if(i-1 > 0)
				index(1:i-1) = ones(1, i-1);
			end
			index = unique(perms(index), "rows");
			index = bin2dec(char(index + 48)) + 1;
			
			%z(index) = temp;
		
			if(size(temp2, 1) > limit2)
				rand_index = randperm(size(temp2, 1));
				temp2 = temp2(rand_index(1:limit2), :);
			end


			z_temp = zeros(size(z,1)*size(temp2,1), l_z);

			for j=1:size(z,1)
				for k=1:size(temp2, 1)
					z_temp((j-1)*size(temp2,1)+k, :) = z(j, :);
					z_temp((j-1)*size(temp2,1)+k, index) = temp2(k, :);
				end
			end

			best_sop = 10^10;
			best_index = 0;
			for j=1:size(z_temp, 1)
				WriteBLIFWithSharing(z_temp(j, :), noOfX, noOfR, temp_filename, temp_modelname);
				temp_sop = CalculateSoP(temp_filename);
				if(temp_sop < best_sop)
					best_sop = temp_sop;
					best_index = j;
				end
			end
			best_sop;
			best_index;

			z = z_temp(best_index, :);
		
		end
	end

