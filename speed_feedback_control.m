function ydot=speed_feedback_control(t,y)
a=0.9;
b=0.2;
c=1.5;
d=0.2;
k=0.17;
K=3.5;
ydot=[y(3)+(y(2)+(1/b)-a).*y(1)+y(4) -b*y(2)-y(1).^2  -y(1)-c*y(3) -(d/b)*y(1)-d*y(1).*y(2)-k*y(4)-K*(y(3)+(y(2)+(1/b)-a).*y(1)+y(4))]';
end