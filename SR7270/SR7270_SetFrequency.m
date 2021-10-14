function SR7270_SetFrequency(Device, Target_Frequency)

    fprintf(Device,sprintf('OF. %f', Target_Frequency)); 
    scanstr(Device);