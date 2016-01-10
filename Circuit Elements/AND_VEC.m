% Computes the binary AND of each element in v
function [y] = AND_VEC(v)
    val = 1;
    for i = 1:length(v)
        val = val.*v(i);
    end
    y = val;
end