%{
Pre-processing resting EEG data (child: 64 net)
SEPT 2020
Akhila Nekkanti (akhilan@uoregon.edu)
%}

%{
 This script includes steps to:
1) Load EEGlab
2) *Import .RAW data
3) Read .RAW data and import channel locations
4) Run high-pass filter
5) Channel interpolation
6) Reference to average
7) Low pass filter
8) Resample to 250 Hz
9) ICA and component rejection of eye artifacts
%}

%% 1. Load EEGlab
%cd '/projects/fabblab/shared/matlab/eeglab'
eeglab

%% 2. Load .RAW Data
%change directory to location of EEG data
cd '/projects/fabblab/shared/EEG/data/Batch1'

%% 3. Read in .RAW files and channel locations at outset.

file=sub

    EEG = pop_readegi([file], [], [], 'auto' ); %#ok<NBRAK>
    EEG = eeg_checkset( EEG);

% 64 channel net locations
    EEG=pop_chanedit(EEG, 'load',{'/projects/fabblab/shared/EEG/scripts/GSN-HydroCel-64_1.0.sfp','filetype' 'sfp'});

%% 5. High-pass Filter: removes non-stationary signal drift across the recording


% highpass filter at 0.1 Hz
    EEG = pop_eegfiltnew(EEG, 0.1);

%% 6. Channel Interpolation: checks for bad channels (those that produce high freq noise)

[throwAway, badChannels] = pop_rejchan(EEG, 'elec' ,[1:64] , 'threshold' ,5, 'norm' , 'on' , 'measure' , 'kurt' ); %#ok<NBRAK>

    % spherical interpolation of bad channels
    EEG = pop_interp(EEG, badChannels, 'spherical' );


%% 7. Re-reference to average: allows more consistent comparison across studies/samples
    EEG = pop_reref( EEG, []);

%% 8. Low-pass Filter: further removes line noise across recording
    EEG = pop_eegfiltnew(EEG, [],50);

%% 9. Re-sample: 
    EEG = pop_resample(EEG, 250);

%% 10. ICA: 
   EEG = pop_runica(EEG, 'interupt' , 'on' );

%% SAVE Output in .mat format.
    name = file;
    name = [name(1:end-4), '.mat' ];
    save(name, 'EEG' , 'badChannels' );

    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
