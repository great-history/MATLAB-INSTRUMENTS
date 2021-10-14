function Yokogawa_SetOutputValue(Device, TargetOutput)

fprintf(Device,sprintf('SOUR:LEV %f', TargetOutput)); 

end