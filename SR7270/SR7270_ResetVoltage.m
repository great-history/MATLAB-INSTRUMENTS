function SR7270_ResetVoltage(Device, target_volt, step)
                       
% go to the target voltage
    if nargin == 2
        step = 50;  
    else
        if isempty(step)
            return
        end
    end
    current_volt=SR7270_ReadVoltage(Device);
    if current_volt == target_volt
        return
    end
    x=linspace(current_volt,target_volt,step);
    for i=1:step
        volt=x(i);
        SR7270_SetVoltage(Device, volt);
        pause(0.3);
    end