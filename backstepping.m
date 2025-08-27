function xdot=backstepping(t,x)
%Active backstepping control for the global stabilization design of the new hyperchaotic finance system
%parameter values 
a=0.9;
b=0.2;
c=1.5;
d=0.2;
k=0.17;
%constant value
C=6;
%controllers
u1=-x(3)-(x(2)-a).*x(1)-x(4)+x(2);
u2=-1+b*x(2)+x(1).^2+x(3);
u3=x(1)+c*x(3)+x(4);
n4=3*x(1)+5*x(2)+3*x(3)+x(4);
u4=d*x(1).*x(2)+(k-4)*x(4)-5*x(1)-10*x(2)-9*x(3)-C*n4;
xdot=[x(3)+(x(2)-a).*x(1)+x(4)+u1 1-b*x(2)-x(1).^2+u2 -x(1)-c*x(3)+u3 -d*x(1).*x(2)-k*x(4)+u4]';
end