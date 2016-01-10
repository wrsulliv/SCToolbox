results = [];
tol = 5;

avg_steps = 10000;
results = [];
for px = 0:0.1:1
    px
    px_results = [];
    for N = 0:100:10000
        px_results = [px_results Prob_given_p_percent_monte_carlo(px, tol, N, avg_steps)];
    end
    results = [results; px_results];
end
GeneratePlotFromMatrix(results, 0:100:10000, num2str((0:0.1:1)'), 'N', 'Probablity')
