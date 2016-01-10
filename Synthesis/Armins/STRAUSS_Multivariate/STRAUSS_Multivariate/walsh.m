function Y = walsh(A);

	if(A == 0)
		Y = 1;
	else
		B = walsh(A-1);
		Y = [B, B; B, -B];
	endif
		

