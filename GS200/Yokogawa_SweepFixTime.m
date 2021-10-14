function Yokogawa_SweepFixTime(Device, Target, Time)

switch nargin
    case 1
        Target = 0;
        Time = 1;
    case 2
        Time = 1;
end

fprintf(Device, 'PROG:REP OFF');
fprintf(Device, sprintf('PROG:INT %0.1f', Time)); 
fprintf(Device, sprintf('PROG:SLOP %0.1f', Time)); 
fprintf(Device, 'PROG:EDIT:STAR'); 
fprintf(Device, sprintf('SOUR:LEV %f', Target)); 
fprintf(Device, 'PROG:EDIT:END'); 
fprintf(Device, ':OUTP:STAT ON');  
fprintf(Device, 'PROG:RUN'); 

end