function SR7270_ResetFrequency(Device, target_freq, step)
    
% go to the target frequency
	if nargin == 2
        step = 50;  
    else
        if isempty(step)
            return
        end
    end
    current_freq=SR7270_ReadFrequency(Device);
    if current_freq == target_freq
        return
    end
    x=linspace(current_freq,target_freq,step);
    for i=1:step
        freq=x(i);
        SR7270_SetFrequency(Device, freq);
        pause(0.3);
    end