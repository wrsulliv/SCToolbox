%% Script to generate function values


	coeffs = [0.7 0.1 0.9 0.3];
	coeffs = round(coeffs * 64) / 64;

	xd = 0:255;
	x = xd/256;

	for i=1:length(x)
		z(i) = 0;
		for j=0:3
			z(i) = z(i) + coeffs(j+1)*BernTerm(x(i), j, 3);	
		end
	end
	z = round(z*256);
	
	fp = fopen('gawab.txt', 'w');
	
	for i=1:length(x)
		fprintf(fp, '%02x\n', z(i));
	end


	fflush(fp);
	fclose(fp);

	plot(xd, z);

