%Active backstepping control for the global synchronization design of the new hyperchaotic finance system
clc;clear all;close all;
[T,Y] = ode45(@syn_back,[0 20],[1 2 0.5 0.5 2.6 5 0.7 -0.85 ]); % calling function file

% plotting the time response of the synchronized states 
%x1x2
figure
plot(T,Y(:,1),'b',T,Y(:,5),'r','markersize',12)
grid on
xlabel('t(sec)')
ylabel('x1,x2')
legend('x1','x2')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
box on

%y1y2
figure
plot(T,Y(:,2),'b',T,Y(:,6),'r','markersize',12)
grid on
xlabel('t(sec)')
ylabel('y1,y2')
legend('y1','y2')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
box on

%z1z2
figure
plot(T,Y(:,3),'b',T,Y(:,7),'r','markersize',12)
grid on
xlabel('t(sec)')
ylabel('z1,z2')
legend('z1','z2')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
box on

%w1w2
figure
plot(T,Y(:,4),'b',T,Y(:,8),'r','markersize',12)
grid on
xlabel('t(sec)')
ylabel('w1,w2')
legend('w1','w2')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
box on

%plotting the time response of the synchronized error states 
figure
plot(T,Y(:,5)-Y(:,1),'b',T,Y(:,6)-Y(:,2),'r',T,Y(:,7)-Y(:,3),'k',T,Y(:,8)-Y(:,4),'g','markersize',12)
grid on
xlabel('t(sec)')
ylabel('e1,e2,e3,e4')
legend('e1','e2','e3','e4')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
box on

%average error
figure
e=sqrt((Y(:,5)-Y(:,1)).^2+(Y(:,6)-Y(:,2)).^2+(Y(:,7)-Y(:,3)).^2+(Y(:,8)-Y(:,4)).^2);
plot(T,e,'markersize',12)
grid on
xlabel('T(sec)')
ylabel('average error(e)')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
box on
