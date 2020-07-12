clc;
clear all;
%  Case 2 Where deadlines are not equal to periods
t1 = ptask('task1',3,30,1,10,10,0,0);
t2 = ptask('task2',4,20,2,15,15,0,1);
t3 = ptask('task3',10,60,3,40,40,0,2);

% Set of tasks:
T  = taskset([t1 t2 t3]);

% earliest deadline first scheduling
TS = RM(T);

subplot(2,1,1);
title('Set of tasks');
plot(T)
subplot(2,1,2);
title('scheduling of rate montonic algorithm');
plot(TS,'proc',0);
