clc;clear all;close all;
%Active backstepping control for the global stabilization design of the new hyperchaotic finance system
[T,X] = ode45(@backstepping,[0 20],[1 2 0.5 0.5]);
plot(T,X(:,1),'b',T,X(:,2),'g',T,X(:,3),'r',T,X(:,4),'m','markersize',12)
grid on
xlabel('t(sec)')
ylabel('x(t),y(t),z(t),w(t)')
legend('x(t)','y(t)','z(t)','w(t)')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
box on




