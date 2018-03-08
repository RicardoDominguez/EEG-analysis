% For all the data files within a directory, preprocess them and run ICA
% analysis before saving the resulting component topoplots to a file.
% Preprocessing includes:
%   -Downsampling
%   -Bandpass filtering

%% ------------------------------------------------------------------------
% Options you may want to change
% -------------------------------------------------------------------------
% Files
data_folder = 'Data/rawData02-03-18/'; % Folder with the data files
file_type = '.txt'; % File extension of the data files
save_folder = 'Data/icaData02-03-18/'; % EEGlab datasets will be saved here
plot_folder = 'Plot/icaTopoplots02-03-18/'; % ICA topoplots will be saved here

% Original data
samplingHz = 500; % Original sample frequency in Hz
channel_file = '8channel.ced'; % File containing EEG channel 
                               % (created privously by EEGlab)

% Downsampling
newSamplingHz = 250; % New sample frequency in Hz

% Bandpass filter
lowCutoff = 2;    % in Hz
highCutoff = 50;  % in Hz

%% ------------------------------------------------------------------------
% Code
% -------------------------------------------------------------------------
mkdir(save_folder) % Create folder for the new datasets
mkdir(plot_folder) % Create folder for the topoplots
files = dir([data_folder, '*', file_type]);
files = files(1:3);
for file = files' % For every data file within the folder
    % Import data
    EEG = pop_importdata('dataformat','ascii','nbchan',0, ...
        'data', [data_folder, file.name], ... % Data file path
        'srate', samplingHz, ... % Sampling rate in Hz
        'pnts',0,'xmin',0, ...
        'chanlocs',[data_folder, channel_file]); % File containing EEG channels
    % Downsampling
    EEG = pop_resample(EEG, newSamplingHz);
    % Band pass filter
    EEG = pop_eegfiltnew(EEG, lowCutoff, highCutoff);
    % Perform ICA
    EEG = pop_runica(EEG, 'extended', 1, 'interupt', 'on');
    % Set name and save
    EEG.setname = [file.name(1:end-length(file_type)), '_ica'];
    EEG = pop_saveset(EEG, 'filename', [EEG.setname, '.set'], 'filepath', save_folder);
    % Plot topoplot and save it
    pop_topoplot(EEG, 0,1:length(EEG.chanlocs),EEG.setname,[2 4],0,'electrodes','on');
    saveas(figure(1), [plot_folder, EEG.setname], 'png')
    saveas(figure(1), [plot_folder, EEG.setname], 'eps')
    close(figure(1))
end