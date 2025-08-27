clc;clear all;close all;
%active control method after synchronized
[T,X] = ode45(@active_control,[0 20],[1 2 0.5 0.5 2.6 5 0.7 -0.85 ]); % calling function file

% plotting the time response of the synchronized states 
%x1x2
figure
plot(T,X(:,1),'r',T,X(:,5),'b--','markersize',12)
grid on
xlabel('t(sec)')
ylabel('x1,x2')
legend('x1','x2')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
box on

%y1y2
figure
plot(T,X(:,2),'r',T,X(:,6),'b--','markersize',12)
grid on
xlabel('t(sec)')
ylabel('y1,y2')
legend('y1','y2')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
box on

%z1z2
figure
plot(T,X(:,3),'r',T,X(:,7),'b--','markersize',12)
grid on
xlabel('t(sec)')
ylabel('z1,z2')
legend('z1','z2')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
box on

%w1w2
figure
plot(T,X(:,4),'r',T,X(:,8),'b--','markersize',12)
grid on
xlabel('t(sec)')
ylabel('w1,w2')
legend('w1','w2')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
box on

%plotting the time response of the synchronized error states 
figure
plot(T,X(:,5)-X(:,1),'b',T,X(:,6)-X(:,2),'r',T,X(:,7)-X(:,3),'k',T,X(:,8)-X(:,4),'g','markersize',12)
grid on
xlabel('t(sec)')
ylabel('e1,e2,e3,e4')
legend('e1','e2','e3','e4')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
box on

%plotting the phase portraits for the synchronization state variables for the Master and the Slave systems
figure
subplot(2,2,1)
plot(X(:,1),X(:,5))
xlabel('x1 Master')
ylabel('x2 Slave')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')

subplot(2,2,2)
plot(X(:,2),X(:,6))
xlabel('y1 Master')
ylabel('y2 Slave')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')

subplot(2,2,3)
plot(X(:,3),X(:,7))
xlabel('z1 Master')
ylabel('z2 Slave')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')

subplot(2,2,4)
plot(X(:,4),X(:,8))
xlabel('w1 Master')
ylabel('w2 Slave')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')

%average error
figure
e=sqrt((X(:,5)-X(:,1)).^2+(X(:,6)-X(:,2)).^2+(X(:,7)-X(:,3)).^2+(X(:,8)-X(:,4)).^2);
plot(T,e)
grid on
xlabel('T(sec)')
ylabel('average error(e)')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
box on

%poltting the synchronized controlled functions
figure
a=0.9;b=0.2;c=1.5;d=0.2;k=0.17;
u1=-X(:,6).*X(:,5)+X(:,2).*X(:,1)+(a-1)*(X(:,5)-X(:,1))-(X(:,7)-X(:,3));
u2= (X(:,5)+X(:,1)).*(X(:,5)-X(:,1))+(b-1)*(X(:,6)-X(:,2));
u3=-(X(:,5)-X(:,1))+(c-1)*(X(:,7)-X(:,3));
u4=d*X(:,5).*X(:,6)-d*X(:,1).*X(:,2)+(k-1)*(X(:,8)-X(:,4));
plot(T,u1,'g',T,u2,'b',T,u3,'r',T,u4,'k')
grid on
legend('u1','u2','u3','u4')
xlabel('T(sec)')
ylabel('u1,u2,u3,u4')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
box on