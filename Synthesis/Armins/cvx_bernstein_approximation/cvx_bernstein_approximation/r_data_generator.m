%Generate r data
%r = sqrt(x^2 + y^2 + z^2) saturated to 1 and -1

step = 1/20;

t = -1:step:1;

x = kron(ones(1, length(t)), kron(ones(1, length(t)), t));
y = kron(ones(1, length(t)), kron(t, ones(1, length(t))));
z = kron(kron(t, ones(1, length(t))), ones(1, length(t)));

r = (x.^2 + y.^2 + z.^2)/3;
%r(find(r>1)) = 1;

%scatter3(x, y, r);

px = (1-x)/2;
py = (1-y)/2;
pz = (1-z)/2;
pr = (1-r)/2;

r_data = [px;py;pz;pr];
r_data = r_data'
