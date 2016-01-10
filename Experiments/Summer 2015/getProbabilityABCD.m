% Returns the probability of generating a specific a,b,c,d value given the
% values, the probability values of the bitstream (p1) and p2 and the 
% bitstream length (N)
function p = getProbabilityABCD(a,b,c,d,p1,p2,N)
    C = nchoosek(N, a)*nchoosek(N-a, b)*nchoosek(N-a-b, c);
    p = ((p1*p2)^a)*((p1*(1-p2))^b)*(((1-p1)*p2)^c)*(((1-p1)*(1-p2))^d)*C;
end