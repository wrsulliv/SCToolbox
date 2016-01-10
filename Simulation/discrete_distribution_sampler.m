function val = discrete_distribution_sampler(P, V)

p = cumsum([0; P(1:end-1).'; 1+1e3*eps]); % Ensure it's a valid probabilty 
%  distribution and alter the vec to help the next funciton
[a a] = histc(rand,p); 
val = V(a);

end

% Found help in creating this function here: 
% http://www.mathworks.com/matlabcentral/answers/23319-easy-question-with-probability