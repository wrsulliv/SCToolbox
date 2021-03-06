function Y = WriteBLIFBernWithSharing(TT, noOfX, noOfR, filename, modelname);


	%noOfR
	ll = length(TT);
	fp = fopen(filename, 'w');

	fprintf(fp, '.model %s\n\n', modelname);
	%fprintf(fp, '.search LFSR%d.blif\n\n', noOfR);
	fprintf(fp, '.inputs');
	for i=1:noOfX
		fprintf(fp, ' x%d', i);
	end
	for i=1:noOfR
		fprintf(fp, ' r%d', i);
	end

	%fprintf(fp, ' clk');
	fprintf(fp, '\n\n.outputs z\n\n');


	for bit=0:(floor(log2(noOfX)))
		fprintf(fp, '\n.names');
		for i=1:noOfX
			fprintf(fp, ' x%d', i);
		end
		fprintf(fp, ' add%d\n', bit);
		for i=0:(2^noOfX)-1
			if(giveBit(sumBit(i), bit)==1)
				temp = dec2bin(i, noOfX);
				for j = 1: length(temp)
					fprintf(fp, '%c', temp(j));
				end
				fprintf(fp, ' 1\n');
			end
		end
	end

	%MUX
	fprintf(fp, '\n\n.names');
	for bit=(floor(log2(noOfX))):-1:0
		fprintf(fp, ' add%d', bit);
	end
	for i=0:noOfX
		fprintf(fp, ' wire%d_1', i+1);
	end
	fprintf(fp, ' z\n');
	for i=0:noOfX
		for j=(floor(log2(noOfX))):-1:0
			fprintf(fp, '%d', giveBit(i, j));
		end
		for j=0:noOfX
			if(i==j)
				fprintf(fp, '1');
			else
				fprintf(fp, '-');
			end
		end
		fprintf(fp, ' 1\n');
	end

	
	
	fprintf(fp, '\n\n.names x1 ONE\n0 1\n1 1\n\n.names ONE ZERO\n1 0\n\n');

	
	prob_table = zeros(1, 4);
	%prob, level, wire_number1, wire_number2


	for i=1:ll
		
		temp = round(TT(i)*(2^noOfR))/(2^noOfR); %round to closes representable number given noOfR
		fprintf(fp, '\n\n');

		for j=1:noOfR+1
			if(temp == 1)
				fprintf(fp, '\n.names ONE wire%d_%d\n1 1\n', i, j);
				break;
			elseif(temp == 0)
				fprintf(fp, '\n.names ZERO wire%d_%d\n1 1\n', i, j);
				break;
			else
				if(size(find(prob_table(:, 1) == temp), 1) ~= 0) %prob exists
					index = find(prob_table(:, 1) == temp);
					temp2 = prob_table(index, :);
					if(size(find(temp2(:, 2) == j), 1) ~= 0) %the same level
						index2 = find(temp2(:, 2) == j);
						temp2 = temp2(index2, :);
						fprintf(fp, '\n.names wire%d_%d wire%d_%d\n1 1\n', temp2(1, 3), temp2(1, 4), i, j);
						break;
					end
				end

				if(size(find(prob_table(:, 1) == 1 - temp), 1) ~= 0) %prob inverse exists
					index = find(prob_table(:, 1) == 1 - temp);
					temp2 = prob_table(index, :);
					if(size(find(temp2(:, 2) == j), 1) ~= 0) %the same level
						index2 = find(temp2(:, 2) == j);
						temp2 = temp2(index2, :);
						fprintf(fp, '\n.names wire%d_%d wire%d_%d\n0 1\n', temp2(1, 3), temp2(1, 4), i, j);
						%printf('\ncontinue seen %d %d\n', i, j)
						break;
					end
				end

				%printf('\ncontinue not applied %d %d\n', i, j)
				new_row = [temp, j, i, j];
				prob_table = [prob_table ; new_row];
				if(temp < 0.5)
					fprintf(fp, '\n.names r%d wire%d_%d wire%d_%d\n11 1\n', j, i, j+1, i, j);
					temp = 2*temp;
				else
					fprintf(fp, '\n.names r%d wire%d_%d wire%d_%d\n00 0\n', j, i, j+1, i, j);
					temp = 2*temp - 1;
				end
			end
		end


		%fprintf(fp, '\n.names');
		%for j=1:noOfR
		%	fprintf(fp, ' r%d', j);
		%end
		%fprintf(fp, ' wire%d\n', i);
		%temp = (1-TT(i+1))/2; % convert to unipolar
		%temp = round(temp*(2^noOfR)); %round to closes representable number given noOfR
		%%temp tells you how many 1s you need	
		%for j=0:temp-1
		%	for k=noOfR-1:-1:0
		%		fprintf(fp, '%d', giveBit(j, k));
		%	end
		%	fprintf(fp, ' 1\n');
		%end

	end

	%fprintf(fp, '\n.subckt LFSR%d clk=clk', noOfR);
	%for i=1:noOfR
	%	fprintf(fp, ' s%d=r%d', i, i);
	%end

	fprintf(fp, '\n\n.end\n');
	
	fflush(fp);
	fclose(fp);



	

