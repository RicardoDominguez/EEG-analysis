# Process and analyse EEG signals using EEGlab

Scripts to automate the preprocessing and analysis of EEG signals using [EEGlab](https://sccn.ucsd.edu/eeglab/index.php).

- [Functionality](#functionality)
- [Step by step use case example](#step-by-step-use-case-example)
- [Tips for rejecting ICA decompositions](#tips-for-rejecting-ica-decompositions)

These scripts were developed by [Ricardo Dominguez Olmedo](https://github.com/RicardoDominguez) during a placement at the Physiological Signals and Systems Laboratory, Department of Automatic Control and Systems Engineering, The University of Sheffield.

# Functionality

Main functionality included:
 * Preprocessing multiple data files by removing data at the start/end of the experiment, downsampling and bandpass filtering. Refer to [*convertRawFile2RawData.m*](convertRawFile2RawData.m) and [*preprocessingICA.m*](preprocessingICA.m).
 * Applying independent component analysis simultaneously to several data files, allowing the bulk of the computation to be performed at once. Thereafter the signal subcomponents of each data file can be examined and rejected if believed to be spurious. Refer to [*preprocessingICA.m*](preprocessingICA.m) and [*ICArejectChannels.m*](ICArejectChannels.m).
 * Computing automatically the spectral powers of multiple EEG data files. Refer to [*computeSpectralPowers.m*](computeSpectralPowers.m).

Additional functionality included (used to measure cognitive workload):
* Computing average blinking frequency using the [Blinker](https://github.com/VisLab/EEG-Blinks) toolbox. Refer to [*processBlinkData.m*](processBlinkData.m).
* Analysing audio of a person counting out loud to measure word frequency and number of errors (not automated). Refer to [*audioProcessCountingUp.m*](audioProcessCountingUp.m).

# Step by step use case example

Example of using the scripts to preprocess, apply ICA and extract the spectral powers of EEG signals collected with an Enobio headset.

 1. Add the folder containing the ``EEGlab`` toolbox to the MATLAB path.

 2. Create a ``\data`` folder at the base of the MATLAB path.

 2. Put the ``.easy`` files collected from the Enobio headset into a new folder (ie ``Data/rawFilesX``).

 3. Run [convertRawFile2RawData.m](convertRawFile2RawData.m) to create ``Data/rawDataX``.
    Ensure that the folder ``Data`` and its subfolders are added to the path.
    The new folder contains .txt files with only the relevant EEG data as columns.

 4. Run [preprocessingICA.m](preprocessingICA.m) to preprocess the data and apply independent component analysis.
    Ensure that the folder ``toolboxes/EEGlab`` and its subfolders are added to the path.
    Ensure you have created a file with the EEG channel locations (using the EEGlab GUI Edit/Channel Locations) and said file is located in ``Data/rawDataX``.
    The folder created ``/Data/icaX`` will contains EEGlab ``.set`` files.

 5. Run [ICArejectChannels.m](ICArejectChannels.m) to reject the individual components extracted using ICA. Individual windows will appear in the screen with information about the components found using ICA. The pruned data will be stored at ``/Data/pruneX``.

 6. Run [computeSpectralPowers.m](computeSpectralPowers.m) to compute the spectral powers of the clean signals. The values for each dataset are stored at ``/Data/powersX`` as ``.txt`` files.

# Tips for rejecting ICA decompositions

Only cognitively related signals should not be rejected.

Rules of thumb to determine if a component is:
 * a) Cognitively related
   - Dipole-like scalp maps
   - Spectral peaks at typical EEG frequencies (5 to 20 Hz)
   - Regular ERP-image plots (meaning that the component does not account for activity occurring in only a few trials).

 * b) Muscle artifact
   - Spatially localized
   - Show high power at high frequencies (20-50 Hz and above)

 * c) Eye artifact
   - Smoothly decreasing EEG spectrum
   - Strong far-frontal projection
   - Possible to see individual eye movements in the component erpimage.m

 * d) Some other type of artifact
   - A single channel goes 'off'
   - Line-noise artifacts
   - Noise in a certain frequency, specially in specific trials

To make an informed choice look at:
 * The scalp map
 * The component time course
 * The component activity power spectrum
 * The erpimage.m

For further information refer to the Swartz Center for Computational Neuroscience [wiki.]( https://sccn.ucsd.edu/wiki/Chapter_09:_Decomposing_Data_Using_ICA)