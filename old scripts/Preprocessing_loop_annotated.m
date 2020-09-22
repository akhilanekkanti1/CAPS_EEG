%{
Pre-processing resting EEG data (child: 64 net)
July, 2020
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

*** Imported files are in Simple Binary Format (.RAW) from Netstation
Next steps:
1) manual artifact rejection
2)
3)

%}

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
%cd '/Users/acer/Desktop/EEG_Project/EEG_Data'
cd '//cas-fs1/psy-ctn/psy-ctn/FABBLab/CAPS-Assessment/CAPS_Data/Data_Processing/EEG/raw_files/wv1/Child_files/BATCH_1'

%use uigetfile to load multiple .RAW files into a cell array
[file, path, indx] = uigetfile( '*.raw' , 'Select One or More Files' , 'MultiSelect' , 'on' );

%alternate to uigetfile
%getFile(d,'/home/user/test_folder/*.raw')
 EEG=pop_chanedit(EEG, 'load',{'C:/Users/acer/Desktop/CAPS_EEG/electrode_locations/GSN-HydroCel-64_1.0.sfp','filetype' 'sfp'});

 for s = 1:size(file,2) 
%% 3. Read in .RAW files and channel locations at outset.
% See: https://github.com/sccn/eeglab/blob/develop/functions/popfunc/pop_readegi.m

    EEG = pop_readegi([path, file{s}], [], [], 'auto' );
    EEG = eeg_checkset( EEG); 
    
%channel location files are taken from fieldtrip/fieldtrip/template github
% 64 channel net locations
   
 
%% 5. High-pass Filter: removes non-stationary signal drift across the recording 
% See: https://github.com/sccn/eeglab/blob/develop/functions/popfunc/pop_eegfilt.m

% highpass filter at 0.1 Hz
    EEG = pop_eegfiltnew(EEG, 0.1); 

%% 6. Channel Interpolation: checks for bad channels (those that produce high freq noise)
% spherical interpolation reduces chances for loss of data that comes from 
% calculating the mean from surrounding channels.

% automatic detection of bad channels 
    [throwAway, badChannels] = pop_rejchan(EEG, 'elec' ,[1:64] , 'threshold' ,5, 'norm' , 'on' , 'measure' , 'kurt' );

    % spherical interpolation of bad channels 
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
    EEG = pop_resample(EEG, 250); 

%% 10. ICA: 
% runica 

    EEG = pop_runica(EEG, 'interupt' , 'on' ); 

%% SAVE Output in .mat format.    

    name = file{s}; 
    name = [name(1:end-4), '.mat' ]; 
    save(name, 'EEG' , 'badChannels' );
    
   STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[]; 

%pop_saveset( EEG, '/cas-fs1/psy-ctn/psy-ctn/FABBLab/CAPS-Assessment/CAPS_Data/Data_Processing/EEG/preprocessed/wv1/child/');
end 

com = pop_export(EEG);  
pop_expica( EEG, whichica);  
