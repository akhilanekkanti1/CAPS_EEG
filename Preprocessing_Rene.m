%% Script from Rene on 8/7/2020

[file, path, indx] = uigetfile( '*.raw' , 'Select One or More Files' , 'MultiSelect' , 'on' );

for s = 1:size(file,2) 
    EEG = pop_readegi([path, file{s}], [], [], 'auto' );
    EEG = eeg_checkset( EEG); 

    EEG = pop_eegfiltnew(EEG, 0.1); 

    %akhila adds --for 256 channel nets include:
    %EEG=pop_chanedit(EEG, 'lookup','C:\\Users\\acer\\Desktop\\CAPS_EEG\\electrode_locations\\GSN-HydroCel-64_1.0.sfp','filetype' 'sfp' 'eval','','rplurchanloc',1)

    % automatic detection of bad channels 
    [throwAway badChannels] = pop_rejchan(EEG, 'elec' ,[1:64] , 'threshold' ,5, 'norm' , 'on' , 'measure' , 'kurt' );
    % spherical interpolation of bad channels 
    EEG = pop_interp(EEG, badChannels, 'spherical' ); 

    EEG = pop_reref( EEG, []); 

    EEG = pop_eegfiltnew(EEG, [],50); 

    EEG = pop_resample(EEG, 250) 

    EEG = pop_runica(EEG, 'interupt' , 'on' ); 

    name = file{s}; 
    name = [name(1:end-4), '.mat' ]; 
    save(name, 'EEG' , 'badChannels' );

    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[]; 
end 
