function Y = WriteBLIFCompare(TT, noOfX, noOfR, filename, modelname);

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
		fprintf(fp, ' comp%d', i);
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


		%comparators
	for i=1:ll
		temp = round(TT(i)*(2^noOfR)); %round to closes representable number given noOfR
		fprintf(fp, '\n\n');

		if(temp != 2^noOfR)
			if(temp != 0)
				for j=noOfR-1:-1:0
					if(j!=0)
						fprintf(fp, '\n\n.names');
						fprintf(fp, ' c_%d_%d r%d carry_%d_%d', i, j, j+1, i, j);
						fprintf(fp, ' carry_%d_%d\n', i, j+1);
						fprintf(fp, '10- 1\n001 1\n111 1\n');
					else
						fprintf(fp, '\n\n.names');
						fprintf(fp, ' c_%d_%d r%d', i, j, j+1);
						fprintf(fp, ' carry_%d_%d\n', i, j+1);
						fprintf(fp, '10 1\n');
					end
				end
				fprintf(fp, '\n\n.names carry_%d_%d comp%d\n1 1\n', i, noOfR, i);
			else
				fprintf(fp, '\n\n.names ZERO comp%d\n1 1\n', i);
			end
		else
			fprintf(fp, '\n\n.names ONE comp%d\n1 1\n', i);
		end
	end


	
	%constants


	for i=1:ll
		temp = round(TT(i)*(2^noOfR)); %round to closes representable number given noOfR
		fprintf(fp, '\n\n');
		if((temp != 2^noOfR) && (temp != 0))
			for j=0:noOfR-1
				fprintf(fp, '\n.names');
				if(giveBit(temp, j) == 1)
					fprintf(fp, ' ONE');
				else
					fprintf(fp, ' ZERO');
				end

				fprintf(fp, ' c_%d_%d\n1 1\n\n', i, j);
			end
		end
	end

	
	
	fprintf(fp, '\n\n.end\n');

	

	fflush(fp);
	fclose(fp);


