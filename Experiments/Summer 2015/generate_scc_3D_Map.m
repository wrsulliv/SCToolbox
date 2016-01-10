%{

    Description: 
    Similar to scc heatmap, but in 3D
 
%}


sc_segments = 50; % Note: Does not include 0
avg_steps = 50;

x = zeros((sc_segments + 1)^3, 1);
y = zeros((sc_segments + 1)^3, 1);
z = zeros((sc_segments + 1)^3, 1);
s = ones((sc_segments + 1)^3, 1)*50;
c_mean = zeros((sc_segments + 1)^3, 1);
c_var = zeros((sc_segments + 1)^3, 1);

current_point = 1;
z_level = 0;
for N = 100:100:2000
    N
    for i = 0:sc_segments
        for j = 0:sc_segments

            p1 = (1/sc_segments)*i;
            p2 = (1/sc_segments)*j;
            
            s1 = SNG_MATRIX(p1, N, avg_steps);
            s2 = SNG_MATRIX(p2, N, avg_steps);
            samples = zeros(1, avg_steps);
            for l = 1:avg_steps
                 samples(1, l) = sc_correlation(s1(l,:), s2(l,:));
            end
            
            x(current_point) = p1;
            y(current_point) = p2;
            z(current_point) = z_level;
            c_mean(current_point) = mean(samples);
            c_var(current_point) = var(samples);
            current_point = current_point + 1;
        end
    end
    
        z_level = z_level + sc_segments;
end

% Now that we have the 3D matrix filled, we need to seperate this matrix
% into vectors suitable for scatter3(x,y,z,s,c).  (x, y, z) are vectors
% where each row of the corresponding Nx3 matrix represents a point, and
% (s) is a vector representing the size and (c) is a vector representing
% the color.  In this way, all the information is contained in an Nx5
% matrix. 


scatter3(x,y,z,s,c_var);