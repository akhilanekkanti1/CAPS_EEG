%{
Pre-processing resting EEG data (child: 64 net)
July, 2020
Akhila Nekkanti (akhilan@uoregon.edu) 
%}

%{
 This script includes steps to:
1) Load EEGlab
2) *Import .RAW data
3) Load .RAW data into appropriate format
4) Re-reference to average reference
5) Low pass filter at 50 Hz (since we are not interested in activity higher than 30 Hz)
6) Additional notch filter at 60Hz
7) Downsample to 250 Hz to speed up ICA
8) ICA and component rejection of eye artifact components -- not yet
completed

*** Imported files are in Simple Binary Format (.RAW) from Netstation
%}

%%%% Still to do: rename files so each is labelled
%%%% add channel locations -- necessary for these files when using pop?
%%%% remove bad channels - 
%%%% compile all into a STUDY

%%%% manual artifact rejection

%% 1. Load EEGlab
% First, set your MATLAB path to the location of the EEGlab folder.
cd '/Users/acer/Desktop/EEG_Project/eeglab_current/eeglab2019_1'

% Call EEGlab
eeglab


%% 2. Load .RAW Data 
% See wiki: https://sccn.ucsd.edu/wiki/A01:_Importing_Continuous_and_Epoched_Data#Importing_Netstation.2FEGI_files
% See: https://www.mathworks.com/help/matlab/ref/uigetfile.html
% See: https://www.mathworks.com/matlabcentral/answers/347632-open-multiple-text-files-using-uigetfile-and-store-it-into-a-3d-array

%change directory to location of EEG data
cd '/Users/acer/Desktop/EEG_Project/EEG_Data'

%use uigetfile to load multiple .RAW files into a cell array
[file, path, indx] = uigetfile('*.raw','Select One or More Files', 'MultiSelect', 'on')


%Once it is in a cell array, you can access the data with {}
%v = cellfun(char2mat,file)
%v = [file{:}]

%FileNames = cell2mat(file)
%size(FileNames)


%% 3. Read in .RAW files into appropriate format
% See: https://github.com/sccn/eeglab/blob/develop/functions/popfunc/pop_readegi.m


EEG = pop_readegi([path, file{1}], [], [], 'auto') %how to loop through cell array for each file?
EEG = eeg_checkset( EEG )
%
% Inputs:
%   filename       - EGI file name
%   datachunks     - desired frame numbers (see readegi() help)
%                    option available from the command line only
%   forceversion   - [integer] force reading a specfic file version
%   fileloc        - [string] channel location file name. Default is
%                    'auto' (autodetection)

%% 4. re-reference to average reference
% See: https://github.com/sccn/eeglab/blob/develop/functions/popfunc/pop_reref.m

% pop_reref() - Convert an EEG dataset to average reference or to a
%               new common reference channel (or channels). Calls reref().

%EEGOUT = pop_reref( EEG ); % pop up interactive window
EEG = pop_reref( EEG, []); %sets ref to average ref

% Inputs:
%   EEG         - input dataset
%   ref         - reference: []             = convert to average reference
%                            [int vector]   = new reference electrode number(s)
%                            'Cz'           = string
%                            { 'P09' 'P10 } = cell array of strings

EEG = eeg_checkset( EEG )

%% 5. filter
% See:https://github.com/sccn/eeglab/blob/develop/functions/popfunc/pop_eegfilt.m

%%EEG = pop_eegfilt( EEG, 0.1, 50, [1]) %change this to two separate steps later - first highpass then lowpass

EEG = pop_eegfiltnew(EEG, 'locutoff',0.1,'hicutoff',50,'revfilt',1,'plotfreqz',1)

EEG = eeg_checkset( EEG ) 


% Inputs:
%   EEG       - input dataset
%   locutoff  - lower edge of the frequency pass band (Hz)  {0 -> lowpass}
%   hicutoff  - higher edge of the frequency pass band (Hz) {0 -> highpass}
%   filtorder - length of the filter in points {default 3*fix(srate/locutoff)}
%   revfilt   - [0|1] Reverse filter polarity (from bandpass to notch filter). 
%                     Default is 0 (bandpass).
%   usefft    - [0|1] 1 uses FFT filtering instead of FIR. Default is 0.
%   plotfreqz - [0|1] plot frequency response of filter. Default is 0.
%   firtype   - ['firls'|'fir1'] filter design method, default is 'firls'
%               from the command line
%   causal    - [0|1] 1 uses causal filtering. Default is 0.

%% 6. Downsample
% See: https://github.com/sccn/eeglab/blob/develop/functions/popfunc/pop_resample.m
% Usage:
%   >> [OUTEEG] = pop_resample( INEEG ); % pop up interactive window
%   >> [OUTEEG] = pop_resample( INEEG, freq);
%   >> [OUTEEG] = pop_resample( INEEG, freq, fc, df);
%
% Inputs:
%   INEEG      - input dataset
%   freq       - frequency to resample (Hz)  

EEG = pop_resample(EEG, 250)
%% figures (?)

figure; topoplot([],EEG.chanlocs, 'style', 'blank', 'electrodes', 'labelpoint')
figure; pop_spectopo(EEG, 1, [0 238304.6875], 'EEG' , 'percent', 15, 'freq', [6 10 22], 'freqrange',[2   25],'electrodes','off')

%% ICA
