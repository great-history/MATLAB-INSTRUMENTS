function SR7270_SetVoltage(Device, Target_Voltage)

    fprintf(Device,sprintf('OA. %f', Target_Voltage));
    scanstr(Device);