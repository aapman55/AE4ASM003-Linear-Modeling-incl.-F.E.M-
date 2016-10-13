p = 1;
a = 3;
b = 9;

radialStress = @(r) ((p*a^2)./(b^2-a^2))*(1-b.^2./r.^2);
hoopStress = @(r) ((p*a^2)./(b^2-a^2))*(1+b.^2./r.^2);

r = a:0.01:b;

plot(r, sqrt(radialStress(r).^2+hoopStress(r).^2))