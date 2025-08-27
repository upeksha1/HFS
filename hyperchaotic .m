function ydot=hyperchaotic(t,x)
a=0.9;
b=0.2;
c=1.5;
d=0.2;
k=0.17;
ydot=[x(3)+(x(2)-a).*x(1)+x(4) 1-b*x(2)-x(1).^2 -x(1)-c*x(3) -d*x(1).*x(2)-k*x(4) x(7)+(x(6)-a).*x(5)+x(8) 1-b*x(6)-x(5).^2 -x(5)-c*x(7) -d*x(5).*x(6)-k*x(8)]';
end
