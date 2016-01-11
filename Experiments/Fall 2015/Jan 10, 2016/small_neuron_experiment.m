% This script is used to show how the accuracy of a small neural network
% model changes as the size of the weights is allowed to change

N = 20000;
num_inputs = 10;
mape_results = [];


for num_inputs = 2:10
    num_inputs
    expected_results = [];
    actual_results = [];
    for weight_limit = 100:100:10000
        % Generate random inputs and weights
        in = [];
        w = [];

        for input = 1:num_inputs
            in = [in rand(1)*(randi([0 1])*2 - 1)];
            w = [w randi([-weight_limit weight_limit])]; 
        end


        % Calculate fsm_states
        norm_c = max(abs(w));
        fsm_states = ceil(norm_c*2*num_inputs);

        % Scale w
        w_scaled = w./norm_c;

        S_in = zeros(num_inputs, N);
        S_w = zeros(num_inputs, N);
        % Create the stochastic streams
        for input = 1:num_inputs
            S_in(input, :) = SNG(BIPOL_2_UNIPOL(in(input)), N);
            S_w(input, :) = SNG(BIPOL_2_UNIPOL(w_scaled(input)), N);
        end

        % Send them through the neuron
        neuron_out_stream = NEURON(S_in, S_w, fsm_states, false, false);
        expected = tanh(in*w');
        actual = UNIPOL_2_BIPOL(S2D_ARRAY(neuron_out_stream, N));
        expected_results = [expected_results expected];
        actual_results = [actual_results actual];
    end

    MSE = mean((expected_results - actual_results).^2)
    MAPE = mean(100*abs((expected_results - actual_results)./expected_results))
    mape_results = [mape_results MAPE];
end

% 
% hold on;
% cmap = colormap(jet)
% num_plots = 4;
% cmap_increment = size(cmap, 1)/num_plots;
% plot(BIPOL_Range, subs(software, a, BIPOL_Range),'-o', 'Color', cmap(8, :));
% plot(BIPOL_Range, bc_results, '-*', 'Color', cmap(24, :));
% plot(BIPOL_Range, polyval(fliplr(poly),BIPOL_Range), '-x', 'Color', cmap(32, :));
% plot(BIPOL_Range, synthesis_results, '-d', 'Color', cmap(56, :));
% legend('Original', 'Brown and Card', 'Polynomial', 'STRAUSS');
% axis([-1, 1, -1, 1])
% 
% 
% % Create xlabel
% xlabel('IBP Input   ','FontWeight','bold','FontSize',16);
% 
% % Create ylabel
% ylabel('IBP Output   ','FontWeight','bold','FontSize',16);
% 




