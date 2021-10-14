function Volt = SR7270_ReadVoltage(Device)

fprintf(Device,'OA. '); 
Data_read = scanstr(Device);
Volt = Data_read{1};
scanstr(Device);% ∂¡µÙ £”‡\0