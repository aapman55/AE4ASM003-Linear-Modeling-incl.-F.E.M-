function K = Part3_createSingleElementStiffnessMatrix(xi, yi, xj, yj, xm, ym, xn, yn, E, nu)
% The symbols r and s are the axes of the natural coordinate system. They
% are defined as symbols here because an integration needs to be done over
% r and s.
syms r s

% Define the Jacobian matrix. All the known values are filled in.
J = [-(1-s)/4*xi + (1-s)/4*xj + (1+s)/4*xm - (1+s)/4*xn,        -(1-s)/4*yi + (1-s)/4*yj + (1+s)/4*ym - (1+s)/4*yn;
     -(1-r)/4*xi - (1+r)/4*xj + (1+r)/4*xm + (1-r)/4*xn,        -(1-r)/4*yi - (1+r)/4*yj + (1+r)/4*ym + (1-r)/4*yn];

% The matrix A relates 
A = 1/det(J)*[  J(2,2) -J(1,2) 0 0;
                    0 0 -J(2,1) J(1,1);
                    -J(2,1) J(1,1) J(2,2) -J(1,2)];

m = 1/4*[   -(1-s),    0,  (1-s),   0,  (1+s),  0,  -(1+s), 0;
            -(1-r),    0, -(1+r),   0,  (1+r),  0,   (1-r),  0;
            0,    -(1-s),      0,   (1-s),  0,  (1+s),  0,  -(1+s);
            0,    -(1-r),      0,   -(1+r), 0,  (1+r),  0,  (1-r)];
        
B = A*m;

D = E/(1-nu^2)*[    1,      nu,     0;
                    nu,     1,      0;
                    0,      0,  (1-nu)/2];
                
INT = transpose(B)*D*B*det(J);

K = int(int(INT,r,-1,1),s,-1,1);

end