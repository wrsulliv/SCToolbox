% A script to test the SCC probability distribution which uses the a,b,c,d
% elements of the definition of SCC to get an exact estimate for the mean
% of the SCC between a pair of bitstreams with given stochastic values.

N = 100;
p1 = 0.2;
p2 =  0.4;

% Get an actual estimate of the SCC
scc = 0;
iterations = 100000;
for i = 1:iterations
    s1 = SNG(p1, N);
    s2 = SNG(p2, N);
    scc = scc + sc_correlation(s1, s2);
end
actual = scc / iterations

% Compute the expected SCC
sum = 0;
prob_sum = 0;
for a = 0:N
    for b = 0:(N-a)
        for c = 0:(N-a-b)
            d = N-a-b-c;
            prob = getProbabilityABCD(a,b,c,d,p1,p2,N);
            corr = sc_correlation_abcd(a,b,c,d,N);
            sum = sum + prob*corr;
            prob_sum = prob_sum + prob;
        end
        
        if(N-a-b == 0)
            prob = getProbabilityABCD(a,b,0,0,p1,p2,N);
            corr = sc_correlation_abcd(a,b,0,0,N);
            sum = sum + prob*corr;
            prob_sum = prob_sum + prob;
        end
    end
    
     if(N-a == 0)
        prob = getProbabilityABCD(a,0,0,0,p1,p2,N);
        corr = sc_correlation_abcd(a,0,0,0,N);
        sum = sum + prob*corr;
        prob_sum = prob_sum + prob;
     end
end

expected = sum
prob_sum




