% Understanding the relationship between MSE and SCC
N = 1000;
num_trials = 10000;

[corr_data, mse_mean, bucket_counter, corr_global_avg, mse_global_avg] = and_gate_corr_test(0.5, 0.5, N, num_trials);
figure(1);
plot(corr_data, mse_mean);
line([corr_global_avg corr_global_avg],[min(mse_mean) max(mse_mean)], 'Color' , 'r');
line([min(corr_data) max(corr_data)],[mse_global_avg mse_global_avg], 'Color' , 'g');
title('SCC vs. Average Error (0.5, 0.5)','FontSize',16);
xlabel('SCC','FontWeight','bold','FontSize',16);
ylabel('Average Non-Squared Error','FontWeight','bold','FontSize',16);
figure(2);
plot(corr_data, bucket_counter);
title('SCC vs. Sample Count (0.5, 0.5)','FontSize',16);
xlabel('SCC','FontWeight','bold','FontSize',16);
ylabel('Sample Count','FontWeight','bold','FontSize',16);
corr_global_avg
mse_global_avg

[corr_data, mse_mean, bucket_counter, corr_global_avg, mse_global_avg] = and_gate_corr_test(0.9, 0.9, N, num_trials);
figure(3);
plot(corr_data, mse_mean);
line([corr_global_avg corr_global_avg],[min(mse_mean) max(mse_mean)], 'Color' , 'r');
line([min(corr_data) max(corr_data)],[mse_global_avg mse_global_avg], 'Color' , 'g');
title('SCC vs. Average Error (0.9, 0.9)','FontSize',16);
xlabel('SCC','FontWeight','bold','FontSize',16);
ylabel('Average Non-Squared Error','FontWeight','bold','FontSize',16);
figure(4);
plot(corr_data, bucket_counter);
plot(corr_data, bucket_counter);
title('SCC vs. Sample Count (0.9, 0.9)','FontSize',16);
xlabel('SCC','FontWeight','bold','FontSize',16);
ylabel('Sample Count','FontWeight','bold','FontSize',16);
corr_global_avg
mse_global_avg

[corr_data, mse_mean, bucket_counter, corr_global_avg, mse_global_avg] = and_gate_corr_test(0.1, 0.9, N, num_trials);
figure(5);
plot(corr_data, mse_mean);
line([corr_global_avg corr_global_avg],[min(mse_mean) max(mse_mean)], 'Color' , 'r');
line([min(corr_data) max(corr_data)],[mse_global_avg mse_global_avg], 'Color' , 'g');
title('SCC vs. Average Error (0.1, 0.9)','FontSize',16);
xlabel('SCC','FontWeight','bold','FontSize',16);
ylabel('Average Non-Squared Error','FontWeight','bold','FontSize',16);
figure(6);
plot(corr_data, bucket_counter);
title('SCC vs. Sample Count (0.1, 0.9)','FontSize',16);
xlabel('SCC','FontWeight','bold','FontSize',16);
ylabel('Sample Count','FontWeight','bold','FontSize',16);
corr_global_avg
mse_global_avg