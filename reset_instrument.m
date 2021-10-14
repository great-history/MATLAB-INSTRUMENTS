newobjs = instrfind;

for ii=1:length(newobjs)
    try
        fclose(newobjs(ii));     % disconnect interface object from instrument
    catch
        'do nothing';
    end
    try
        delete(newobjs(ii));     % Remove instrument objects from memory
    catch
        'do nothing';
    end
end

% pretty darn tricky to clear from WORKSPACE also the obj variables, and
% it has to be done!
allvar = whos;

for ii=1:length(allvar)
    if(strcmp(allvar(ii).class, 'visa') == 1)||(strcmp(allvar(ii).class, 'tcpip') == 1)||(strcmp(allvar(ii).class, 'gpib') == 1)
        clear(allvar(ii).name);
    end
end
