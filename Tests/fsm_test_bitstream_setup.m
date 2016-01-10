% Tests whether the FSM is dependnent on the bitstream setup

N = 10000;
p = 0.3;
results = [];
fsm_states = 50;
for i = 1:100
    S = SNG_NO_FLUC(p, N);
    ps = UNIPOL_2_BIPOL(S2D_ARRAY(S, N));
    pz = UNIPOL_2_BIPOL(S2D_ARRAY(FSM(S, fsm_states), N));
    results = [results pz];
end


plot(results);
axis([1 100 -1 1])