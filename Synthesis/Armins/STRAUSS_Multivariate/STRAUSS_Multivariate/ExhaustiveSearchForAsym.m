function z = ExhaustiveSearchForAsym(a, noOfR)

	%gets a BernTT and finds the best sym/asym TT
	%algorithm exhaustuve 
	

	l_a = length(a);
	l_z = 2 ^ (l_a - 1);
	temp_filename = sprintf('octave_tempfile.blif');
	temp_modelname = sprintf('octave_tempfile');
	noOfX = length(a) - 1;

	zSym = zeros(1, l_z);
	zSym = Bern2TTSymQuantized(a, noOfR);

	WriteBLIFWithSharing(zSym, noOfX, noOfR, temp_filename, temp_modelname);
	
	best_sop = CalculateSoP(temp_filename);
	best_index = 0;

	z = Bern2TTAsymPermQuantized(a, noOfR);

	for j=1:size(z, 1)
		WriteBLIFWithSharing(z(j, :), noOfX, noOfR, temp_filename, temp_modelname);
		temp_sop = CalculateSoP(temp_filename);
		if(temp_sop < best_sop)
			best_sop = temp_sop;
			best_index = j;
		end
	end
	%best_sop
	%best_index

	%z = [best_sop best_index];
	if(best_index == 0)
		z = zSym;
	else
		z = z(j, :);
	end
