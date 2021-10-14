function Yokogawa_SetRange(Device, Range)

fprintf(Device, sprintf('SOUR:RANG %f', Range)); 

end