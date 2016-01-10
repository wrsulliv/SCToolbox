%  Test the correctness of our MUX hypothesis 
M = [1 0; .5 .5; .5 .5; 0 1];
%M = [0 0; 0 0; 0 0 ; 0 1];
N =1;
scc_values = -1:0.5:1;
var_bucket = zeros(1, length(scc_values));
var_bucket_sim = zeros(1, length(scc_values));
var_bucket_sim_functional = zeros(1, length(scc_values));
counter_bucket = zeros(1, length(scc_values));
var_bucket_sim_orig = zeros(1, length(scc_values));
var_bucket_analytic_functional = zeros(1, length(scc_values));
px = .5;
py = .5;
num_samples = 1000;

%[corr_data, mse_mean, mse_var, corr_percentage, corr_global_avg, mse_global_avg]  = mux_corr_test(px, py, N, 20000);
%plot(corr_data, mse_var);


for scc_index = 1:length(scc_values)
    %for px = 0:N
        px
        %for py = 0:N
            scc = scc_values(scc_index);
            I = calc_input_ptm(px,py,scc);
            var = calc_variance_2_input(I, M, N);
            [avg_sim, var_sim] = monte_carlo_circuit_sim_two_input(I', M, N, num_samples);
            var_sim_orig = calc_variance_2_input_orig_method(I,M, N);
            var_analytic_functional = calc_functional_variance_2_input(I, M);
            [~, var_sim_functional] = functional_monte_carlo_circuit_sim_two_input(I', M, N, num_samples);
            var_bucket_sim(scc_index) = var_bucket_sim(scc_index) + var_sim;
            var_bucket(scc_index) = var_bucket(scc_index) + var;
            var_bucket_sim_orig(scc_index) = var_bucket_sim_orig(scc_index) + var_sim_orig;
            var_bucket_analytic_functional(scc_index)  = var_bucket_analytic_functional(scc_index) + var_analytic_functional;
            var_bucket_sim_functional(scc_index) = var_bucket_sim_functional(scc_index) + var_sim_functional;
            counter_bucket(scc_index) = counter_bucket(scc_index) + 1;
       % end
   % end
end


analytic_var_vec = var_bucket./counter_bucket;
sim_var_vec = var_bucket_sim ./counter_bucket;
sim_functional_sim_var_vec = var_bucket_sim_functional ./counter_bucket;
sim_orig_var_vec = var_bucket_sim_orig./counter_bucket;
sim_functional_analytic_var_vec = var_bucket_analytic_functional./counter_bucket;
figure()
plot(scc_values, analytic_var_vec, scc_values, sim_var_vec);
% Create xlabel
xlabel('SCC','FontWeight','bold','FontSize',16);

% Create ylabel
ylabel('Variance','FontWeight','bold','FontSize',16);
legend('Analytic', 'Monte Carlo');
axis([-1,1,0,0.4]);

figure()
plot(scc_values, sim_functional_analytic_var_vec, scc_values, sim_functional_sim_var_vec);
% Create xlabel
xlabel('SCC','FontWeight','bold','FontSize',16);

% Create ylabel
ylabel('Variance','FontWeight','bold','FontSize',16);
legend('Analytic', 'Monte Carlo');
axis([-1,1,0,0.2]);
