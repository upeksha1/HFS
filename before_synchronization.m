clc;clear all;close all;
%active control method before synchronized
[T,X] = ode45(@hyperchaotic,[0 100],[1 2 0.5 0.5 2.6 5 0.7 -0.85 ])
figure
%subplot(2,2,1)
plot(T,X(:,1),'r',T,X(:,5),'b','markersize',12)
grid on
xlabel('t(sec)')
ylabel('x1,x2')
legend('x1','x2')
%title('Time response of the states (x1,x2) before synchronization.')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
box on 

figure
%subplot(2,2,2)
plot(T,X(:,2),'r',T,X(:,6),'b','markersize',12)
grid on
xlabel('t(sec)')
ylabel('y1,y2')
legend('y1','y2')
%title('Time response of the states (y1,y2) before synchronization.')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
box on

figure
%subplot(2,2,3)
plot(T,X(:,3),'r',T,X(:,7),'b','markersize',12)
grid on
xlabel('t(sec)')
ylabel('z1,z2')
legend('z1','z2')
%title('Time response of the states (z1,z2) before synchronization.')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
box on

figure
%subplot(2,2,4)
plot(T,X(:,4),'r',T,X(:,8),'b','markersize',12)
grid on
xlabel('t(sec)')
ylabel('w1,w2')
legend('w1','w2')
%title('Time response of the states (w1,w2) before synchronization.')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
box on

figure
plot(T,X(:,5)-X(:,1),'b',T,X(:,6)-X(:,2),'r',T,X(:,7)-X(:,3),'k',T,X(:,8)-X(:,4),'g','markersize',12)
grid on
xlabel('t(sec)')
ylabel('e1,e2,e3,e4')
legend('e1','e2','e3','e4')
%title('Time response of the error states before synchronization')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
box on