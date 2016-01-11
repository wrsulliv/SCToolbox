function [ out, poly, scale_factor ] = SIGMOID_SYNTHESIZED(in, degree, max_iterations, multiplier)
%SIGMOID_SYNTHESIZED Synthesized version of the log-sim function used by
%Matlab's neural network toolbox. 
%   (in): a (1xN) vector of input bits

% First, negate the input to convert from BP to IBP
in = NOT(in);

% Set variables
sc_len = length(in);
syms a;

% Define a sigmoidal function which is scaled for bi-polar interval
original_f = 2/(1+exp(-2*a*multiplier))-1;


% Create a polynomial approximation of the given function using a Maclaurin
% series:
poly = zeros(1, degree+1); % Vector of coeficients ordered from least to greatest
x = zeros(1, degree+1);
for n = 0:degree
    coef = diff(original_f,n)/(factorial(n));
    coefs((degree + 1) - n) = subs(coef, a, 0); 
    poly(n+1) = coefs((degree + 1) - n);
end


% Synthesize the circuit using the STRAUSS method
[multi, f, f_star, f_star_star, scale_factor] = Synthesize(poly, max_iterations);

% (f_star_star) is a vector which encodes the truth table for the
% synthesized circuit.  But, it is given such that (-1) encodes a 1 and (1)
% encodes a 0.  So, we convert the truth table from IBP to UP.
f_star_star = IBP_2_UNIPOL(f_star_star);


% Generate the bitstreams
INPUTS = zeros(log2(length(f_star_star)), sc_len);
num_inputs = log2(length(f_star_star));
current_stream = in;
for j = 1:num_inputs
    if(j <= degree)
        INPUTS(j, :) = current_stream;
        current_stream = DELAY(current_stream);
    else
        INPUTS(j, :) = SNG(0.5, sc_len);
    end
end


% Simulate the circuit!
curr_output = zeros(1, sc_len);
for j = 1:sc_len
    vec = INPUTS(:, j);
    dec = bi2de(vec');
    curr_output(j) = f_star_star(dec + 1 );

    
    curr_output(j) = (curr_output(j));

end

% At this point, (curr_output) is a bit-stream which 
% encodes an Inverted bipolar number.  So, convert it to BP with a NOT
% gate. 

out = NOT(curr_output);


end

