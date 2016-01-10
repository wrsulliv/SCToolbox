function O = calc_correlated_output(px, py, scc, M)
I = calc_input_ptm(px,py,scc,M);
    
    O = I'*M;
    O = O(2);
    
end