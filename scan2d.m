function scan2d(app,event,scan_number)
addpath('keithley2400','MAG','RIGOL_DG812','SR830','keysight33510B','DC205','SX199','keysight34461A','SIM900','SIM928','TSG4104A')
reset_instrument;
global stop_check
stop_check=0;
%% initialize the instruments
scan_number_char = num2str(scan_number);
scan_Initialize(app,event,scan_number)
%% get the measurement instruments and fopen
select_lockin8=app.lockin8CheckBox.Value;
if select_lockin8==1
    lockin8=instrument_address('lockin8');
    fopen(lockin8);
end
select_lockin9=app.lockin9CheckBox.Value;
if select_lockin9==1
    lockin9=instrument_address('lockin9');
    fopen(lockin9);
end
select_lockin10=app.lockin10CheckBox.Value;
if select_lockin10==1
    lockin10=instrument_address('lockin10');
    fopen(lockin10);
end
select_34461A=app.keysight34461ACheckBox.Value;
if select_34461A==1
    keysight34461A=instrument_address('keysight34461A');
    fopen(keysight34461A);
end

str=app.SensitivityEditField.Value;
empty_check(str)
Sensitivity=str2num(str); % A/V in unit

str=app.dVEditField.Value;
empty_check(str)
dV=str2num(str);
bias_mode = app.bias_modeDropDown.Value;

str=app.RsEditField.Value;
empty_check(str)
Rs=str2num(str); % this is the Rseries
%% get the measurement parameters
str=['app.x_delayEditField' scan_number_char '.Value;'];
str2=eval(str);
empty_check(str2)
x_delay=str2num(str2);

str=['app.y_delayEditField' scan_number_char '.Value;'];
str2=eval(str);
empty_check(str2)
y_delay=str2num(str2);

str=['app.x_nameEditField' scan_number_char '.Value;'];
x_name=eval(str);
empty_check(x_name)

str=['app.y_nameEditField' scan_number_char '.Value;'];
y_name=eval(str);
empty_check(y_name)

str=['app.x_reset_stepEditField' scan_number_char '.Value;'];
str2=eval(str);
x_reset_step=str2num(str2);

str=['app.y_reset_stepEditField' scan_number_char '.Value;'];
str2=eval(str);
y_reset_step=str2num(str2);

str=['app.B_rateXEditField' scan_number_char '.Value;'];
str2 = eval(str);
B_rateX = str2num(str2); %in unit of T/s in default.

str=['app.B_rateYEditField' scan_number_char '.Value;'];
str2 = eval(str);
B_rateY = str2num(str2); %in unit of T/s in default.

str=['app.XEditField' scan_number_char '.Value;'];
str2 = eval(str);
scanX = str2num(str2);

str=['app.YEditField' scan_number_char '.Value;'];
str2 = eval(str);
scanY = str2num(str2); 

str=['app.B_totalXEditField' scan_number_char '.Value;'];
str2 = eval(str);
B_totalX = str2num(str2);
str=['app.scanX_selectionDropDown' scan_number_char '.Value;'];
scanX_selection=eval(str);
if strcmp(scanX_selection,'magXY_continuous')||strcmp(scanX_selection,'magXZ_continuous')||strcmp(scanX_selection,'magYZ_continuous')
    phi=scanX*pi/180;
    scanX=B_totalX;
end

str=['app.Ycompensate_selectionDropDown' scan_number_char '.Value;'];
Ycompensate_selection=eval(str);
if ~strcmp(Ycompensate_selection,'none')
    str=['app.scanYcomEditField' scan_number_char '.Value;'];
    str2 = eval(str);
    Ycom_slope_intercept=str2num(str2); 
    scanYcom = Ycom_slope_intercept(1)*scanY+Ycom_slope_intercept(2); 
    
    str=['app.Ycom_nameEditField' scan_number_char '.Value;'];
    Ycom_name=eval(str);
    empty_check(Ycom_name)
    
    str=['app.Ycom_reset_stepEditField' scan_number_char '.Value;'];
    str2=eval(str);
    Ycom_reset_step=str2num(str2);
else
    Ycom_name='none';    
end

str=['app.Xcompensate_selectionDropDown' scan_number_char '.Value;'];
Xcompensate_selection=eval(str);
if ~strcmp(Xcompensate_selection,'none')
    str=['app.scanXcomEditField' scan_number_char '.Value;'];
    str2 = eval(str);
    Xcom_slope_intercept=str2num(str2); 
    scanXcom = Xcom_slope_intercept(1)*scanX+Xcom_slope_intercept(2); 
    
    str=['app.Xcom_nameEditField' scan_number_char '.Value;'];
    Xcom_name=eval(str);
    empty_check(Xcom_name)
    
    str=['app.Xcom_reset_stepEditField' scan_number_char '.Value;'];
    str2=eval(str);
    Xcom_reset_step=str2num(str2);
else
    Xcom_name='none';    
