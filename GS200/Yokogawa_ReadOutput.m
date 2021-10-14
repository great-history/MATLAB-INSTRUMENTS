function Data = Yokogawa_ReadOutput(Device)

fprintf(Device,sprintf('SOUR:LEV?')); 
Data = scanstr(Device);
Data = Data{1};

end