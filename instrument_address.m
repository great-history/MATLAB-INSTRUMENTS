function addr = instrument_address(objName)
%% All the equipments write their addresses here.
%objName:'kei24','kei25','kei26','DC1','DC2','DC3','DC4','RIGOL','Mag_z'
%'lockin8','lockin9'

switch objName
    
    case 'GS200_top'
        addr = visa('ni','GPIB0::3::INSTR');
        
    case 'GS200_bottom'
        addr = visa('ni');
    
    case 'lockin1'                  %% lockin1
        addr = visa('ni', 'USB0::0x0A2D::0x001B::17067584::RAW');  %% to do list: revision of address
        
    case 'lockin2'                  %% lockin2
        addr = visa('ni', 'USB0::0x0A2D::0x001B::16102767::RAW');
           
    case 'lockin3'                  %% lockin3
        addr = visa('ni', 'USB0::0x0A2D::0x001B::16280452::RAW');
        
    otherwise
        addr = 'none';

end

   

