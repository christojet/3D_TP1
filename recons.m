function coords3D = recons( vue_0, vue_20, calib_0, calib_20 )

b = [vue_0'; 1; vue_20'; 1];
M = [calib_0; calib_20];

P = (M'*M)\M'*b;
P = P/P(4,1);
coords3D = P(1:3,1)';

end

