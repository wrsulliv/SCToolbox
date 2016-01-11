function Y = WriteBLIFWithoutSharing(TT, noOfX, noOfR, filename, modelname);

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

	
	fprintf(fp, '\n\n.names x1 ONE\n0 1\n1 1\n\n.names ONE ZERO\n1 0\n\n');

	fprintf(fp, '.names');
	for i=1:noOfX
		fprintf(fp, ' x%d', i);
	end
	for i=1:(ll)
		fprintf(fp, ' wire%d', i);
	end
	fprintf(fp, ' z\n');
	for i=0:(ll-1)
		for j=noOfX-1:-1:0
			fprintf(fp, '%d', giveBit(i, j));
		end
		for j=0:(ll-1)
			if(i==j)
				fprintf(fp, '1');
			else
				fprintf(fp, '-');
			end
		end
		fprintf(fp, ' 1\n');
	end


	
	prob_table = zeros(1, 4);
	%prob, level, wire_number1, wire_number2


	for i=1:ll
		
		temp = round(TT(i)*(2^noOfR)); %round to closes representable number given noOfR
		fprintf(fp, '\n\n');
		
		fprintf(fp, '.names');
		for j=1:noOfR
			fprintf(fp, ' r%d', j);
		end
		fprintf(fp, ' wire%d\n', i);
		for j=0:temp-1
			for k=noOfR-1:-1:0
				fprintf(fp, '%d', giveBit(j, k));
			end
			fprintf(fp, ' 1\n');
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



	

