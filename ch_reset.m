function ch_reset(instrument, type, value, step)
%% che_set���ܣ���ָ���豸instrument������type�������ָ��ֵvalue
%% ���ڷǴų��豸��stepΪ0�������ʱ����ִ�������������step��������Ĭ��ֵ����value,stepΪ1ʱ��һ������value
switch type
    case 'gate'
        Yokogawa_SetVoltSource(instrument);
        Yokogawa_SweepFixTime(instrument, value, step);
    otherwise                                 %for 'time', 'temperature'
        'do nothing';
end