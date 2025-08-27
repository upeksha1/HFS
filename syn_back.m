function xdot=syn_back(t,x)
%Active backstepping control for the global synchronization design of the new hyperchaotic finance system
%parameter values
a=0.9;
b=0.2;
c=1.5;
d=0.2;
k=0.17;
C=6;
%errors
e1=x(5)-x(1);
e2=x(6)-x(2);
e3=x(7)-x(3);
e4=x(8)-x(4);
%controllers
u1=a*e1-e3-x(5).*x(6)+x(1).*x(2)-e4+e2;
u2=b*e2+(x(1)+x(5)).*e1+e3;
u3=e1+c*e3+e4;
n4=3*e1+5*e2+3*e3+e4;
v=-5*e1-10*e2-9*e3-4*e4-C*n4;
u4=d*x(1).*x(2)-d*x(1).*x(2)+k*e4+v;
xdot=[x(3)+(x(2)-a).*x(1)+x(4) 1-b*x(2)-x(1).^2 -x(1)-c*x(3) -d*x(1).*x(2)-k*x(4)  x(7)+(x(6)-a).*x(5)+x(8)+u1 1-b*x(6)-x(5).^2+u2 -x(5)-c*x(7)+u3 -d*x(5).*x(6)-k*x(8)+u4  ]';
end