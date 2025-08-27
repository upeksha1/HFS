clc
clear all
close all
%wave form
[T,Y]=ode45(@butter,[0 500],[1 2 0.5 0.5])
figure;
subplot(4,1,1)
plot(T,Y(:,1),'b','markersize',10)
xlabel('time(sec)')
ylabel('x')
set(gca,'fontsize',8)
set(gca,'fontweight','bold')

subplot(4,1,2)
plot(T,Y(:,2),'b','markersize',10)
xlabel('time(sec)')
ylabel('y')
set(gca,'fontsize',8)
set(gca,'fontweight','bold')

subplot(4,1,3)
plot(T,Y(:,3),'b','markersize',10)
xlabel('time(sec)')
ylabel('z')
set(gca,'fontsize',8)
set(gca,'fontweight','bold')

subplot(4,1,4)
plot(T,Y(:,4),'b','markersize',10)
xlabel('time(sec)')
ylabel('w')
set(gca,'fontsize',8)
set(gca,'fontweight','bold')