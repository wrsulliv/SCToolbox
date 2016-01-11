function z = GiveAsymValues(a, n)

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
	z = [zz, c];

	%if(mean(z) != a)
	%	printf('error: %f != %f\n', mean(z), a);
	%end
	
