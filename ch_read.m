function value = ch_read(instrument, type)
%% ch_read功能，是指定设备instrument和类型type，读取值到value
switch type
    case 'gate'
        value = Yokogawa_ReadOutput(instrument);
    otherwise    
        value = NaN;
end