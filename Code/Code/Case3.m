%  tasks  ( Name  ,  C,   T)
t1 = ptask('task1',3,100,1,100,100,0,0);
t2 = ptask('task2',4,15,2,15,15,0,1);
t3 = ptask('task3',10,40,3,40,40,0,2);

% Set of tasks:
T  = taskset([t1 t2 t3]);

% Rate Monotonic scheduling
TS1 = RM(T);

% earliest deadline first scheduling
TS = EDF(T);

subplot(3,1,1);
title('Set of Tasks');
plot(T)

subplot(3,1,2);
title('RM Scheduling');
plot(TS1,'proc',0);

subplot(3,1,3);
title('EDF Scheduling');
plot(TS,'proc',0);
