% Computes the Pearson correlation of x1 and x2
function [a,b,c,d,y] = pearson_correlation(x1, x2)

    n = size(x1,2);
    % First, computer a,b,c,d
    a = 0;
    b = 0;
    c = 0;
    d = 0;
    for i = 1:n
        if((x1(1, i) == 1) && (x2(1, i) == 1))
            a = a + 1;
        elseif((x1(1, i) == 1) && (x2(1, i) == 0))
             b = b + 1;
        elseif((x1(1, i) == 0) && (x2(1, i) == 1))
            c = c + 1;
        else
            d = d + 1;
        end
    end

    numerator = a*d - b*c;
    denominator = sqrt((a+b)*(a+c)*(b+d)*(c+d));
    y = numerator / denominator;
end