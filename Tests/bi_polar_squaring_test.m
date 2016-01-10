inputs = -1:.01:1;
expected_results = inputs.*inputs;
N = 2048;

dec_inputs_squished = BIPOL_2_UNIPOL(inputs);
sc_inputs = DEC2SC_ARRAY(dec_inputs_squished, N);

delay_inputs = DELAY(sc_inputs);
actual_results = NOT(XOR(sc_inputs,delay_inputs));
actual_results = S2D_ARRAY(actual_results, N);
actual_results = UNIPOL_2_BIPOL(actual_results);

plot(inputs, expected_results, inputs, actual_results);
legend('Expected', 'Actual');

% Create xlabel
xlabel('Input','FontWeight','bold','FontSize',16);

% Create ylabel
ylabel('Output','FontWeight','bold','FontSize',16);

% Create title
title('Bi-Polar Squaring Test','FontWeight','bold','FontSize',16);