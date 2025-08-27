function xdot=active_control(t,x)
%Purpose:active control method for synchronizing new hyperchaotic finance system
%parameter values
a=0.9;
b=0.2;
c=1.5;
d=0.2;
k=0.17;
%control functions
u1=-x(6).*x(5)+x(2).*x(1)+(a-1)*(x(5)-x(1))-(x(7)-x(3))-(x(8)-x(4));
u2= (x(5)+x(1)).*(x(5)-x(1))+(b-1)*(x(6)-x(2));
u3=-(x(5)-x(1))+(c-1)*(x(7)-x(3));
u4=d*x(5).*x(6)-d*x(1).*x(2)+(k-1)*(x(8)-x(4));
%xdot=[x(3)+(x(2)-a).*x(1)+x(4) 1-b*x(2)-x(1).^2 -x(1)-c*x(3) -d*x(1).*x(2)-k*x(4)  x(7)+(x(6)-a).*x(5)+x(8) 1-b*x(6)-x(5).^2 -x(5)-c*x(7) -d*x(5).*x(6)-k*x(8)]';
xdot=[x(3)+(x(2)-a).*x(1)+x(4) 1-b*x(2)-x(1).^2 -x(1)-c*x(3) -d*x(1).*x(2)-k*x(4)  x(7)+(x(6)-a).*x(5)+x(8)+u1 1-b*x(6)-x(5).^2+u2 -x(5)-c*x(7)+u3 -d*x(5).*x(6)-k*x(8)+u4]';
end
