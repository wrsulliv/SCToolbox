function z = BernTerm(x, i, n)

	coeff = nchoosek(n, i);
	z = (x.^i).*((1-x).^(n-i))*(coeff);

end
