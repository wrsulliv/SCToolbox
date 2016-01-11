function Y = WriteVerilogBernWithSharing(TT, noOfX, noOfR, filename, modelname);

	%writes Verilog with Qian's structure
	%TT is in Bern Format

	Y = 0;
	%noOfR
	fp = fopen(filename, 'w');

	fprintf(fp, 'module %s(x, r, z);\n\n', modelname);
	%fprintf(fp, '.search LFSR%d.blif\n\n', noOfR);
	%fprintf(fp, '.inputs');

	fprintf(fp, '\tinput [%d: 0] x;\n', noOfX-1);
	fprintf(fp, '\tinput [%d: 0] r;\n', noOfR-1);
	fprintf(fp, '\toutput reg z;\n');


	%fprintf(fp, '\n\twire [%d: 0] temp_wire;\n', ll-1);
	fprintf(fp, '\n\twire')
	for i=1:noOfX+1
		if(i ~= noOfX+1)
			fprintf(fp, ' wire%d_1,', i-1);
		else
			fprintf(fp, ' wire%d_1;\n', i-1);
		end
	end

	fprintf(fp, '\twire [%d: 0] sumOut;\n', ceil(log2(noOfX))-1);
	fprintf(fp, '\n\tassign sumOut = ');
	for i=1:noOfX
		if(i ~= noOfX)
			fprintf(fp, 'x[%d] + ', i-1);
		else
			fprintf(fp, 'x[%d];\n', i-1);
		end
	end



	fprintf(fp, '\n\talways @(*) begin\n');

	fprintf(fp, '\t\tz = 0;\n');
	fprintf(fp, '\t\tcase(sumOut)\n');

	for i=1:noOfX+1
		fprintf(fp, "\t\t\t%d'd%d: z = wire%d_1;\n", noOfX, i-1, i-1);
	end

		fprintf(fp, "\t\t\tdefault: z = 0;\n");
		fprintf(fp, "\t\tendcase\n");

	fprintf(fp, '\tend\n');


	
	prob_table = zeros(1, 4);
	%prob, level, wire_number1, wire_number2


	for i=1:noOfX+1
		
		temp = round(TT(i)*(2^noOfR))/(2^noOfR); %round to closes representable number given noOfR
		fprintf(fp, '\n\n');
		%fprintf(fp, '\n\n\twire');

		%for j=1:noOfR+1
		%	if(j ~= noOfR+1)
		%		if(j ~= 1)
		%			fprintf(fp, ' wire%d_%d,', i-1, j);
		%		end
		%	else
		%		fprintf(fp, ' wire%d_%d;\n\n', i-1, j);
		%	end
		%end
		for j=1:noOfR+1
			if(temp == 1)
				fprintf(fp, '\tassign wire%d_%d = 1;\n', i-1, j);
				break;
			elseif(temp == 0)
				fprintf(fp, '\tassign wire%d_%d = 0;\n', i-1, j);
				break;
			else
				if(size(find(prob_table(:, 1) == temp), 1) ~= 0) %prob exists
					index = find(prob_table(:, 1) == temp);
					temp2 = prob_table(index, :);
					if(size(find(temp2(:, 2) == j), 1) ~= 0) %the same level
						index2 = find(temp2(:, 2) == j);
						temp2 = temp2(index2, :);
						fprintf(fp, '\tassign wire%d_%d = wire%d_%d;\n', i-1, j, temp2(1, 3)-1, temp2(1, 4));
						break;
					end
				end

				if(size(find(prob_table(:, 1) == 1 - temp), 1) ~= 0) %prob inverse exists
					index = find(prob_table(:, 1) == 1 - temp);
					temp2 = prob_table(index, :);
					if(size(find(temp2(:, 2) == j), 1) ~= 0) %the same level
						index2 = find(temp2(:, 2) == j);
						temp2 = temp2(index2, :);
						fprintf(fp, '\tassign wire%d_%d = ~wire%d_%d;\n', i-1, j, temp2(1, 3)-1, temp2(1, 4));
						%printf('\ncontinue seen %d %d\n', i, j)
						break;
					end
				end

				%printf('\ncontinue not applied %d %d\n', i, j)
				new_row = [temp, j, i, j];
				prob_table = [prob_table ; new_row];
				if(temp < 0.5)
					fprintf(fp, '\twire wire%d_%d;\n\tassign wire%d_%d = (r[%d] & wire%d_%d);\n',i-1, j+1, i-1, j, noOfR - j, i-1, j+1);
					temp = 2*temp;
				else
					fprintf(fp, '\twire wire%d_%d;\n\tassign wire%d_%d = (r[%d] | wire%d_%d);\n',i-1, j+1, i-1, j, noOfR - j, i-1, j+1);
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

	fprintf(fp, '\n\nendmodule\n');
	
	fflush(fp);
	fclose(fp);



	

