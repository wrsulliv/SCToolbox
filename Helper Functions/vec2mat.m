% Convert a 1-d vector into a matrix for example:
% vec2mat([1 2 3 4],2) = [1 2; 3 4]
function mat = vec2mat(vec, m)

n = (length(vec))/m;
mat = (reshape(vec, m, n))';