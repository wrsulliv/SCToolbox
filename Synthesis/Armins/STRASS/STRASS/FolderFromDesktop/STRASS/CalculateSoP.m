function z = CalculateSoP(filename)

	%calculates cost (literal count) of a BLIF file

	input_filename = sprintf('octave_input.txt');
	output_filename = sprintf('octave_output.txt');
	output_filename2 = sprintf('octave_output2.txt');
	
	fp = fopen(input_filename, 'w');
	fprintf(fp, 'read_blif %s\n', filename);
	fprintf(fp, 'source script.rugged\nprint_stats\nquit\n');
	fflush(fp);
	fclose(fp);

	command = sprintf('sis < %s > %s', input_filename, output_filename);
	system(command);
		
	command = sprintf('cat %s | grep sop > %s', output_filename, output_filename2);
	system(command);

	fp = fopen(output_filename2, 'r');
	data = fscanf(fp, 'lits(sop)=%d');
	fclose(fp);
	z = data;

	command = sprintf('rm %s', input_filename);
	system(command);
	command = sprintf('rm %s', output_filename);
	system(command);
	command = sprintf('rm %s', output_filename2);
	system(command);

end
