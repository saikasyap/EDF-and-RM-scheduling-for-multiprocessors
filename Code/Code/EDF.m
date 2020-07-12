
%EDF Scheduling 
function TS = EDF(T)
TS = sim(T, @inz, @priority, @choose);
% inz function Used this function to declare and initialize any shared variables.  

function inz(T)
% shared variables are declared as global
global prio
prio = zeros(1,count(T));

% priority function:  used to update task priorities
function priority(T, currentTime) 
global prio

prio = T.DeadLine - mod(currentTime, T.Period);

% choose function:  used to select task to execute 
function t_index = choose(T)
global prio;
t_index  = 0;
min_prio    = inf;
ready       = T.Ready; 
for i = 1:count(T)
  if ready(i) & (prio(i) < min_prio) 
    t_index = i;
    min_prio   = prio(i);
  end
end
function TS = sim(T, inz, priority,choose)
n = count(T);
% initialization
inz(T);
Prtime = T.ProcTime;
d = T.Deadline;
Per = T.Period;
Wc = zeros(1,n);
% Intializing all variables to zeros 
exec = zeros(1,n);
inst = zeros(1,n);
resp = zeros(1,n);
% finding LCM of task periods
tmax  = 1;
for i = 1:n
  tmax = lcm(tmax, Per(i)); % base period
end
schedule = zeros(1, tmax);
% run simulation
for t = 1:tmax
  offset = mod(t-1, Per); % remainder when each period is divided to its previous period 
  
  for i = 1:n
    if (offset(i) == 0 & exec(i) == 0)
      exec(i) = Prtime(i);
      inst(i) = inst(i) + 1;
      resp(i) = 0;
    end
  end

  T.ProcTimeLeft = exec;
  T.Instance = inst;

  % update priorities
  priority(T, t-1);
  
  % choose task to execute:
  T.Ready     = T.ProcTimeLeft > 0;
  task        = choose(T);
  
  schedule(t) = task;
  resp        = resp + 1;
  
  if(~task) 
    continue
  end

  exec(task) = exec(task) - 1;

  if exec(task) == 0

      Wc(task) = max(resp(task), Wc(task));
  end
end

Wc = Wc + exec;
% add scheduling parameters to tasks:
TS = T;

start = cell(1,n);
len   = cell(1,n);
proc  = cell(1,n);

schedule = [0 schedule 0];

for t = 2:tmax+1,
  task = schedule(1, t);
  prev = schedule(1, t-1);
  next = schedule(1, t+1);
  
  if task
    if task ~= prev
      start{task} = [start{task} t-2];
      proc{task} = [proc{task} 0];
      cnt = 1;
    else    
      cnt = cnt + 1;
    end
    if (task ~= next)
      len{task} = [len{task} cnt]; 
    end   
  end
end

for i = 1:n
  TS.tasks(i) = add_scht(TS.tasks(i), start{i}, len{i}, proc{i});
end
disp(sprintf('Base period is %d', tmax))
disp(sprintf('Processor utilization is %1.4f', util(T)))
disp(sprintf('Worst-case response times for each task:'))
for i = 1:n
  disp(sprintf('%s\t: %d', TS.tasks(i).Name, Wc(i)))
end
miss = find(Wc > d);
if any(miss)
  disp(sprintf('  Task set is not schedulable: %s will miss its deadline', TS.tasks(miss(1)).Name));
else
  disp(sprintf('  Task set is schedulable'));
end

