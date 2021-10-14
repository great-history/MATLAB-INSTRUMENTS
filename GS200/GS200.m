function Output = GS200(Mode, varargin)

switch Mode
    case 'check'
        CheckMode = varargin{1};
        switch CheckMode
            case 'set'     
                if length(varargin{2}) == 2
                    Source = varargin{2}{1};
                    Target = varargin{2}{2};

                    Target = str2double(Target);
                    if (string(Source) == "volt" || string(Source) == "curr") && ~isnan(Target)
                        Output = true;
                    else
                        Output = false;
                    end
                else
                    Output = false;
                end
                
            case 'sweep'
                if length(varargin{2}) == 3
                    Target = varargin{2}{1};
                    Slope = varargin{2}{2};

                    Target = str2double(Target);
                    Slope = str2double(Slope);
                    if ~isnan(Target) && ~isnan(Slope)
                        Output = true;
                    else
                        Output = false;
                    end
                else
                    Output = false;
                end
                
            case 'reach'
                if length(varargin) == 3
                    Device = varargin{2};
                    Target = varargin{3}{1};
                    
                    Target = str2double(Target);
                    Read = Yokogawa_ReadOutput(Device);
                    
                    if Target == Read
                        Output = true;
                    else
                        Output = false;
                    end
                else
                    Output = false;
                end
                    
        end
                
    case 'opon'
        Device = varargin{1};
        
        Yokogawa_SetOutputON(Device);
        Output = true;
        
    case 'opoff'
        Device = varargin{1};
        
        Yokogawa_SetOutputOFF(Device);
        Output = false;
        
    case 'set'
        Device = varargin{1};
        switch class(varargin{2})
            case 'cell'
                Source = varargin{2}{1};
                
                    switch Source
                        case 'volt'
                            Yokogawa_SetVoltSource(Device);
                        case 'curr'
                            Yokogawa_SetCurrSource(Device);

                        otherwise
                            Source = str2double(Source);
                            if ~isnan(Source)
                                Yokogawa_SetOutputValue(Device, Source);
                            end
                    end
                     
            case 'double'
                Source = varargin{2};
                
                if ~isnan(Source)
                    Yokogawa_SetOutputValue(Device, Source);
                end
        end
        
    case 'sweep'
        Device = varargin{1};
        Target = varargin{2}{1};
        Slope = varargin{2}{2};
        
        Target = str2double(Target);
        Slope = str2double(Slope);
            if ~isnan(Target) && ~isnan(Slope)
            	Output = Yokogawa_SweepFixSlope(Device, Target, Slope);
            end
            
    case 'pause'
        Device = varargin{1};
        
        Yokogawa_ProgramPause(Device);
        
    case 'continue'
        Device = varargin{1};
        
        Yokogawa_ProgramContinue(Device);
        
    case 'read'
        Device = varargin{1};
        
        switch length(varargin) 
            case 1
                Output = Yokogawa_ReadOutput(Device);
            case 2
                Input = varargin{2};

                if isfield(Input,'set')
                    Output = struct(Input.set, Yokogawa_ReadOutput(Device));
                else
                    Output = struct();
                end
        end
end
                
end