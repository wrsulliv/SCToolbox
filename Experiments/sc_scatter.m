
n = 10000;
p = 0.2;
sc_length = 256;
mse = 0;
expected = p;

mse = 0;

expected = p;
for i = 1:n
    randomStream = sc_prng(p, sc_length);
    randomStream2 = sc_prng(p, sc_length);
    y = MUX(randomStream, randomStream2);
    number = (sum(y)/sc_length);
    mse = mse + (expected - number)^2;
end
mse = mse / n;
mse


% Simulate without the delay and mux
%[coor_data, mse_data, corr_data_mux, mse_data_mux] = sc_simulate(1/8, 3/8, n);
%scatter(coor_data, mse_data);
%hold on;


%[coor_data, mse_data, corr_data_mux, mse_data_mux] = sc_simulate(6/8, 3/8, n);
%hold on;
%scatter(coor_data, mse_data);


% Simulate with the delay and mux


