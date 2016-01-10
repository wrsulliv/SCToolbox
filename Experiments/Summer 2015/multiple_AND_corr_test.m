%{

    Description: 
    This script is used to better understand how correlaiton
    is measured between multiple uni-polar encoded signals.  
    In this way, when an AND gate is
    presented with multiple (N) inputs, the point is to determine a measure
    of correlation which measures between all pairs.  
    This script measures the correlation between all possible inputs in the
    uni-polar encoding, where the number of intervals for a single
    input is given as (num_intervals) which has a max value of (N).
    (num_intervals) gives the number of intervals between 0 and 1, not
    including 0.  

    For example:  When (N=4) and (num_intervals=2), the numbers which will
    be tested are [0, 1/2, 2/2].  

    This script creates #combos = (num_intervals + 1)^N combinations of N
    stochasatic numbers and calculates the SCC of each combination in two
    different ways:

    1.)  By using an alteration on the definition given by Alaghi:  
    calculating the numerator and denominator as:
    numerator = actual(all_inputs) - expected(all_inputs)
    denominator = min(all_inputs) - expected(all_inputs): If numerator is > 0
    denominator = max(0, sum(all_inputs) - 1): If numerator <= 0
    
    TODO:  2.)  By using the exact definition given by Alaghi for pairwise
    correlation.  For example, with three inputs, the SCC is determined by
    calculating the numerator of the first pair.  Then, the next numerator
    is calculated 
 
%}

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


N = 20; % Bit-stream length
sc_segments = 20; % Note: Does not include 0
avg_steps = 50;

x = zeros((sc_segments + 1)^3, 1);
y = zeros((sc_segments + 1)^3, 1);
z = zeros((sc_segments + 1)^3, 1);
s = ones((sc_segments + 1)^3, 1)*50;
c_mean = zeros((sc_segments + 1)^3, 1);
c_var = zeros((sc_segments + 1)^3, 1);

current_point = 1;
for i = 0:sc_segments
    i
    for j = 0:sc_segments
        for k = 0:sc_segments

            p1 = (1/sc_segments)*i;
            p2 = (1/sc_segments)*j;
            p3 = (1/sc_segments)*k;
            
            s1 = SNG_MATRIX(p1, N, avg_steps);
            s2 = SNG_MATRIX(p2, N, avg_steps);
            s3 = SNG_MATRIX(p3, N, avg_steps);
            samples = zeros(1, avg_steps);
            for l = 1:avg_steps
                 samples(1, l) = scc_m([s1(l,:); s2(l,:); s3(l,:)]);
            end
            
            x(current_point) = p1;
            y(current_point) = p2;
            z(current_point) = p3;
            c_mean(current_point) = mean(samples);
            c_var(current_point) = var(samples);
            current_point = current_point + 1;
        end
    end
end

% Now that we have the 3D matrix filled, we need to seperate this matrix
% into vectors suitable for scatter3(x,y,z,s,c).  (x, y, z) are vectors
% where each row of the corresponding Nx3 matrix represents a point, and
% (s) is a vector representing the size and (c) is a vector representing
% the color.  In this way, all the information is contained in an Nx5
% matrix. 


scatter3(x,y,z,s,c_mean);