%{
    Description:

    This script is used to generate a heatmap where the heat dimension
    represents the SCC between two bitstreams.  (N) gives the bitstream
    length.

    This script will generate
    (avg_steps) bitstreams for each of (1 + sc_segments).  The '1' refers to
    the zero case, and sc_segments tells how many segments to create.  For
    example, if (N = 100), then supplying (sc_segments = 5) means that the
    resultant heatmap will be 6x6. [0,20,40,60,80,100].  
 
    So, we have two bitstreams which can each take any of (N+1) values (0 - N), but we
    limit the number of values by sc_segments.   This gives 
    (sc_segments + 1)^2 possible input combinations.  Therefore the heatmap
    shows each of these combinations as a square matrix.  

%}

N = 1000; % Bit-stream length
sc_segments = 20; % Note: Does not include 0
avg_steps = 50;
mean_results = zeros(sc_segments+1);
min_val_results = zeros(sc_segments+1);
max_val_results = zeros(sc_segments+1);
variance_results = zeros(sc_segments+1);
error_results_AND = zeros(sc_segments+1);
error_results_XNOR = zeros(sc_segments+1);
var_results_AND = zeros(sc_segments+1);
var_results_XNOR = zeros(sc_segments+1);

for i = 0:sc_segments
    i
    for j = 0:sc_segments
        
        p1 = (1/sc_segments)*i;
        p2 = (1/sc_segments)*j;
        s1 = SNG_MATRIX_NO_FLUC(p1, N, avg_steps);
        s2 = SNG_MATRIX_NO_FLUC(p2, N, avg_steps);
        p1_actual = S2D_ARRAY(s1);
        p2_actual = S2D_ARRAY(s2);
        samples = zeros(1, avg_steps);
        min_val = zeros(1, avg_steps);
        max_val = zeros(1, avg_steps);
        error_AND = zeros(1, avg_steps);
        error_XNOR = zeros(1, avg_steps);
        for k = 1:avg_steps
             [samples(1, k), min_val(1, k), max_val(1, k)] = scc_m([s1(k,:); s2(k,:)]);
             expected_AND = p1_actual(k)*p2_actual(k);
             actual_AND = S2D(AND_MAT([s1(k,:); s2(k,:)]));
             expected_XNOR = UNIPOL_2_BIPOL(p1_actual(k))*UNIPOL_2_BIPOL(p2_actual(k));
             actual_XNOR = UNIPOL_2_BIPOL(S2D(XNOR(s1(k,:), s2(k,:))));
             error_AND(1, k) = (actual_AND - expected_AND);
             error_XNOR(1, k) = (actual_XNOR - expected_XNOR)^2;
        end
        mean_results(i+1,j+1) = mean(samples);
        min_val_results(i+1, j+1) = mean(min_val);
        max_val_results(i+1, j+1) = mean(max_val);
        variance_results(i+1,j+1) = var(samples);
        error_results_AND(i+1, j+1) = mean(error_AND);
        error_results_XNOR(i+1, j+1) = mean(error_XNOR);
        var_results_AND(i+1, j+1) = var(error_AND);
        var_results_XNOR(i+1, j+1) = var(error_XNOR);
        
    end
end

generateHeatmapWithTitle(mean_results, 'SCC');
%generateHeatmapWithTitle(max_val_results, 'Max Overlap');
%generateHeatmapWithTitle(min_val_results, 'Min Overlap');
%generateHeatmapWithTitle(variance_results, 'SCC Variance');
%generateHeatmapWithTitle(error_results_AND, 'Non-Squared Error');
%generateHeatmapWithTitle(var_results_AND, 'Non-Squared Error Variance');
%generateHeatmap(error_results_XNOR);



