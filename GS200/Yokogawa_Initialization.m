function Yokogawa_Initialization(Device, Target, Range, Time)
    Yokogawa_SetOutputON(Device);
    Target
    Range
    Time
    fprintf(Device, 'SOUR:FUNC VOLT'); 
    Yokogawa_SweepFixTime(Device, Target, Time)
%     fprintf(Device,sprintf('SOUR:LEV %f', Target)); 
    fprintf(Device, sprintf('SOUR:RANG %f', Range)); 
end
