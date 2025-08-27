clc
clear all
close all
%to identify the butterfly effect
[T,Y]=ode45(@butter,[0 500],[1 2 0.5 0.5])
[T2,Y2]=ode45(@butter,[0 500],[1 2 0.5 0.5001])
figure;
subplot(4,1,1)
plot(T,Y(:,1),'b','markersize',10)
hold on
plot(T2,Y2(:,1),'r','markersize',10)
xlabel('time(sec)')
ylabel('x')
set(gca,'fontsize',8)
set(gca,'fontweight','bold')

subplot(4,1,2)
plot(T,Y(:,2),'b','markersize',10)
hold on
plot(T2,Y2(:,2),'r','markersize',10)
xlabel('time(sec)')
ylabel('y')
set(gca,'fontsize',8)
set(gca,'fontweight','bold')

subplot(4,1,3)
plot(T,Y(:,3),'b','markersize',10)
hold on
plot(T2,Y2(:,3),'r','markersize',10)
xlabel('time(sec)')
ylabel('z')
set(gca,'fontsize',8)
set(gca,'fontweight','bold')

subplot(4,1,4)
plot(T,Y(:,4),'b','markersize',10)
hold on
plot(T2,Y2(:,4),'r','markersize',10)
xlabel('time(sec)')
ylabel('w')
set(gca,'fontsize',8)
set(gca,'fontweight','bold')