function ch_Initialization(instr_name, initial_value, range, time)
%% the instr_name
addpath('GS200','SR7270')
if strncmp('GS200',instr_name,5) % Initialization of source(GS200)
    instr = instrument_address(instr_name);
    if ~strcmp(instr, 'none')
        fopen(instr);
        Yokogawa_Initialization(instr, initial_value, range, time);
        fclose(instr);delete(instr);clear instr 
    end
    
elseif strncmp('lockin',instr_name,6)  % Initialization of lockin1,lockin2, lockin3(all are SR7270)
    instr = instrument_address(instr_name);
    fopen(instr);
    SR7270_Initialization(instr,initial_value,range); %% initial_value is Voltage for lockin, range is Frequency for lockin    
    fclose(instr);delete(instr);clear instr   

end