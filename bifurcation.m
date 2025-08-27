

% The following papers can be used as references for bifurcation and continuation diagrams
% https://ieeexplore.ieee.org/abstract/document/9703188 
% https://www.hindawi.com/journals/complexity/2020/2826850/ 
% https://www.mdpi.com/2227-7080/7/4/76 
% https://www.mdpi.com/2673-8716/2/2/8 
% https://link.springer.com/article/10.1007/s40435-020-00712-0 
clc
clear all
close all
clear global

global a b c d k
a=0.9;
b=0.2;
c=1.5;
d=0.2;
k=0.17;

% simulation step
dt=0.001;

% set initial conditions
x0=[1 2 0.5 0.5];

%parameter range of interest
%the smaller the step, the more detailed the diagram will look
stepinterval=0:0.001:1; 

%presave a matrix of NaNs, here we will save the points of intersection
M=NaN*zeros(1000,length(stepinterval));
pos=0; %this is an indexing dummy variable

%set ode options
options = odeset('RelTol',1e-5,'AbsTol',1e-5);

for a=stepinterval
    a %print beta, just so you know the progress
    pos=pos+1; %increase index

    %Comment this line out for a continuation diagram
    % x0=x(end,:);

    %simulate the system for the time of your choice
    %longer simulation time will bring clearer results
    [t,x]=ode45(@hyperchaotic1,0:dt:1000,x0,options);
    
    %discard transient. The more transient you discard, the better the
    %diagram will look.
    index=t>400;
    X=x(index,:); %save the states without the transient in a new vector
    l=length(X);
    
    %now, we search for intersections with a chosen plane
    %our chosen plane here is w=0, and we examine when 
    %X4(i)<0 && X4(i-1)>0, meaning that we move from positive w>0, to a
    %negative value w<0. So we plot our bifurcation diagram by examining
    %the intersections with w==0, with w'<0.
    p=1;
    for i=2:l
        if X(i,4)<0 && X(i-1,4)>0 
            M(p,pos)=X(i,1); %save the value x at this plane intersection
            p=p+1;
        end
    end
end

% plot the result
hold on
plot(stepinterval,M,'.k','MarkerSize',2)
xlabel('a')
ylabel('x')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
box on