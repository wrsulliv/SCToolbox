%  Computes the Maclaurin series of the sigmoid function
clear
degree =2;
x_range = 0:0.02:1;
max_iterations = 10;
IBP_x_range = 1 - 2*x_range;

syms a;

% Define a sigmoidal function which is scaled for bi-polar interval
%original_f = (2.7*(1 /(1 + exp(-2*a)) - 0.5))/1.8;
original_f = 0.4375 + 0.25*a - 0.8*a^2;
%original_f = 0.36*a^5 - 1.45*a^3 + 1.75*a;
%original_f = 1 + 2*a + 3*a^2;
%original_f = 0.34 + 0.2*a + 0.4*a^4
%original_f = a*1.75 - 1.45*a^3 + 0.36*a^5;
%original_f = 0 +  -0.4500*a + 0*a^2 + 1.3500*a^3 + 0*a^4
%original_f = 1 /(1 + exp(-a));
%original_f = 0 - .2*a + 0*a^2 + 1*a^3 + 0*a^4;

% Create a polynomial approximation of the given function using a Maclaurin
% series:
poly = zeros(1, degree+1); % Vector of coeficients ordered from least to greatest
x = zeros(1, degree+1);
for n = 0:degree
    coef = diff(original_f,n)/(factorial(n));
    coefs((degree + 1) - n) = subs(coef, a, 0); 
    poly(n+1) = coefs((degree + 1) - n);
end



%poly = [0 1.75 0 1.45 0 0.36];
%plot(x_range, subs(original_f, a, x_range), x_range, polyval(fliplr(poly), x_range))
%poly = [0 1.75 0 -1.45 0 0.36];
%poly = [0.4375 -0.25 -0.5625];

% original poly: 1 + 2X + 3X^2 + 4X^3
%poly = [1 2 3 4 5];
% multi-linear poly = 1 + [2(X1) + 2(X2) + 2(X3)]/3 + [3(X1)(X2) + 3(X2)(X3) + 3(X1)(x3)]/3 + 4(X1)(X2)(X3)      

[f_mult, x, f, f_star, f_star_star, scale_factor] = Synthesize(poly, max_iterations);


% This f_star_star vector is of size 512, where each entry corresponds to a
% truth table entry of x, r1, r2, r3, r4, r5, r6, r7, r8.  So, now we plot
% the actual stochastic output

sc_len = 10000;
avg_steps = 1;
outputs = zeros(1, length(x_range));
% Average the circuit behavior
for k = 1:avg_steps
    INPUTS = zeros(log2(length(f_star_star)), sc_len);
    for i = 1:length(x_range)
        % Generate the bitstreams
        num_inputs = log2(length(f_star_star));

        for j = 1:num_inputs
            if(j <= degree)
                INPUTS(j, :) = SNG(x_range(i), sc_len);   
            else
                INPUTS(j, :) = SNG(0.5, sc_len);
            end
        end
        %  NOTE: INPUTS is correct up to here

        % Get this x value's output stream
        curr_output = zeros(1, sc_len);
        for j = 1:sc_len
            vec = INPUTS(:, j);
            dec = bi2de(vec');
            curr_output(j) = f_star_star(dec + 1 );
            
            % Convert the output from IBP to UP
            curr_output(j) = (curr_output(j));

        end

        % At this point, (curr_output) is a bit-stream which 
        % encodes an Inverted bipolar number.  So, we need to convert 
        % from the uni-polar encoding to the inverted bi-polar encoding ...
        outputs(i) = outputs(i) + (S2D_ARRAY(curr_output, sc_len)); 
    end
end
outputs = outputs ./ avg_steps;

% Plot the results
fig = figure();

% Fourier Transform f_star
f_star_num_inputs = degree;
f_star_transform = 1/(2^f_star_num_inputs)*hadamard(length(f_star))*f_star;

% Fourier Transform f_star_star
f_star_star_num_inputs = log2(length(f_star_star));
f_star__star_transform = 1/(2^f_star_star_num_inputs)*hadamard(length(f_star_star))*f_star_star';

%polyval(fliplr(Multi2Poly(1/(2^log2(length(f_star_star)))*hadamard(length(f_star_star))*f_star_star'))
hold on;

cmap = colormap(jet)
num_plots = 5;
cmap_increment = size(cmap, 1)/num_plots;
plot(IBP_x_range, subs(original_f, a, IBP_x_range),'-o', 'Color', cmap(8, :));
plot(IBP_x_range, subs(fliplr(f_mult), x, IBP_x_range), '-x', 'Color', cmap(16, :));
plot(IBP_x_range, scale_factor*polyval(fliplr(Multi2Poly(f_star_transform)), IBP_x_range), '-*', 'Color', cmap(24, :));
%plot(IBP_x_range, scale_factor*polyval(fliplr(Multi2Poly(f_star__star_transform)), IBP_x_range), 'Color', cmap(floor(4*cmap_increment), :));
plot(IBP_x_range, outputs*scale_factor, '-d', 'Color', cmap(56, :));
legend('Original', 'Multivariate', 'Scaled Multivariate', 'Stochastic');
axis([-1, 1, -1, 1])


% Create xlabel
xlabel('IBP Input   ','FontWeight','bold','FontSize',16);

% Create ylabel
ylabel('IBP Output   ','FontWeight','bold','FontSize',16);


