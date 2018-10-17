% Compute spectral powers of all the EEG dataset files contained within a
% folder. Save the powers to another folder as a text file.

%% ------------------------------------------------------------------------
% Options you may want to change
% -------------------------------------------------------------------------
% Files
data_folder = 'Data/pruneX/'; % Folder with the EEG data sets file
file_type = '.set'; % File extension of the data set files
save_folder = 'Data/powersX/'; % Text files containing spectral
                                      % powers will be saved here

% Frequencies for each spectral wave (in Hz)
deltaFreq = [2,   4]; % Originally [1, 4]
thetaFreq = [4,   8];
alphaFreq = [8,  13];
betaFreq  = [13, 30];
gammaFreq = [30, 50]; % Originally [30, 80]

%% ------------------------------------------------------------------------
% Code
% -------------------------------------------------------------------------
mkdir(save_folder) % Create folder for output text files
files = dir([data_folder, '*', file_type]);
for file = files' % For every data file within the folder
    EEG = pop_loadset('filename', file.name, 'filepath', file.folder);
    [spectra,freqs] = spectopo(EEG.data, 0, EEG.srate);

    % Index for the relevant frequency bands
    deltaIdx = find((freqs>deltaFreq(1)) & (freqs<deltaFreq(2)));
    thetaIdx = find((freqs>thetaFreq(1)) & (freqs<thetaFreq(2)));
    alphaIdx = find((freqs>alphaFreq(1)) & (freqs<alphaFreq(2)));
    betaIdx  = find((freqs> betaFreq(1)) & (freqs< betaFreq(2)));
    gammaIdx = find((freqs>gammaFreq(1)) & (freqs<gammaFreq(2)));


    % Compute absolute power
    deltaPower = 10^(mean(spectra(deltaIdx))/10);
    thetaPower = 10^(mean(spectra(thetaIdx))/10);
    alphaPower = 10^(mean(spectra(alphaIdx))/10);
    betaPower  = 10^(mean(spectra(betaIdx))/10);
    gammaPower = 10^(mean(spectra(gammaIdx))/10);

    % Compute relative powers
    summPower = deltaPower + thetaPower + alphaPower + betaPower + gammaPower;
    deltaRelPwr = deltaPower / summPower;
    thetaRelPwr = thetaPower / summPower;
    alphaRelPwr = alphaPower / summPower;
    betaRelPwr  = betaPower  / summPower;
    gammaRelPwr = gammaPower / summPower;

    % Save data to files
    outdatamat = [deltaPower, thetaPower, alphaPower, betaPower, gammaPower;
        deltaRelPwr, thetaRelPwr, alphaRelPwr, betaRelPwr, gammaRelPwr];
    outname = [file.name(1:end-length(file_type)), '.txt'];
    dlmwrite([save_folder, outname], outdatamat)
end
close(figure(1)) % Close output figure