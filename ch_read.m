function value = ch_read(instrument, type)
%% ch_read���ܣ���ָ���豸instrument������type����ȡֵ��value
switch type
    case 'gate'
        value = Yokogawa_ReadOutput(instrument);
    otherwise    
        value = NaN;
end