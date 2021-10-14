function Frequency = SR7270_ReadFrequency(Device)

fprintf(Device, 'OF. '); 
Data_read = scanstr(Device);
Frequency = Data_read{1};
scanstr(Device); %% ∂¡µÙ £”‡\0