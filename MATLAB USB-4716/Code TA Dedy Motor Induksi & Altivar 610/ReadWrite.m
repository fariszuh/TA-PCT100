function [arr_vrpm, arr_time] = ReadWrite(VoltAO0,VoltAO1)
% int main, looping once
% clear; clf; clc

BDaq = NET.addAssembly('Automation.BDaq4'); % Make Automation.BDaq assembly visible to MATLAB.

deviceDescription = 'USB-4716,BID#0'; 
startChannelAi = int32(0);
channelCountAi = int32(2);

channelStartAo = int32(0);
channelCountAo = int32(1);

Ts=0.05;
global arr_vrpm arr_time;
arr_vrpm=[];
arr_time=[];

instantAiCtrl = Automation.BDaq.InstantAiCtrl();
instantAoCtrl = Automation.BDaq.InstantAoCtrl();

try
    instantAiCtrl.SelectedDevice = Automation.BDaq.DeviceInformation(deviceDescription);
    instantAoCtrl.SelectedDevice = Automation.BDaq.DeviceInformation(deviceDescription);
    % Generate waveform data.
    data = NET.createArray('System.Double', channelCountAi);
    
    errorCode2 = Automation.BDaq.ErrorCode.Success;
     if BioFailed(errorCode2)    
        throw Exception();
    end
    start_time= tic;
    
    errorCode = Automation.BDaq.ErrorCode();

    t = timer('TimerFcn', {@TimerCallback, instantAiCtrl, startChannelAi, ...
        channelCountAi,instantAoCtrl,data,start_time,VoltAO0,VoltAO1}, 'period', Ts, 'executionmode', 'fixedrate', ...
        'StartDelay', 1); % Read samples and do post-process, we show data here.

    start(t);
    input('InstantAI-AO is in progress...Press Enter key to quit!');
    stop(t);
    delete(t);
catch e
    if BioFailed(errorCode)    
        errStr = 'Some error occurred. And the last error code is ' ... 
            + errorCode.ToString(); % if Something is wrong.
    else
        errStr = e.message;
    end
    disp(errStr); 
end

instantAiCtrl.Dispose(); % Close device and release any allocated resource.
instantAoCtrl.Dispose();
plot(arr_time,arr_vrpm);
end

%% Jangan ubah kode dibawah
function result = BioFailed(errorCode)
    result =  errorCode < Automation.BDaq.ErrorCode.Success && ...
            errorCode >= Automation.BDaq.ErrorCode.ErrorHandleNotValid;
end

function [vrpm, level] = TimerCallback(obj, event, instantAiCtrl, startChannelAi, channelCountAi, ...
     instantAoCtrl,data, start_time,VoltAO0,VoltAO1)
    global arr_vrpm arr_time;  
    gain_rpm = 211.101;
    errorCode = instantAiCtrl.Read(startChannelAi, channelCountAi, data); 
%     kontroller(); 
    errorCode2 = instantAoCtrl.Write(0,1,VoltAO0);
    errorCode3 = instantAoCtrl.Write(1,1,VoltAO1);
    
    if BioFailed(errorCode)
        throw Exception();
    end
    if BioFailed(errorCode2)
            e = MException('DAQWarning:Notcompleted', ...
                'StaticAO is completed compulsorily!');
            throw (e);
    end
    fprintf('\n');
    current_time = toc(start_time);
    fprintf('timestamp = %2.5f | ', current_time);
    
    for j=0:(channelCountAi - 1)
        if j == 0
            vrpm = data.Get(0)*gain_rpm;
        elseif j == 1
            level = data.Get(1);
            fprintf('rpm = %2.5f ', vrpm);
            arr_vrpm = [arr_vrpm vrpm];
        end
    end
    arr_time = [arr_time current_time];
    
end