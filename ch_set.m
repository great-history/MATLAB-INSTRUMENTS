function ch_set(instr_name, instr, value, range, time)
%% ch_set���ܣ���ָ���豸instrument������type�������ָ��ֵvalue����ch_Initialization��ͬ����,ch_set����Ҫ�ص�instrument
addpath('GS200','SR7270')
if strncmp('GS200',instr_name,5) % Initialization of source(GS200)
    if ~strcmp(instr, 'none')
        try
            fopen(instr);
        end
        Yokogawa_Initialization(instr, value, range, time);
    end
elseif strncmp('lockin',instr_name,6)  % Initialization of lockin1,lockin2, lockin3(all are SR7270)
    instr = instrument_address(instr_name);
    fopen(instr);
    SR7270_Initialization(instr,initial_value,range); %% initial_value is Voltage for lockin, range is Frequency for lockin
else
    'do nothing';
end