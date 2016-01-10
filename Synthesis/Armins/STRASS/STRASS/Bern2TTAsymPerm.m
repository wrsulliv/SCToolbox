function z = Bern2TTAsymPerm(a)

	l_a = length(a);
	l_z = 2 ^ (l_a - 1);

	z = zeros(1, l_z);
	%z(2) = 5

	for i = 1: l_a
		temp = GiveAsymValues(a(i), nchoosek(l_a-1, i-1));
		temp2 =  unique(perms(temp), "rows");
		index = zeros(1, l_a - 1);
		if(i-1 > 0)
			index(1:i-1) = ones(1, i-1);
		end
		index = unique(perms(index), "rows");
		index = bin2dec(char(index + 48)) + 1;
		
		%z(index) = temp;
		
		z_temp = zeros(size(z,1)*size(temp2,1), l_z);

		for j=1:size(z,1)
			for k=1:size(temp2, 1)
				z_temp((j-1)*size(temp2,1)+k, :) = z(j, :);
				z_temp((j-1)*size(temp2,1)+k, index) = temp2(k, :);
			end
		end

		z = z_temp;
	end
