function ydot=butter(t,x)
a=0.9;
b=0.2;
c=1.5;
d=0.2;
k=0.17;
ydot=[x(3)+(x(2)-a).*x(1)+x(4) 1-b*x(2)-x(1).^2 -x(1)-c*x(3) -d*x(1).*x(2)-k*x(4) ]';
end
