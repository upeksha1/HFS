clc;clear all;close all;
%Xdot=Z+(Y+1/b-a)X+W
%Ydot=-bY-X^2
%Zdot=-X-cZ
%Udot=-dX/b-dXY-kW-KXdot
[T,Y]=ode45(@speed_feedback_control,[0 50],[1 2 0.5 0.5]);
plot(T,Y(:,1),'r',T,Y(:,2),'b',T,Y(:,3),'g',T,Y(:,4),'k','markersize',12)
grid on
%title('The time evaluation of the states of the controlled system with K=3.5')
xlabel('t(sec)')
ylabel('X,Y,Z,W')
legend('x','y','z','w')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
box on