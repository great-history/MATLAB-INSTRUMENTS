function SR7270_Initialization(Device, Volt, Freq)


%% set voltage
    n=length(Volt);
    if n==1
        step=50;
        SR7270_ResetVoltage(Device, Volt, step);
                                        
    elseif n>1        
        for ii=1:length(Volt)
            volt=Volt(ii);
            SR7270_SetVoltage(Device, volt);
            pause(0.3);
        end
    else
        warndlg('The input Volt for lockin is empty!');
    end 
%% set frequency

if ~isempty(Freq)
    n=length(Freq);
    if n==1
        step=50;
        SR7270_ResetFrequency(Device, Freq, step);
                                        
    elseif n>1        
        for ii=1:length(Freq)
            freq=Freq(ii);
            SR7270_SetFrequency(Device, freq);
            pause(0.3);
        end
    end
else
    warndlg('The input freq for lockin is empty!');
end 