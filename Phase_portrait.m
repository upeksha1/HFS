clc;clear all;close all;
%dx/dt=z+(y-a)x+u; dy/dt=1-by-x^2; dz/dt=-x-cz; du/dt=-dxy-ku
%x=y(1),y=y(2),z=y(3),u=y(4)
%x(0)=1,y(0)=2,z(0)=0.5, u(0)=0.5
[T,Y]=ode45(@butter,[0 300],[1 2 0.5 0.5])


figure
subplot(2,2,1)
plot3(Y(:,1),Y(:,2),Y(:,3),'b')
hold on
grid on
xlabel('x')
ylabel('y')
zlabel('z')
set(gca,'fontsize',8)
set(gca,'fontweight','bold')
box on


subplot(2,2,2)
plot3(Y(:,2),Y(:,3),Y(:,4),'b')
hold on 
grid on
xlabel('y')
ylabel('z')
zlabel('w')
set(gca,'fontsize',8)
set(gca,'fontweight','bold')
box on


subplot(2,2,3)
plot3(Y(:,1),Y(:,2),Y(:,4),'b')
hold on
grid on
xlabel('x')
ylabel('y')
zlabel('w')
set(gca,'fontsize',8)
set(gca,'fontweight','bold')
box on


subplot(2,2,4)
plot3(Y(:,1),Y(:,3),Y(:,4),'b');
hold on
grid on
xlabel('x')
ylabel('z')
zlabel('w')
set(gca,'fontsize',8)
set(gca,'fontweight','bold')
box on