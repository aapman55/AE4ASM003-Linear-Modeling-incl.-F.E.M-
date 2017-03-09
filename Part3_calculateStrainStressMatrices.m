function [B_out, D] = Part3_calculateStrainStressMatrices(xi, yi, xj, yj, xm, ym, xn, yn, E, nu)
% The symbols r and s are the axes of the natural coordinate system. They
% are defined as symbols here because an integration needs to be done over
% r and s.
syms r s

% Define the Jacobian matrix. All the known values are filled in.
J = [-(1-s)/4*xi + (1-s)/4*xj + (1+s)/4*xm - (1+s)/4*xn,        -(1-s)/4*yi + (1-s)/4*yj + (1+s)/4*ym - (1+s)/4*yn;
     -(1-r)/4*xi - (1+r)/4*xj + (1+r)/4*xm + (1-r)/4*xn,        -(1-r)/4*yi - (1+r)/4*yj + (1+r)/4*ym + (1-r)/4*yn];

% The matrix A relates the strains in xy coordinates to the strain in the rs coordinates 
A = 1/det(J)*[  J(2,2) -J(1,2) 0 0;
                    0 0 -J(2,1) J(1,1);
                    -J(2,1) J(1,1) J(2,2) -J(1,2)];

% The m matrix specifies the [du/dr, du/ds, dv/dr, dv/ds] 
m = 1/4*[   -(1-s),    0,  (1-s),   0,  (1+s),  0,  -(1+s), 0;
            -(1-r),    0, -(1+r),   0,  (1+r),  0,   (1-r),  0;
            0,    -(1-s),      0,   (1-s),  0,  (1+s),  0,  -(1+s);
            0,    -(1-r),      0,   -(1+r), 0,  (1+r),  0,  (1-r)];
% B is just a definition        
B = A*m;

B_out = subs(B,[r,s],[0,0]);

% The compliance matrix for isotropic materials
D = E/(1-nu^2)*[    1,      nu,     0;
                    nu,     1,      0;
                    0,      0,  (1-nu)/2];


end