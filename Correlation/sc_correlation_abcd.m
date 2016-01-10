% Computes the SCC correlation of a,b,c,d values described in Alaghi's
% correlation paper

function y = sc_correlation_abcd(a,b,c,d,n)

    numerator = a*d - b*c;
    if (numerator == 0)
        y = 0;
    else
        if(a*d > b*c)
            minval = min([a+b a+c]);
            denominator = n*minval-(a+b)*(a+c);
            y = numerator / denominator;
        else
            maxval = max([a-d 0]);
            denominator = (a+b)*(a+c)-n*maxval;
            y = numerator / denominator;
        end
    end
end