% For all the data files within a directory, uses the Blinker toolbox to
% comput relevant information regarding average blinking frequency.

%% ------------------------------------------------------------------------
% Options you may want to change
% -------------------------------------------------------------------------
% Files
data_folder = 'Data/pruneX/'; % Folder with the data files
file_type = '.set'; % File extension of the data files
save_folder = 'Data/blinkX/'; % EEGlab datasets will be saved here

%% ------------------------------------------------------------------------
% Code
% -------------------------------------------------------------------------
% Modify default params structure

% Look through all files in the data folder
mkdir(save_folder) % Create folder for output text files
files = dir([data_folder, '*', file_type]);
for file = files' % For every data file within the folder
    EEG = pop_loadset('filename', file.name, 'filepath', file.folder);

    % General struct parameters
    params = checkBlinkerDefaults(struct(), getBlinkerDefaults(EEG));
    params.dumpBlinkerStructures = true; % Only dump data structs
    params.dumpBlinkImages = false;
    params.dumpBlinkPositions = false;
    params.keepSignals = false;
    params.showMaxDistribution = false;
    params.verbose = true;

    % Struct parameters specific for the dataset
    params.srate = EEG.srate;
    params.fileName = [file.folder, file.name];
    outname = [file.name(1:end-length(file_type)), '_blinks.mat'];
    params.blinkerSaveFile = outname;

    % Compute blinker structs
    pop_blinker(EEG, params);

    % Load blinker struct, load all data, and delete struct
    load(outname);
    blinkNumbers = [blinkFits(:).number];
    blinkTimes = [blinkProperties(:).peakTimeBlink];
    delete(outname);

    % Compute relevant parameters
    contigous = find(diff(blinkNumbers) == 1);
    blinkTimeDiff = diff(blinkTimes);
    contBlinkTimeDiff = blinkTimeDiff(contigous);
    avgContBlinkTimeDiff = mean(contBlinkTimeDiff);
    stdContBlinkTimeDiff = std(contBlinkTimeDiff);
    globalAvgBlinksPerSecond = blinkStatistics.numberGoodBlinks / blinkStatistics.seconds;

    % Save relevant parameters
    save([save_folder, outname], 'avgContBlinkTimeDiff', ...
        'stdContBlinkTimeDiff', 'globalAvgBlinksPerSecond');
end