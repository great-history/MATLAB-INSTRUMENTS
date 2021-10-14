function Time = Yokogawa_SweepFixSlope(Device, Target, Slope)

switch nargin
    case 1
        Target = 0;
        Slope = 1;
    case 2
        Slope = 1;
end

Time = abs(Yokogawa_ReadOutput(Device) - Target) / Slope;

fprintf(Device, 'PROG:REP OFF');
fprintf(Device, sprintf('PROG:INT %0.1f', Time)); 
fprintf(Device, sprintf('PROG:SLOP %0.1f', Time)); 
fprintf(Device, 'PROG:EDIT:STAR'); 
fprintf(Device, sprintf('SOUR:LEV %f', Target)); 
fprintf(Device, 'PROG:EDIT:END'); 
fprintf(Device, ':OUTP:STAT ON');  
fprintf(Device, 'PROG:RUN'); 

end