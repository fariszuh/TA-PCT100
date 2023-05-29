function StaticAO()
clear; clc
BDaq = NET.addAssembly('Automation.BDaq4');
oneWavePointCount = int32(512);

deviceDescription = 'USB-4716,BID#0';
channelStart = int32(0);
channelCount = int32(1);

errorCode = Automation.BDaq.ErrorCode.Success;

instantAoCtrl = Automation.BDaq.InstantAoCtrl();

try
    instantAoCtrl.SelectedDevice = Automation.BDaq.DeviceInformation(...
        deviceDescription);
    

    if BioFailed(errorCode)    
        throw Exception();
    end

    scaleData = NET.createArray('System.Double', int32(128));
    
    t = timer('TimerFcn',{@TimerCallback, instantAoCtrl}, ...
        'period', 0.01, 'executionmode', 'fixedrate', ...
        'StartDelay', 1);
    start(t);
    input('Outputting data...Press Enter key to quit!', 's');
    if isvalid(t)
    disp('StaticAO is completed compulsorily!');    
    stop(t);
    delete(t); 
    end
catch e
    % Something is wrong. 
    if BioFailed(errorCode)    
        errStr = 'Some error occurred. And the last error code is ' ... 
            + errorCode.ToString();
    else
        errStr = e.message;
    end
    disp(errStr);
end   

instantAoCtrl.Dispose();
end

function result = BioFailed(errorCode)
    result =  errorCode < Automation.BDaq.ErrorCode.Success && ...
            errorCode >= Automation.BDaq.ErrorCode.ErrorHandleNotValid;
end

function TimerCallback(obj, event, instantAoCtrl)

    errorCode = instantAoCtrl.Write(0,...
            1, 3);
    if BioFailed(errorCode)
        e = MException('DAQWarning:Notcompleted', ...
            'StaticAO is completed compulsorily!');
        throw (e);
    end
    fprintf('\nStaticAO is completed, and press Enter key to quit!');
    clear functions;
    stop(obj);
    delete(obj);
end