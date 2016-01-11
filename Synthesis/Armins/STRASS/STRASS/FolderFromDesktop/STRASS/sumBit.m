function Y = sumBit(a); %sums number of bits

	Y = 0;
	for i=0:ceil(log2(a))
		Y = Y + giveBit(a, i);	
	end

