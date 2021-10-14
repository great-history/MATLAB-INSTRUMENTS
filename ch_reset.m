function ch_reset(instrument, type, value, step)
%% che_set功能，是指定设备instrument和类型type，输出到指定值value
%% 对于非磁场设备，step为0或空数组时，不执行命令，若不存在step变量，以默认值到达value,step为1时，一步到达value
switch type
    case 'gate'
        Yokogawa_SetVoltSource(instrument);
        Yokogawa_SweepFixTime(instrument, value, step);
    otherwise                                 %for 'time', 'temperature'
        'do nothing';
end