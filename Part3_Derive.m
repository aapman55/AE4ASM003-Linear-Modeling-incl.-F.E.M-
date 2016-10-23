clear;
syms r s w l E nu

A = 4/(l*w)*[  w/2 0 0 0;
                    0 0 0 l/2;
                    0 l/2 w/2 0];

m = 1/4*[   -(1-s),    0,  (1-s),   0,  (1+s),  0,  -(1+s), 0;
            -(1-r),    0, -(1+r),   0,  (1+r),  0,   (1-r),  0;
            0,    -(1-s),      0,   (1-s),  0,  (1+s),  0,  -(1+s);
            0,    -(1-r),      0,   -(1+r), 0,  (1+r),  0,  (1-r)];
        
B = A*m;

D = E/(1-nu^2)*[    1,      nu,     0;
                    nu,     1,      0;
                    0,      0,  (1-nu)/2];
                
INT = transpose(B)*D*B;

K = l*w/4*int(int(INT,r,-1,1),s,-1,1);

createElementK = @(length, width, Young, Poisson) subs(K, {l, w, E, nu}, [length, width, Young, Poisson]);