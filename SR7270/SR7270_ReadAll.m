function [X, Y, R, theta]=SR7270_ReadAll(Device);

fprintf(Device,'MP. '); 
Data_read = scanstr(Device);
R = Data_read{1};
theta = Data_read{2};
scanstr(Device); % ∂¡µÙ £”‡\0
fprintf(Device, 'XY. ');
Data_read = scanstr(Device);
X = Data_read{1};
Y = Data_read{2};
scanstr(Device);% ∂¡µÙ £”‡\0
