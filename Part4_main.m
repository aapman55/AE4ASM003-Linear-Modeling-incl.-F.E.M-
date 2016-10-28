% Question 3 C plaatje maken
f1 = @(x) x*0;
f2 = @(x) x.*(x-2);
f3 = @(x) x.*(x-1).*(x-2);

x = 0:0.05:2;

figure()
hold on
plot(x,f1(x))
plot(x,f2(x))
plot(x,f3(x))
grid minor