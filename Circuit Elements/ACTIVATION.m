% Simulates the activation function with a given average number, sc_size
% (in Stochastic bits) and fsm_size(in Binary bits)
function [in, out, scc_reg, scc_del] = ACTIVATION(avg_iterations, sc_size, fsm_size)

n = sc_size; % Stochastic number size in bits.
N = fsm_size;  % State machine size in bits.
X = zeros(1,n);
Y = zeros(1,n);
SCC_REG = zeros(1,n);
SCC_DEL = zeros(1,n);

trials = avg_iterations;
for i = 1:n
    avg = 0;
    scc_reg = 0;
    scc_del = 0;
    scc_del_count = 0;
    scc_reg_count = 0;
  
    for trial = 1:trials
        % Compute the sigmoid output
        sc = SNG(i/n, n);
        sc_out = FSM(sc, N);
        dec_out = S2D(sc_out);
        avg = avg + dec_out;
        
        
        % Test the correlation (regeneration and delay)
        sc_out_del = DELAY(sc_out);
        sc_out_reg = SNG(dec_out, n);
        
        % IMPORTANT: When removing items form the iterations, make sure the
        % average is updated wth this change. (don't just divide by
        % 'trials').
        scc_reg_current = sc_correlation(sc_out, sc_out_reg);
        if(~isnan(scc_reg_current))
            scc_reg = scc_reg + scc_reg_current;
            scc_reg_count = scc_reg_count + 1;
        end
        
        scc_del_current = sc_correlation(sc_out, sc_out_del);
        if(~isnan(scc_del_current))
            scc_del = scc_del + scc_del_current;
            scc_del_count = scc_del_count + 1;
            
        end
    end
    avg = avg / trials;
    scc_reg = scc_reg / scc_reg_count;
    scc_del = scc_del / scc_del_count;
    
    X(i) = i/n;
    Y(i) = avg;
    SCC_REG(i) = scc_reg;
    SCC_DEL(i) = scc_del;
    
   
end

X = (X - 0.5)*2;
in = X;
Y = (Y - 0.5)*2;
out = Y;

scc_reg = SCC_REG;
scc_del = SCC_DEL;

end