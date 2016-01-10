
% Generates a plot of the FSM output
N = 1000;
segments = 50;
avg_steps = 50;
fsm_states = 250;
base_segment = (1/segments); 
sc_results = [];
expected_results = [];
mean_vec = [];
var_vec = [];

for segment = 1:segments
    segment
    segment_results = [];
    for i = 1:avg_steps
        expected_ps = base_segment*(segment - 1);
        expected_bs = UNIPOL_2_BIPOL(expected_ps);
        S = SNG(expected_ps, N);
        bs = UNIPOL_2_BIPOL(S2D_ARRAY(S, N)); 
        Z = FSM(S, fsm_states);
        bz = UNIPOL_2_BIPOL(S2D_ARRAY(Z, N)); 
        expected_bz = tanh(fsm_states*expected_bs/2);
        segment_results = [segment_results bz];
    end
    mean_vec = [mean_vec mean(segment_results)];
    var_vec = [var_vec var(segment_results)];
end

plot(UNIPOL_2_BIPOL(0:base_segment:1-base_segment), var_vec);
legend('SC', 'Expected');
