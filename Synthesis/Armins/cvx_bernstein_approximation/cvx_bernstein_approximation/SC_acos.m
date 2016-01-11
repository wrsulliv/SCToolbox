function z = SC_acos(x, cycles, precision);


	z = pi/4;
	
	for i=1:cycles
		t = cos(z);
		rt = rand < t;
		rx = rand < x;
		if(rt > rx)
			z = z + 1/min(precision, (2^(ceil(log2(i/16)))));
			if(z > pi/2)
				z = pi/2;
			end
		elseif(rt < rx)
			z = z - 1/min(precision, (2^(ceil(log2(i/16)))));
			if(z < 0 )
				z = 0;
			end
		end
	end
	
	expected = acos(x)
	actual = z
		
		
		