end
%% define the foldername and dataname
userName = app.userNameEditField.Value;
fullname = createdir(userName);
Time = datestr(now, 'hh_MM_SS-yyyy-mm-dd');
Date = datestr(now,'dd');
str = ['app.foldernameEditField' scan_number_char '.Value;'];
folder = eval(str);
folder = [Time,'-', folder]; % the filefolder name
mkdir(fullname, folder); 
fullname = [fullname, '\', folder];
DataName = [Time,'-', 'data'];

%create file for python
file_name=[fullname, '\', Time, '.dat'];
headline=folder;
select_instrument=[select_lockin8 select_lockin9 select_lockin10 select_34461A];
y_name_read=[y_name, ' read'];
y_end=scanY(length(scanY)); %the value is wrong if program is stopped
y_size=length(scanY); %the value is wrong if program is stopped
y_start=scanY(1);

x_name_read=[x_name, ' read'];
x_end=scanX(length(scanX)); %the value is wrong if program is stopped
x_size=length(scanX); %the value is wrong if program is stopped %the value is wrong for continuous sweeping
x_start=scanX(1);

Ycom_name_read=[Ycom_name, ' read'];
Xcom_name_read=[Xcom_name, ' read'];
compensate={Ycompensate_selection,Ycom_name,Ycom_name_read,Xcompensate_selection,Xcom_name,Xcom_name_read};
prefix2file4python(file_name,headline,bias_mode,select_instrument,compensate,y_name,y_end,y_size,y_start,y_name_read,x_name,x_end,x_size,x_start,x_name_read);

DC205_port=0;
SIM900_port=0;
%% get the instrument for scanning X
str=['app.scanX_selectionDropDown' scan_number_char '.Value;'];
scanX_selection=eval(str);
if strncmp('kei',scanX_selection,3)
    scanX_type='kei';
    scanX_instr=instrument_address(scanX_selection);
    fopen(scanX_instr);     
elseif strncmp('DC',scanX_selection,2)
    scanX_type='DC205';
    portX=str2num(scanX_selection(end));
    scanX_instr=instrument_address(scanX_selection);
    fopen(scanX_instr); 
%     SX199_Link(scanX_instr, portX);
    DC205_port=portX;
    DC205_CheckRange(scanX_instr, max(abs(scanX)));
elseif strncmp('SIM',scanX_selection,3)
    scanX_type='SIM928';
    SIM_portX=str2num(scanX_selection(end));
    scanX_instr=instrument_address('SIM928');
    fopen(scanX_instr); 
    SIM900_connect(scanX_instr, SIM_portX);
    SIM900_port=SIM_portX;
elseif strcmp('keysight_CH1',scanX_selection)        
    scanX_type='keysight33510B_CH1';
    scanX_instr=instrument_address('keysight33510B');
    fopen(scanX_instr);
elseif strcmp('keysight_CH2',scanX_selection)       
    scanX_type='keysight33510B_CH2';
    scanX_instr=instrument_address('keysight33510B');
    fopen(scanX_instr);
elseif strcmp('magZ_step',scanX_selection)
    scanX_type='magZ_step';
    scanX_instr=instrument_address('magZ');
    fopen(scanX_instr);fscanf(scanX_instr);fscanf(scanX_instr);       
    magZ_SetRampRate(scanX_instr,B_rateX);
elseif strcmp('magZ_continuous',scanX_selection)
    scanX_type='magZ_continuous';
    scanX_instr=instrument_address('magZ'); 
    fopen(scanX_instr);fscanf(scanX_instr);fscanf(scanX_instr);
    magZ_SetRampRate(scanX_instr,B_rateX);
    Target_Field=scanX;
    scanX=[Target_Field(1) 1:86400];       %if 1s for 1 point,24 hours intotal
elseif strcmp('magX_step',scanX_selection)
    scanX_type='magX_step';
    scanX_instr=instrument_address('magX');
    fopen(scanX_instr);fscanf(scanX_instr);fscanf(scanX_instr);       
    magX_SetRampRate(scanX_instr,B_rateX);
elseif strcmp('magX_continuous',scanX_selection)
    scanX_type='magX_continuous';
    scanX_instr=instrument_address('magX'); 
    fopen(scanX_instr);fscanf(scanX_instr);fscanf(scanX_instr);
    magX_SetRampRate(scanX_instr,B_rateX);
    Target_Field=scanX;
    scanX=[Target_Field(1) 1:86400];      %if 1s for 1 point,24 hours intotal
elseif strcmp('magY_step',scanX_selection)
    scanX_type='magY_step';
    scanX_instr=instrument_address('magY');
    fopen(scanX_instr);fscanf(scanX_instr);fscanf(scanX_instr);       
    magY_SetRampRate(scanX_instr,B_rateX);
elseif strcmp('magY_continuous',scanX_selection)
    scanX_type='magY_continuous';
    scanX_instr=instrument_address('magY'); 
    fopen(scanX_instr);fscanf(scanX_instr);fscanf(scanX_instr);
    magY_SetRampRate(scanX_instr,B_rateX);
    Target_Field=scanX;
    scanX=[Target_Field(1) 1:86400];       %if is for 1 point,24 hours intotal     
elseif strcmp('magXZ_continuous',scanX_selection)
    scanX_type='magXZ_continuous';
    magX=instrument_address('magX'); 
    magZ=instrument_address('magZ');
    scanX_instr={magX,magZ};
    fopen(scanX_instr{1});fscanf(scanX_instr{1});fscanf(scanX_instr{1});
    fopen(scanX_instr{2});fscanf(scanX_instr{2});fscanf(scanX_instr{2});
    empty_check(B_rateX);
    if abs(B_rateX(1)*tan(phi))<=0.0016                 %calculate the ramping rate at phi
        B_rateX(2)=abs(B_rateX(1)*tan(phi));
    else
        B_rateX(1)=abs(B_rateX(2)*cot(phi));
    end    
    Target_Field=B_totalX(2)*[cos(phi),sin(phi)];
    scanX=[B_totalX(1) 1:86400];      %if 1s for 1 point,24 hours intotal
    empty_check(x_reset_step);
    x_reset_step=[x_reset_step phi];
elseif strcmp('magYZ_continuous',scanX_selection)
    scanX_type='magYZ_continuous';
    magY=instrument_address('magY'); 
    magZ=instrument_address('magZ');
    scanX_instr={magY,magZ};
    fopen(scanX_instr{1});fscanf(scanX_instr{1});fscanf(scanX_instr{1});
    fopen(scanX_instr{2});fscanf(scanX_instr{2});fscanf(scanX_instr{2});
    if abs(B_rateX(1)*tan(phi))<=0.0016                 %calculate the ramping rate at phi
        B_rateX(2)=abs(B_rateX(1)*tan(phi));
    else
        B_rateX(1)=abs(B_rateX(2)*cot(phi));
    end   
    Target_Field=B_totalX(2)*[cos(phi),sin(phi)];
    scanX=[B_totalX(1) 1:86400];      %if 1s for 1 point,24 hours intotal
    empty_check(x_reset_step);
    x_reset_step=[x_reset_step phi];
elseif strcmp('magXY_continuous',scanX_selection)
    scanX_type='magXY_continuous';
    magX=instrument_address('magX'); 
    magY=instrument_address('magY');
    scanX_instr={magX,magY};
    fopen(scanX_instr{1});fscanf(scanX_instr{1});fscanf(scanX_instr{1});
    fopen(scanX_instr{2});fscanf(scanX_instr{2});fscanf(scanX_instr{2});
    if abs(B_rateX(1)*tan(phi))<=0.00027                %calculate the ramping rate at phi
        B_rateX(2)=abs(B_rateX(1)*tan(phi));
    else
        B_rateX(1)=abs(B_rateX(2)*cot(phi));
    end
    Target_Field=B_totalX(2)*[cos(phi),sin(phi)];
    scanX=[B_totalX(1) 1:86400];      %if 1s for 1 point,24 hours intotal
    empty_check(x_reset_step);
    x_reset_step=[x_reset_step phi];
elseif strcmp('time',scanX_selection)    
    scanX_type='time';
    scanX_instr=instrument_address('time'); %tic function,return the beginning of the time
elseif strcmp('temperature5',scanX_selection)   
    scanX_type='temperature5';    
    scanX_instr=instrument_address('temperature'); %return Log_path
elseif strcmp('temperature6',scanX_selection)   
    scanX_type='temperature6';    
    scanX_instr=instrument_address('temperature'); %return Log_path
elseif strcmp('lockin8_freq',scanX_selection)
    scanX_type='lockin_freq';    
    if select_lockin8==1
        scanX_instr=lockin8;
    else        
        scanX_instr=instrument_address('lockin8');
        fopen(scanX_instr)      
    end
elseif strcmp('lockin9_freq',scanX_selection)
    scanX_type='lockin_freq';
    if select_lockin9==1
        scanX_instr=lockin9;
    else        
        scanX_instr=instrument_address('lockin9');
        fopen(scanX_instr)      
    end
elseif strcmp('lockin10_freq',scanX_selection)
    scanX_type='lockin_freq';
    if select_lockin10==1
        scanX_instr=lockin10;
    else        
        scanX_instr=instrument_address('lockin10');
        fopen(scanX_instr)      
    end
elseif strcmp('TSG_freq',scanX_selection)
    scanX_type='TSG_freq';
    scanX_instr=instrument_address('TSG4104A');
    fopen(scanX_instr)
elseif strcmp('TSG_ampt',scanX_selection)
    scanX_type='TSG_ampt';
    scanX_instr=instrument_address('TSG4104A');
    fopen(scanX_instr)
end
%% get the instrument for scanning Y
str=['app.scanY_selectionDropDown' scan_number_char '.Value;'];
scanY_selection=eval(str);
if strncmp('kei',scanY_selection,3)    
    scanY_instr=instrument_address(scanY_selection(1:5));
    fopen(scanY_instr); 
    if length(scanY_selection)==5
        scanY_type='kei';
        keithley2400_SetSourceMode(scanY_instr, 'V');        
    else
        scanY_type='keiI';
        keithley2400_SetSourceMode(scanY_instr, 'I');
        %keithley2400_SetIsourceRange(scanY_instr, max(abs(scanY)));        
    end  
elseif strncmp('DC',scanY_selection,2)    
    scanY_type='DC205';        
    portY=str2num(scanY_selection(end));
%     if strcmp(scanX_type,'DC205')
%         scanY_instr=scanX_instr;            
%     else
        scanY_instr=instrument_address(scanY_selection);
        fopen(scanY_instr); 
%     end
%     SX199_Link(scanY_instr, portY);
    DC205_port=portY;
    DC205_CheckRange(scanY_instr, max(abs(scanY)));
elseif strncmp('SIM',scanY_selection,3)
    scanY_type='SIM928';        
    SIM_portY=str2num(scanY_selection(end));
    if strcmp(scanX_type,'SIM928')
        scanY_instr=scanX_instr;            
    else
        scanY_instr=instrument_address('SIM928');
        fopen(scanY_instr); 
    end
    SIM900_connect(scanY_instr, SIM_portY);
    SIM900_port=SIM_portY;
elseif strcmp('keysight_CH1',scanY_selection) 
    scanY_type='keysight33510B_CH1';
    if strcmp(scanX_type,'keysight33510B_CH2')
        scanY_instr=scanX_instr; 
    else
        scanY_instr=instrument_address('keysight33510B');
        fopen(scanY_instr);
    end
elseif strcmp('keysight_CH2',scanY_selection) 
    scanY_type='keysight33510B_CH2';
    if strcmp(scanX_type,'keysight33510B_CH1')
        scanY_instr=scanX_instr; 
    else
        scanY_instr=instrument_address('keysight33510B');
        fopen(scanY_instr);
    end
elseif strcmp('magZ_step',scanY_selection)
    scanY_type='magZ_step';
    scanY_instr=instrument_address('magZ');
    fopen(scanY_instr);fscanf(scanY_instr);fscanf(scanY_instr);
    magZ_SetRampRate(scanY_instr,B_rateY);    
elseif strcmp('magX_step',scanY_selection)
    scanY_type='magX_step';
    scanY_instr=instrument_address('magX');
    fopen(scanY_instr);fscanf(scanY_instr);fscanf(scanY_instr);
    magX_SetRampRate(scanY_instr,B_rateY);
elseif strcmp('magY_step',scanY_selection)
    scanY_type='magY_step';
    scanY_instr=instrument_address('magY');
    fopen(scanY_instr);fscanf(scanY_instr);fscanf(scanY_instr);
    magY_SetRampRate(scanY_instr,B_rateY);
elseif strcmp('TSG_freq',scanY_selection)
    scanY_type='TSG_freq';
    if strcmp(scanX_type,'TSG_ampt')
        scanY_instr=scanX_instr;            
    else
        scanY_instr=instrument_address('TSG4104A');
        fopen(scanY_instr)
    end
elseif strcmp('TSG_ampt',scanY_selection)
    scanY_type='TSG_ampt';
    if strcmp(scanX_type,'TSG_freq')
        scanY_instr=scanX_instr;            
    else
        scanY_instr=instrument_address('TSG4104A');
        fopen(scanY_instr)
    end
else
    scanY_type='time';
    scanY_instr=instrument_address('time');%tic function,return the beginning of the time
end
%% get the instrument for Xcompensation
str=['app.Xcompensate_selectionDropDown' scan_number_char '.Value;'];
Xcompensate_selection=eval(str);
if strncmp('kei',Xcompensate_selection,3)
    scanXcom_type='kei';
    scanXcom_instr=instrument_address(Xcompensate_selection);
    fopen(scanXcom_instr); 
    keithley2400_SetVoltageRange(scanXcom_instr, max(abs(scanXcom)));
elseif strncmp('DC',Xcompensate_selection,2)    
    scanXcom_type='DC205';        
    portXcom=str2num(Xcompensate_selection(end));
%     if strcmp(scanX_type,'DC205')
%         scanXcom_instr=scanX_instr; 
%     elseif strcmp(scanY_type,'DC205')
%         scanXcom_instr=scanY_instr; 
%     else
        scanXcom_instr=instrument_address(Xcompensate_selection);
        fopen(scanXcom_instr); 
%     end
%     SX199_Link(scanXcom_instr, portXcom);
    DC205_port=portXcom;
    DC205_CheckRange(scanXcom_instr, max(abs(scanXcom)));
elseif strncmp('SIM',Xcompensate_selection,3)
    scanXcom_type='SIM928';        
    SIM_portXcom=str2num(Xcompensate_selection(end));
    if strcmp(scanX_type,'SIM928')
        scanXcom_instr=scanX_instr;
    elseif strcmp(scanY_type,'SIM928')
        scanXcom_instr=scanY_instr;
    else
        scanXcom_instr=instrument_address('SIM928');
        fopen(scanXcom_instr); 
    end
    SIM900_connect(scanXcom_instr, SIM_portXcom); 
    SIM900_port=SIM_portXcom;
elseif strcmp('keysight_CH1',Xcompensate_selection) 
    scanXcom_type='keysight33510B_CH1';
    if strcmp(scanX_type,'keysight33510B_CH2')
        scanXcom_instr=scanX_instr;
    elseif strcmp(scanY_type,'keysight33510B_CH2')
        scanXcom_instr=scanY_instr;
    else
        scanXcom_instr=instrument_address('keysight33510B');
        fopen(scanXcom_instr);
    end
elseif strcmp('keysight_CH2',Xcompensate_selection) 
    scanXcom_type='keysight33510B_CH2';
    if strcmp(scanX_type,'keysight33510B_CH1')
        scanXcom_instr=scanX_instr; 
    elseif strcmp(scanY_type,'keysight33510B_CH1')
        scanXcom_instr=scanY_instr;
    else
        scanXcom_instr=instrument_address('keysight33510B');
        fopen(scanXcom_instr);
    end
else
    scanXcom_type='none';
end
%% get the instrument for Ycompensation
str=['app.Ycompensate_selectionDropDown' scan_number_char '.Value;'];
Ycompensate_selection=eval(str);
if strncmp('kei',Ycompensate_selection,3)
    scanYcom_type='kei';
    scanYcom_instr=instrument_address(Ycompensate_selection);
    fopen(scanYcom_instr); 
    keithley2400_SetVoltageRange(scanYcom_instr, max(abs(scanYcom)));
elseif strncmp('DC',Ycompensate_selection,2)    
    scanYcom_type='DC205';        
    portYcom=str2num(Ycompensate_selection(end));
%     if strcmp(scanX_type,'DC205')
%         scanYcom_instr=scanX_instr; 
%     elseif strcmp(scanY_type,'DC205')
%         scanYcom_instr=scanY_instr;
%     elseif strcmp(scanXcom_type,'DC205')
%         scanYcom_instr=scanXcom_instr; 
%     else
        scanYcom_instr=instrument_address(Ycompensate_selection);
        fopen(scanYcom_instr); 
%     end
%     SX199_Link(scanYcom_instr, portYcom);
    DC205_port=portYcom;
    DC205_CheckRange(scanYcom_instr, max(abs(scanYcom)));
elseif strncmp('SIM',Ycompensate_selection,3)
    scanYcom_type='SIM928';        
    SIM_portYcom=str2num(Ycompensate_selection(end));
    if strcmp(scanX_type,'SIM928')
        scanYcom_instr=scanX_instr;
    elseif strcmp(scanY_type,'SIM928')
        scanYcom_instr=scanY_instr;
    elseif strcmp(scanXcom_type,'SIM928')
        scanYcom_instr=scanXcom_instr; 
    else
        scanYcom_instr=instrument_address('SIM928');
        fopen(scanYcom_instr); 
    end
    SIM900_connect(scanYcom_instr, SIM_portYcom);
    SIM900_port=SIM_portYcom;
elseif strcmp('keysight_CH1',Ycompensate_selection) 
    scanYcom_type='keysight33510B_CH1';
    if strcmp(scanX_type,'keysight33510B_CH2')
        scanYcom_instr=scanX_instr;
    elseif strcmp(scanY_type,'keysight33510B_CH2')
        scanYcom_instr=scanY_instr;
    elseif strcmp(scanXcom_type,'keysight33510B_CH2')
        scanYcom_instr=scanXcom_instr;
    else
        scanYcom_instr=instrument_address('keysight33510B');
        fopen(scanYcom_instr);
    end
elseif strcmp('keysight_CH2',Ycompensate_selection) 
    scanYcom_type='keysight33510B_CH2';
    if strcmp(scanX_type,'keysight33510B_CH1')
        scanYcom_instr=scanX_instr; 
    elseif strcmp(scanY_type,'keysight33510B_CH1')
        scanYcom_instr=scanY_instr;
    elseif strcmp(scanXcom_type,'keysight33510B_CH1')
        scanYcom_instr=scanXcom_instr;
    else
        scanYcom_instr=instrument_address('keysight33510B');
        fopen(scanYcom_instr);
    end
end
%% start measurement
message='';
eval(['app.massageEditField' scan_number_char '.Value=message;']);
if strcmp(bias_mode,'dV')
    Q_cond=2*(1.6e-19)^2/6.63e-34;
    y_label{1}='dI/dV  (2e^2/h)';
    y_label{2}='I_{dc}  (A)';
else
    Q_cond=1000;          % convert to kOhm
    y_label{1}='dV/dI  (kOhm)';
    y_label{2}='V_{dc}  (V)';
end

    %define the data variables
    x_number=length(scanX);
    y_number=length(scanY);   
    Data_scanY=zeros(1,y_number);
    Data_scanY_Read=zeros(1,y_number);
    Data_scanY_Read2=zeros(1,y_number);
    Data_scanX=zeros(y_number,x_number);
    Data_scanX_Read=zeros(y_number,x_number);
    Data_scanX_Read2=zeros(y_number,x_number);
    if select_lockin8==1
        Data_lockin8X=zeros(y_number,x_number);
        Data_lockin8Y=zeros(y_number,x_number);
        Data_lockin8R=zeros(y_number,x_number);
        Data_lockin8theta=zeros(y_number,x_number);
    end
    if select_lockin9==1
        Data_lockin9X=zeros(y_number,x_number);
        Data_lockin9Y=zeros(y_number,x_number);
        Data_lockin9R=zeros(y_number,x_number);
        Data_lockin9theta=zeros(y_number,x_number);
    end
    if select_lockin10==1
        Data_lockin10X=zeros(y_number,x_number);
        Data_lockin10Y=zeros(y_number,x_number);
        Data_lockin10R=zeros(y_number,x_number);
        Data_lockin10theta=zeros(y_number,x_number);
    end
    if select_34461A==1
        Data_34461A=zeros(y_number,x_number);        
    end
    
    if ~strcmp(Ycompensate_selection,'none')
        Data_scanYcom=zeros(1,y_number);
        Data_scanYcom_Read=zeros(1,y_number);
        Data_scanYcom_Read2=zeros(1,y_number);
    end
    if ~strcmp(Xcompensate_selection,'none')
        Data_scanXcom=zeros(y_number,x_number);
        Data_scanXcom_Read=zeros(y_number,x_number);
        Data_scanXcom_Read2=zeros(y_number,x_number);
    end      
    Data_Y=zeros(1,x_number);
          
    %% start scanning     
    %go to scanY(1) 
%     if strcmp(scanY_type,'DC205')&&DC205_port~=portY
%         SX199_Link(scanY_instr, portY);
%         DC205_port=portY;       
%     end
    if strcmp(scanY_type,'SIM928')&&SIM900_port~=SIM_portY      
        SIM900_connect(scanY_instr, SIM_portY);
        SIM900_port=SIM_portY;
    end
    ch_reset(scanY_instr,scanY_type,scanY(1),y_reset_step); 
    %go to scanYcom(1)     
    if ~strcmp(Ycompensate_selection,'none')
%         if strcmp(scanYcom_type,'DC205')&&DC205_port~=portYcom           
%             SX199_Link(scanYcom_instr, portYcom);
%             DC205_port=portYcom;       
%         end
        if strcmp(scanYcom_type,'SIM928')&&SIM900_port~=SIM_portYcom      
            SIM900_connect(scanYcom_instr, SIM_portYcom);
            SIM900_port=SIM_portYcom;
        end
        ch_reset(scanYcom_instr,scanYcom_type,scanYcom(1),Ycom_reset_step);
    end
    %% start scanning Y
    for ii=1:length(scanY)
%         if strcmp(scanY_type,'DC205')&&DC205_port~=portY
%             SX199_Link(scanY_instr, portY);
%             DC205_port=portY;       
%         end
        if strcmp(scanY_type,'SIM928')&&SIM900_port~=SIM_portY      
            SIM900_connect(scanY_instr, SIM_portY);
            SIM900_port=SIM_portY;
        end
        onecurve_start=tic;
        if stop_check==1 % stop check of ii loop
            message='stop!';
            eval(['app.massageEditField' scan_number_char '.Value=message;']);
            break;
        end
        y=scanY(ii);
        ch_set(scanY_instr,scanY_type,y);
        
        if ~strcmp(Ycompensate_selection,'none')
%             if strcmp(scanYcom_type,'DC205')&&DC205_port~=portYcom
%                 SX199_Link(scanYcom_instr, portYcom);
%                 DC205_port=portYcom;       
%             end
            if strcmp(scanYcom_type,'SIM928')&&SIM900_port~=SIM_portYcom      
                SIM900_connect(scanYcom_instr, SIM_portYcom);
                SIM900_port=SIM_portYcom;
            end
            Ycom=scanYcom(ii);
            ch_set(scanYcom_instr,scanYcom_type,Ycom);
            read=ch_read(scanYcom_instr,scanYcom_type); 
            Data_scanYcom(ii)=Ycom;
            Data_scanYcom_Read(ii)=read(1);
            Data_scanYcom_Read2(ii)=read(2);  % for keithley, this is current
%             if strcmp(scanY_type,'DC205')&&DC205_port~=portY
%                 SX199_Link(scanY_instr, portY);
%                 DC205_port=portY;       
%             end
            if strcmp(scanY_type,'SIM928')&&SIM900_port~=SIM_portY      
                SIM900_connect(scanY_instr, SIM_portY);
                SIM900_port=SIM_portY;
            end
        end
        
        pause(y_delay);
        read=ch_read(scanY_instr,scanY_type); 
        Data_scanY(ii)=y;
        Data_scanY_Read(ii)=read(1);
        Data_scanY_Read2(ii)=read(2);  % for keithley, this is current
        message=num2str(scanY(ii),'%.6f');
        str=['app.scanY_nowEditField' scan_number_char '.Value=message;'];
        eval(str);   %display the value of scanY
        
        fileID=fopen(file_name,'at');       
        %go to the start point of scanX(1)
%         if strcmp(scanX_type,'DC205')&&DC205_port~=portX          %toggle port for X
%             SX199_Link(scanX_instr, portX);
%             DC205_port=portX;       
%         end
        if strcmp(scanX_type,'SIM928')&&SIM900_port~=SIM_portX      
            SIM900_connect(scanX_instr, SIM_portX);
            SIM900_port=SIM_portX;
        end
        ch_reset(scanX_instr,scanX_type,scanX(1),x_reset_step);   %go to scanX(1)
        %go to scanXcom(1)  
        if ~strcmp(Xcompensate_selection,'none') 
%             if strcmp(scanXcom_type,'DC205')&&DC205_port~=portXcom
%                 SX199_Link(scanXcom_instr, portXcom);
%                 DC205_port=portXcom;       
%             end
            if strcmp(scanXcom_type,'SIM928')&&SIM900_port~=SIM_portXcom      
                SIM900_connect(scanXcom_instr, SIM_portXcom);
                SIM900_port=SIM_portXcom;
            end
            ch_reset(scanXcom_instr,scanXcom_type,scanXcom(1),Xcom_reset_step);
%             if strcmp(scanX_type,'DC205')&&DC205_port~=portX
%                 SX199_Link(scanX_instr, portX);
%                 DC205_port=portX;       
%             end
            if strcmp(scanX_type,'SIM928')&&SIM900_port~=SIM_portX      
                SIM900_connect(scanX_instr, SIM_portX);
                SIM900_port=SIM_portX;
            end
        end
        
        switch scanX_type
            case 'magX_continuous'
                target_field=Target_Field(2);
                magX_SetTargetField(scanX_instr,target_field);   %set the stop target field
                mag_Ramp(scanX_instr); 
            case 'magY_continuous'
                target_field=Target_Field(2);
                magY_SetTargetField(scanX_instr,target_field);   %set the stop target field
                mag_Ramp(scanX_instr); 
            case 'magZ_continuous'
                target_field=Target_Field(2);
                magZ_SetTargetField(scanX_instr,target_field);   %set the stop target field
                mag_Ramp(scanX_instr);
            case 'magXZ_continuous'               
                magX_SetRampRate(scanX_instr{1},B_rateX(1));
                ramp_rate1=mag_ReadRampRate(scanX_instr{1});
                magZ_SetRampRate(scanX_instr{2},B_rateX(2));
                ramp_rate2=mag_ReadRampRate(scanX_instr{2});
                B_rateX(3)=ramp_rate1;
                B_rateX(4)=ramp_rate2;
                display(B_rateX);
                magX_SetTargetField(scanX_instr{1},Target_Field(1)); 
                magZ_SetTargetField(scanX_instr{2},Target_Field(2));   %set the stop target field
                mag_Ramp(scanX_instr{1}); 
                mag_Ramp(scanX_instr{2});
            case 'magYZ_continuous'
                magY_SetRampRate(scanX_instr{1},B_rateX(1)); 
                ramp_rate1=mag_ReadRampRate(scanX_instr{1});
                magZ_SetRampRate(scanX_instr{2},B_rateX(2)); 
                ramp_rate2=mag_ReadRampRate(scanX_instr{2});
                B_rateX(3)=ramp_rate1;
                B_rateX(4)=ramp_rate2;
                display(B_rateX);
                magY_SetTargetField(scanX_instr{1},Target_Field(1)); 
                magZ_SetTargetField(scanX_instr{2},Target_Field(2));   %set the stop target field
                mag_Ramp(scanX_instr{1}); 
                mag_Ramp(scanX_instr{2});
            case 'magXY_continuous'
                magX_SetRampRate(scanX_instr{1},B_rateX(1));
                ramp_rate1=mag_ReadRampRate(scanX_instr{1});
                magY_SetRampRate(scanX_instr{2},B_rateX(2));
                ramp_rate2=mag_ReadRampRate(scanX_instr{2});
                B_rateX(3)=ramp_rate1;
                B_rateX(4)=ramp_rate2;
                display(B_rateX);
                magX_SetTargetField(scanX_instr{1},Target_Field(1)); 
                magY_SetTargetField(scanX_instr{2},Target_Field(2));   %set the stop target field
                mag_Ramp(scanX_instr{1}); 
                mag_Ramp(scanX_instr{2});                
        end
                 
        % start scan X
        for n = 1:length(scanX)
            x=scanX(n);            
            ch_set(scanX_instr,scanX_type,x);
            
            if ~strcmp(Xcompensate_selection,'none')
%                 if strcmp(scanXcom_type,'DC205')&&DC205_port~=portXcom
%                     SX199_Link(scanXcom_instr, portXcom);
%                     DC205_port=portXcom;       
%                 end
                if strcmp(scanXcom_type,'SIM928')&&SIM900_port~=SIM_portXcom      
                    SIM900_connect(scanXcom_instr, SIM_portXcom);
                    SIM900_port=SIM_portXcom;
                end
                Xcom=scanXcom(n);
                ch_set(scanXcom_instr,scanXcom_type,Xcom);
                read=ch_read(scanXcom_instr,scanXcom_type); 
                Data_scanXcom(ii,n)=Xcom;
                Data_scanXcom_Read(ii,n)=read(1);
                Data_scanXcom_Read2(ii,n)=read(2);  % for keithley, this is current
%                 if strcmp(scanX_type,'DC205')&&DC205_port~=portX       
%                     SX199_Link(scanX_instr, portX);
%                     DC205_port=portX; 
%                 end
                if strcmp(scanX_type,'SIM928')&&DC205_port~=SIM_portX 
                    SIM900_connect(scanX_instr, SIM_portX);
                    SIM900_port=SIM_portX;
                end
            end
            
            pause(x_delay);            
            read=ch_read(scanX_instr,scanX_type);  
            Data_scanX(ii,n)=x;
            Data_scanX_Read(ii,n)=read(1);
            Data_scanX_Read2(ii,n)=read(2);  % for keithley, magXY_continuous and so on
            if select_lockin8==1
                [X, Y, R, theta] = SR830_ReadAll(lockin8);
                Data_lockin8X(ii,n)=X;
                Data_lockin8Y(ii,n)=Y;
                Data_lockin8R(ii,n)=R;
                Data_lockin8theta(ii,n)=theta;
            end
            if select_lockin9==1
                [X, Y, R, theta] = SR830_ReadAll(lockin9);
                Data_lockin9X(ii,n)=X;
                Data_lockin9Y(ii,n)=Y;
                Data_lockin9R(ii,n)=R;
                Data_lockin9theta(ii,n)=theta;
            end
            if select_lockin10==1
                [X, Y, R, theta] = SR830_ReadAll(lockin10);
                Data_lockin10X(ii,n)=X;
                Data_lockin10Y(ii,n)=Y;
                Data_lockin10R(ii,n)=R;
                Data_lockin10theta(ii,n)=theta;
            end
            if select_34461A==1               
                Data_34461A(ii,n)=keysight34461A_Read(keysight34461A,0.3,1);                
            end

            
            % plot main data            
            try                
                str=['app.plot_y_axisDropDown' scan_number_char '.Value;'];
                y_axis=eval(str);
                y_label_name=y_label{1};
                switch y_axis(1)
                    case '1'                        
                        Data_Y(1:n)=Data_lockin8X(ii,1:n)*Sensitivity/dV/Q_cond;
                    case '2'
                        Data_Y(1:n)=Data_lockin8R(ii,1:n)*Sensitivity/dV/Q_cond;                   
                    case '3'
                        Data_Y(1:n)=Data_lockin9X(ii,1:n)*Sensitivity/dV/Q_cond;                   
                    case '4'
                        Data_Y(1:n)=Data_lockin9R(ii,1:n)*Sensitivity/dV/Q_cond;
                    case '5'
                        Data_Y(1:n)=Data_lockin10X(ii,1:n)*Sensitivity/dV/Q_cond;                   
                    case '6'
                        Data_Y(1:n)=Data_lockin10R(ii,1:n)*Sensitivity/dV/Q_cond;
                    case '7'    
                        Data_Y(1:n)=Data_34461A(ii,1:n)*Sensitivity;      %the DC current
                        y_label_name=y_label{2};
                end                
                figure(1);clf;                    
                plot(Data_scanX_Read(ii,1:n),Data_Y(1:n),'-o','MarkerSize',2,'Color','b') 
                xlabel(x_name);
                ylabel(y_label_name);
            catch
                message='Check the y_axis selection!';
                eval(['app.massageEditField' scan_number_char '.Value=message;'])
            end
            
          %% finish point-measurement, write x\y\data as formation of x\y\0\data\0 to file.
            fprintf(fileID, '%.7E\t', Data_scanY(ii));
            fprintf(fileID, '%.7E\t', Data_scanY_Read(ii));
            fprintf(fileID, '%.7E\t', Data_scanX(ii,n));
            fprintf(fileID, '%.7E\t', Data_scanX_Read(ii,n));
            if select_lockin8==1
                fprintf(fileID, '%.7E\t', Data_lockin8X(ii,n));
                fprintf(fileID, '%.7E\t', Data_lockin8Y(ii,n));
                fprintf(fileID, '%.7E\t', Data_lockin8R(ii,n));
                %fprintf(fileID, '%.7E\t', Data_lockin8theta(ii,n));
                if strcmp(bias_mode,'dV')
                    lockin8_Conductance_X=1/(dV/(Data_lockin8X(ii,n)*Sensitivity)-Rs)/Q_cond;
                    fprintf(fileID, '%.7E\t', lockin8_Conductance_X);
                    lockin8_Conductance_R=1/(dV/(Data_lockin8R(ii,n)*Sensitivity)-Rs)/Q_cond; 
                    fprintf(fileID, '%.7E\t', lockin8_Conductance_R);  
                else
                    lockin8_Resistance_X=(Data_lockin8X(ii,n)*Sensitivity/dV-Rs)/Q_cond;
                    fprintf(fileID, '%.7E\t', lockin8_Resistance_X);
                    lockin8_Resistance_R=(Data_lockin8R(ii,n)*Sensitivity/dV-Rs)/Q_cond; 
                    fprintf(fileID, '%.7E\t', lockin8_Resistance_R);  
                end    
            end
            if select_lockin9==1
                fprintf(fileID, '%.7E\t', Data_lockin9X(ii,n));
                fprintf(fileID, '%.7E\t', Data_lockin9Y(ii,n));
                fprintf(fileID, '%.7E\t', Data_lockin9R(ii,n));
                %fprintf(fileID, '%.7E\t', Data_lockin9theta(ii,n));
                if strcmp(bias_mode,'dV')
                    lockin9_Conductance_X=1/(dV/(Data_lockin9X(ii,n)*Sensitivity)-Rs)/Q_cond;
                    fprintf(fileID, '%.7E\t', lockin9_Conductance_X); 
                    lockin9_Conductance_R=1/(dV/(Data_lockin9R(ii,n)*Sensitivity)-Rs)/Q_cond; 
                    fprintf(fileID, '%.7E\t', lockin9_Conductance_R);  
                else
                    lockin9_Resistance_X=(Data_lockin9X(ii,n)*Sensitivity/dV-Rs)/Q_cond;
                    fprintf(fileID, '%.7E\t', lockin9_Resistance_X); 
                    lockin9_Resistance_R=(Data_lockin9R(ii,n)*Sensitivity/dV-Rs)/Q_cond; 
                    fprintf(fileID, '%.7E\t', lockin9_Resistance_R);  
                end
            end
            if select_lockin10==1
                fprintf(fileID, '%.7E\t', Data_lockin10X(ii,n));
                fprintf(fileID, '%.7E\t', Data_lockin10Y(ii,n));
                fprintf(fileID, '%.7E\t', Data_lockin10R(ii,n));
                %fprintf(fileID, '%.7E\t', Data_lockin10theta(ii,n));
                if strcmp(bias_mode,'dV')
                    lockin10_Conductance_X=1/(dV/(Data_lockin10X(ii,n)*Sensitivity)-Rs)/Q_cond;
                    fprintf(fileID, '%.7E\t', lockin10_Conductance_X); 
                    lockin10_Conductance_R=1/(dV/(Data_lockin10R(ii,n)*Sensitivity)-Rs)/Q_cond; 
                    fprintf(fileID, '%.7E\t', lockin10_Conductance_R);  
                else
                    lockin10_Resistance_X=(Data_lockin10X(ii,n)*Sensitivity/dV-Rs)/Q_cond;
                    fprintf(fileID, '%.7E\t', lockin10_Resistance_X); 
                    lockin10_Resistance_R=(Data_lockin10R(ii,n)*Sensitivity/dV-Rs)/Q_cond; 
                    fprintf(fileID, '%.7E\t', lockin10_Resistance_R);  
                end
            end
            if select_34461A==1
                fprintf(fileID, '%.7E\t', Data_34461A(ii,n));                       
            end
            if ~strcmp(Ycompensate_selection,'none')
                fprintf(fileID, '%.7E\t', Data_scanYcom(ii));
                fprintf(fileID, '%.7E\t', Data_scanYcom_Read(ii));
            end
            if ~strcmp(Xcompensate_selection,'none')
                fprintf(fileID, '%.7E\t', Data_scanXcom(ii,n));
                fprintf(fileID, '%.7E\t', Data_scanXcom_Read(ii,n));
            end
            fprintf(fileID,'\n');
                                                                          
            if stop_check==1 % stop check of n loop
                message='stop!';
                eval(['app.massageEditField' scan_number_char '.Value=message;']);
                break;
            end
            
            % stop check of n loop for B continuous sweep
            if strcmp(scanX_type,'magZ_continuous')==1||strcmp(scanX_type,'magX_continuous')==1||strcmp(scanX_type,'magY_continuous')==1
                status=mag_ReadRampState(scanX_instr);
                if status==2
                    break;
                end
            end
            
            if strcmp(scanX_type,'magXZ_continuous')==1||strcmp(scanX_type,'magYZ_continuous')==1||strcmp(scanX_type,'magXY_continuous')==1
                status=mag_ReadRampState(scanX_instr{1});
                if status==2
                    break;
                end
            end
                  
        end
        
        % finish one curve      
        fclose(fileID);

        %plot data, reference figure 
            figure(2);clf
            subplot(2,2,1)        
            if strcmp(scanY_type,'kei')
                plot(Data_scanY(1:ii),Data_scanY_Read2(1:ii),'-o','MarkerSize',2,'Color','b')
                ylabel('I(A)');
            else
                plot(Data_scanY(1:ii),Data_scanY_Read(1:ii),'-o','MarkerSize',2,'Color','b')
                ylabel('scanY read');
            end
            xlabel('scanY set');

            subplot(2,2,2)      
            if strcmp(scanX_type,'kei')            
                plot(Data_scanX(ii,1:n),Data_scanX_Read2(ii,1:n),'-o','MarkerSize',2,'Color','b')
                ylabel('I(A)');
            else
                plot(Data_scanX(ii,1:n),Data_scanX_Read(ii,1:n),'-o','MarkerSize',2,'Color','b')
                ylabel('scanX read');
            end
            xlabel('scanX set');
            
            subplot(2,2,3)
            hold on;
            if select_lockin8==1
                plot(Data_scanX(ii,1:n),Data_lockin8theta(ii,1:n),'-o','MarkerSize',2,'Color','b')
            end
            if select_lockin9==1                
                plot(Data_scanX(ii,1:n),Data_lockin9theta(ii,1:n),'-o','MarkerSize',2,'Color','r')
            end  
            if select_lockin10==1
                plot(Data_scanX(ii,1:n),Data_lockin10theta(ii,1:n),'-o','MarkerSize',2,'Color','k')
            end
            ylabel('lockin \theta');
            xlabel('scanX set');
            
            if ~strcmp(Ycompensate_selection,'none')
                subplot(2,2,4)
                plot(Data_scanY(1:ii),Data_scanYcom_Read(1:ii),'-o','MarkerSize',2,'Color','b')                
                ylabel('scanYCom read');
                xlabel('scanY set');
            end
            
            if ~strcmp(Xcompensate_selection,'none')
                subplot(2,2,4)
                plot(Data_scanX(ii,1:n),Data_scanXcom_Read(ii,1:n),'-o','MarkerSize',2,'Color','r')                
                ylabel('scanXCom read');
                xlabel('scanX set');
            end
            
            if strcmp(scanX_type,'magXZ_continuous')==1||strcmp(scanX_type,'magYZ_continuous')==1||strcmp(scanX_type,'magXY_continuous')==1
                subplot(2,2,4);cla;
                Data_Y(1:n)=acos(Data_scanX_Read2(ii,1:n)./Data_scanX_Read(ii,1:n))*180/pi;               
                plot(Data_scanX(ii,1:n),Data_Y(1:n),'-o','MarkerSize',2,'Color','b')
                ylabel('phi(degree) read');
                xlabel('scanX set');               
            end
                                       
           %% save data
            date = datestr(now,'dd');
            time=datestr(now, 'hh_MM_SS');
            figure1Name = [time];
            figure2Name = [time, 'appendix'];
            if date == Date
                Fullname = fullname;
            else
                mkdir(fullname, date);
                Fullname = [fullname, '\', date];
            end
            allvar=whos;
            saveIndex=cellfun(@isempty,regexp({allvar.class},'matlab.ui|measure_app|struct|visa|gpib|tcpip'));
            saveVars={allvar(saveIndex).name};
            save([Fullname, '\', DataName],saveVars{:});
            figure(1)
            box on;
            title(['scanY now=' num2str(scanY(ii),'%.6f')]);
%             saveas(1,[Fullname, '\', figure1Name],'fig');
            saveas(1,[Fullname, '\', figure1Name],'png');                       
%             saveas(2,[Fullname, '\', figure2Name],'fig'); 
            saveas(2,[Fullname, '\', figure2Name],'png'); 
                                   
            %calculate the remaining time
            onecurve_time=toc(onecurve_start);
            remaining_time=(length(scanY)-ii)*onecurve_time;            
            remaining_time_hours=floor(remaining_time/3600);
            remaining_time_minutes=ceil((remaining_time/3600-remaining_time_hours)*60);
            message=[num2str(remaining_time_hours) 'h' num2str(remaining_time_minutes) 'min'];
            str=['app.RemainingTimeEditField' scan_number_char '.Value=message;'];
            eval(str);      
    end
        
    %% measurement finished
    exportapp(app.UIFigure,[fullname '\' Time '.pdf']) 
    if stop_check==0        
        message='Measurement finished!';
        eval(['app.massageEditField' scan_number_char '.Value=message;'])
    else        
        message='Measurement stopped!';
        eval(['app.massageEditField' scan_number_char '.Value=message;'])
    end