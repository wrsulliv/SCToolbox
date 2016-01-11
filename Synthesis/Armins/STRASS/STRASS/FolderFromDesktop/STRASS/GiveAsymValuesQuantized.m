function z = GiveAsymValuesQuantized(a, n, noOfR)

	%gets a constant value a, and its number of repition
	%gives the possible quantized asym with all (but one) elements equal to 0/1
	%this can be used to find the best permutation


	if(a == 1)
		z = ones(1, n);
		return;
	end
	
	b = floor(a * n);
	zz = zeros(1, n-1);

	if(b > 0)
		zz(1:b) = ones(1, b);
	end

	c = n*a - sum(zz);
	q = noOfR - floor(log2(n));
	c = round(c * (2^q))/(2^q);
	z = [zz, c];

	%if(mean(z) != a)
	%	printf('error: %f != %f\n', mean(z), a);
	%end
	
