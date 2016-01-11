function z = Bern2TTAsym(a)

	l_a = length(a);
	l_z = 2 ^ (l_a - 1);

	z = zeros(1, l_z);

	for i = 1: l_a
		temp = GiveAsymValues(a(i), nchoosek(l_a-1, i-1));
		index = zeros(1, l_a - 1);
		if(i-1 > 0)
			index(1:i-1) = ones(1, i-1);
		end
		index = unique(perms(index), 'rows');
		index = bin2dec(char(index + 48)) + 1;
		z(index) = temp;
	end
