function ReadWrite_bebanStokastik(VoltAO0,VoltAO1)
% int main, looping once
% clear; clf; clc

BDaq = NET.addAssembly('Automation.BDaq4'); % Make Automation.BDaq assembly visible to MATLAB.

deviceDescription = 'USB-4716,BID#0'; 
startChannelAi = int32(0);
channelCountAi = int32(2);

channelStartAo = int32(0);
channelCountAo = int32(1);

Ts=0.05;
global arr_volt_AI0 arr_volt_AI1 arr_time arr_volt_AO0 arr_volt_AO1 current_time_beban;
arr_volt_AI0=[];
arr_volt_AI1=[];

arr_volt_AO0 = [];
arr_volt_AO1 = [];
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
    start_time = tic;
    errorCode = Automation.BDaq.ErrorCode();
    
    current_time_beban = toc(start_time); % ambil waktu pertama untuk beban
%     volt_AO0 = 0;
%     volt_AO1 = 0;
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

figure;
hold on;
title("Plot AO0");
ylabel("AO0 (Volt)");
plot(arr_time,arr_volt_AI0);
% plot(arr_time,arr_volt_AI0);
hold off;
xlabel("t (detik)");

figure;
hold on;
title("Plot AO1");
xlabel("t (detik)");
ylabel("AO1 (Volt)");
plot(arr_time,arr_volt_AI1);
% plot(arr_time,arr_volt_AI0);
hold off;

% plot(arr_time,arr_voltRamp_AO0);
% save("USB4716_bebanStokastik.mat","arr_time", "arr_voltRamp_AO0","arr_voltRamp_AO1");
save("USB4716_AI_Ramp.mat","arr_time","arr_volt_AI0","arr_volt_AI1");
end

%% Jangan ubah kode dibawah
function result = BioFailed(errorCode)
    result =  errorCode < Automation.BDaq.ErrorCode.Success && ...
            errorCode >= Automation.BDaq.ErrorCode.ErrorHandleNotValid;
end

function [volt_AI0, volt_AI1] = TimerCallback(obj, event, instantAiCtrl, startChannelAi, channelCountAi, ...
     instantAoCtrl,data, start_time,VoltAO0,VoltAO1)
    global arr_volt_AI0 arr_volt_AI1 arr_time arr_volt_AO0 arr_volt_AO1 current_time_beban volt_AO0 volt_AO1;    
    errorCode = instantAiCtrl.Read(startChannelAi, channelCountAi, data); 
    
    current_time = toc(start_time); % waktu AO terhadap sampling time Ts
    
    Ts_beban = 15; % dalam detik
    diffTime = current_time - current_time_beban;
    if diffTime >= Ts_beban
        volt_AO0 = 5*rand(1) + 5; % mengganti sinyal kontrol setelah melewati Ts
        volt_AO1 = VoltAO1; % dibuat tetap 10V karena pompa
        current_time_beban = current_time; % ambil waktu pertama untuk beban
    else
%         volt_AO0 = 0;
%         volt_AO1 = 0;
    end
    
    if volt_AO0 > 10
        volt_AO0 = 10;
    elseif volt_AO0 < 0
        volt_AO0 = 0;
    end
    if volt_AO1 > 10
        volt_AO1 = 10;
    elseif volt_AO1 < 0
        volt_AO1 = 0;
    end
    errorCode2 = instantAoCtrl.Write(0,1,volt_AO0);
    errorCode3 = instantAoCtrl.Write(1,1,volt_AO1);

    arr_volt_AO0 = [arr_volt_AO0 volt_AO0];
    arr_volt_AO1 = [arr_volt_AO1 volt_AO1];
    
    if BioFailed(errorCode)
        throw Exception();
    end
    if BioFailed(errorCode2)
            e = MException('DAQWarning:Notcompleted', ...
                'StaticAO is completed compulsorily!');
            throw (e);
    end
    fprintf('\n');
    
    fprintf('timestamp = %2.5f | current_time_beban = %2.5f | diffTime = %2.5f | ', current_time, current_time_beban, diffTime);
    
    for j=0:(channelCountAi - 1)
        if j == 0
            volt_AI0 = data.Get(0);
        elseif j == 1
            volt_AI1 = data.Get(1);
%             fprintf('volt_AI0 = %2.5f ; volt_AI1 = %2.5f ', volt_AI0, volt_AI1);
            fprintf('volt_AO0 = %2.5f ; volt_AO1 = %2.5f ', volt_AO0, volt_AO1);
            arr_volt_AI0 = [arr_volt_AI0 volt_AI0];
            arr_volt_AI1 = [arr_volt_AI1 volt_AI1];
        end
    end
    arr_time = [arr_time current_time];
    
end