% Convert raw files from the Enobio headset to raw files containing data in
% ASCII format to be easily read by EEGlab

%% ------------------------------------------------------------------------
% Options you may want to change
% -------------------------------------------------------------------------
raw_folder = 'Data/rawFiles02-03-18/'; % Folder of the raw files
data_folder = 'Data/rawData02-03-18/'; % Folder for new the data files
file_type = '.easy'; % File extension of the raw files
new_file_extension = '.txt'; % File extension for the new data files
relevant_channels = 1:8; % Only relevant channels are channels 1 to 8

%% ------------------------------------------------------------------------
% Code
% -------------------------------------------------------------------------
disp 'Writing files...'
extension_length = length(file_type);
mkdir(data_folder) % Create folder for the new data files
files = dir([raw_folder, '*', file_type]);
for file = files' % For every file within the folder
    % Load whole file
    data = load(file.name);
    % Consider only relevant channels
    relevant_data = data(:, relevant_channels);
    % From mV to uV
    relevant_data = relevant_data ./ (1e3);
    % Write to file
    fileName = [file.name(1:end-extension_length), new_file_extension];
    dlmwrite([data_folder, fileName], relevant_data)
end
disp 'Done writing files...'