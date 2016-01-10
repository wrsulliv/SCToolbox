%{

Description:  
(IN) is a matrix where each row is a stochastic number.  This function
outputs the logical AND of the columns of this matrix.
%}
function [y] = AND_MAT(IN)
    y = prod(IN);
end