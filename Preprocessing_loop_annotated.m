%{
Pre-processing resting EEG data (child: 64 net)
July, 2020
Akhila Nekkanti (akhilan@uoregon.edu) 
%}

%{
 This script includes steps to:
1) Load EEGlab
2) *Import .RAW data from 64 channel nets
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%change directory to location of EEG data
cd '/Users/acer/Desktop/EEG_Project/EEG_Data'

%use uigetfile to load multiple .RAW files into a cell array
[file, path, indx] = uigetfile( '*.raw' , 'Select One or More Files' , 'MultiSelect' , 'on' );

for s = 1:size(file,2) 
%% 3. Read in .RAW files and channel locations at outset.
% See: https://github.com/sccn/eeglab/blob/develop/functions/popfunc/pop_readegi.m

    EEG = pop_readegi([path, file{s}], [], [], 'auto' );
    EEG = eeg_checkset( EEG); 
    
%channel location files are taken from fieldtrip/fieldtrip/template github
% 64 channel net locations
    EEG=pop_chanedit(EEG, 'load',{'C:/Users/acer/Desktop/CAPS_EEG/electrode_locations/GSN-HydroCel-64_1.0.sfp','filetype' 'sfp'});
 
%% 5. High-pass Filter: removes non-stationary signal drift across the recording 
% See: https://github.com/sccn/eeglab/blob/develop/functions/popfunc/pop_eegfilt.m

% highpass filter at 0.1 Hz
    EEG = pop_eegfiltnew(EEG, 0.1); 

%% 6. Channel Interpolation: checks for bad channels (those that produce high freq noise)
% spherical interpolation reduces chances for loss of data that comes from 
% calculating the mean from surrounding channels.
    EEG = pop_interp(EEG, badChannels, 'spherical' ); 
    
%% 7. Re-reference to average: allows more consistent comparison across studies/samples 
% See: https://github.com/sccn/eeglab/blob/develop/functions/popfunc/pop_reref.m

    EEG = pop_reref( EEG, []); 
    
%% 8. Low-pass Filter: further removes line noise across recording
%50 Hz (v. low) due to poorer-than-average data quality with dev. samples
%Using low-pass filter after high-pass and interpolation increases chance
%of finding bad channels

    EEG = pop_eegfiltnew(EEG, [],50); 
    
%% 9. Re-sample: 
% See: https://github.com/sccn/eeglab/blob/develop/functions/popfunc/pop_resample.m  
%resampling with pop_resample ensures that the highest frequency in data is (at max) half the
%sampling frequency via an anti-aliasing filter
    EEG = pop_resample(EEG, 250) 

%% 10. ICA: 
% runica 

    EEG = pop_runica(EEG, 'interupt' , 'on' ); 

%% SAVE Output in .mat format.    
    name = file{s}; 
    name = [name(1:end-4), '.mat' ]; 
    save(name, 'EEG' , 'badChannels' );

    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[]; 
end 
