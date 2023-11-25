function ReadWrite_volt_IO(VoltAO0,VoltAO1)
% int main, looping once
% clear; clf; clc

BDaq = NET.addAssembly('Automation.BDaq4'); % Make Automation.BDaq assembly visible to MATLAB.

deviceDescription = 'USB-4716,BID#0'; 
startChannelAi = int32(0);
channelCountAi = int32(2);

channelStartAo = int32(0);
channelCountAo = int32(1);

Ts=0.05;
global arr_volt_AI0 arr_volt_AI1 arr_time arr_voltRamp_AO0 arr_voltRamp_AO1;
arr_volt_AI0=[];
arr_volt_AI1=[];

arr_voltRamp_AO0 = [];
arr_voltRamp_AO1 = [];
arr_time=[];
% volt_AI0 = 0;
% volt_AI1 = 0;

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

    start_time_ramp = toc(start_time);
    t = timer('TimerFcn', {@TimerCallback, instantAiCtrl, startChannelAi, ...
        channelCountAi,instantAoCtrl,data,start_time, start_time_ramp, VoltAO0,VoltAO1}, 'period', Ts, 'executionmode', 'fixedrate', ...
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

figure;
hold on;
title("Plot AO0");
xlabel("t (detik)");
ylabel("AO0 (Volt)");
plot(arr_time,arr_voltRamp_AO0);
% plot(arr_time,arr_volt_AI0);
hold off;

figure;
hold on;
title("Plot AO1");
xlabel("t (detik)");
ylabel("AO1 (Volt)");
plot(arr_time,arr_voltRamp_AO1);
% plot(arr_time,arr_volt_AI0);
hold off;

% plot(arr_time,arr_voltRamp_AO0);
save("USB4716_AO_Ramp.mat","arr_time", "arr_voltRamp_AO0","arr_voltRamp_AO1");
% save("USB4716_AI_Ramp.mat","arr_time","arr_volt_AI0","arr_volt_AI1");
end

%% Jangan ubah kode dibawah
function result = BioFailed(errorCode)
    result =  errorCode < Automation.BDaq.ErrorCode.Success && ...
            errorCode >= Automation.BDaq.ErrorCode.ErrorHandleNotValid;
end

function [volt_AI0, volt_AI1] = TimerCallback(obj, event, instantAiCtrl, startChannelAi, channelCountAi, ...
     instantAoCtrl,data, start_time,start_time_ramp,VoltAO0,VoltAO1)
    global arr_volt_AI0 arr_volt_AI1 arr_time arr_voltRamp_AO0 arr_voltRamp_AO1 start_time_ramp_turun;    
    errorCode = instantAiCtrl.Read(startChannelAi, channelCountAi, data); 
%     kontroller(); 
    current_time = toc(start_time);
    if current_time <= 66
        voltRamp_AO0 = VoltAO0 * (current_time - start_time_ramp)/60;
        voltRamp_AO1 = VoltAO1 * (current_time - start_time_ramp)/60;
        start_time_ramp_turun = current_time;
    elseif current_time > 66
        voltRamp_AO0 = VoltAO0 - VoltAO0 * (current_time - start_time_ramp_turun)/60;
        voltRamp_AO1 = VoltAO1 - VoltAO1 * (current_time - start_time_ramp_turun)/60;
    end

    if voltRamp_AO0 > 10
        voltRamp_AO0 = 10;
    elseif voltRamp_AO0 < 0
        voltRamp_AO0 = 0;
    end
    if voltRamp_AO1 > 10
        voltRamp_AO1 = 10;
    elseif voltRamp_AO1 < 0
        voltRamp_AO1 = 0;
    end
    errorCode2 = instantAoCtrl.Write(0,1,voltRamp_AO0);
    errorCode3 = instantAoCtrl.Write(1,1,voltRamp_AO1);

    arr_voltRamp_AO0 = [arr_voltRamp_AO0 voltRamp_AO0];
    arr_voltRamp_AO1 = [arr_voltRamp_AO1 voltRamp_AO1];
    
    if BioFailed(errorCode)
        throw Exception();
    end
    if BioFailed(errorCode2)
            e = MException('DAQWarning:Notcompleted', ...
                'StaticAO is completed compulsorily!');
            throw (e);
    end
    fprintf('\n');
    
    fprintf('start_time_ramp = %2.5f | timestamp = %2.5f | ', start_time_ramp, current_time);
    
    for j=0:(channelCountAi - 1)
        if j == 0
            volt_AI0 = data.Get(0);
        elseif j == 1
            volt_AI1 = data.Get(1);
            fprintf('volt_AI0 = %2.5f ; volt_AI1 = %2.5f ', volt_AI0, volt_AI1);
            arr_volt_AI0 = [arr_volt_AI0 volt_AI0];
            arr_volt_AI1 = [arr_volt_AI1 volt_AI1];
        end
    end
    arr_time = [arr_time current_time];
    
end