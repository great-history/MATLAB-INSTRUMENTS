function ch_set(instr_name, instr, value, range, time)
%% ch_set功能，是指定设备instrument和类型type，输出到指定值value，与ch_Initialization不同的是,ch_set不需要关掉instrument
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