% Reads datasets for which ICA has been previously applied, opening
% an EEGlab window to allow the user to reject individual components. Store
% the new EEGlab dateset into another folder.

%% ------------------------------------------------------------------------
% Options you may want to change
% -------------------------------------------------------------------------
% Files
data_folder = 'Data/icaX/'; % Folder with the EEG data sets file
file_type = '.set'; % File extension of the data set files
save_folder = 'Data/pruneX/'; % EEGlab datasets will be saved here

%% ------------------------------------------------------------------------
% Code
% -------------------------------------------------------------------------
mkdir(save_folder) % Create folder for the new datasets
files = dir([data_folder, '*', file_type]);
for file = files' % For every data set within the folder
    EEG = pop_loadset('filename', file.name, 'filepath', file.folder);
    EEG = pop_selectcomps(EEG, 1:size(EEG.icaweights, 1));
    disp('Program paused, press a key...'); pause;
    EEG = pop_subcomp(EEG);

    % Set name and save
    EEG.setname = [file.name(1:end-length(file_type)), '_prune'];
    EEG = pop_saveset(EEG, 'filename', [EEG.setname, '.set'], 'filepath', save_folder);
end