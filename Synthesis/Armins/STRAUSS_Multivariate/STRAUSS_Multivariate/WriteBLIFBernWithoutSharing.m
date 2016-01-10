function Y = WriteBLIFBernWithoutSharing(TT, noOfX, noOfR, filename, modelname);


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
		fprintf(fp, ' wire%d', i+1);
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


	fprintf(fp, '\n\n.end\n');
	
	fflush(fp);
	fclose(fp);



	

