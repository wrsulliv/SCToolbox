function z = Bern2TTSym(a)

	l_a = length(a);
	l_z = 2 ^ (l_a - 1);

	z = zeros(1, l_z);

	for i = 1: l_z
		j = sum(dec2bin(i-1)-48);
		z(i) = a(j+1);
	end
