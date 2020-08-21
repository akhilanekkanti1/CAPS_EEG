%% Script from Rene Huster on 8/7/2020 - does not include channel locations

[file, path, indx] = uigetfile( '*.raw' , 'Select One or More Files' , 'MultiSelect' , 'on' );

for s = 1:size(file,2) 
    EEG = pop_readegi([path, file{s}], [], [], 'auto' );
    EEG = eeg_checkset( EEG); 

    EEG = pop_eegfiltnew(EEG, 0.1); 

    [throwAway badChannels] = pop_rejchan(EEG, 'elec' ,[1:64] , 'threshold' ,5, 'norm' , 'on' , 'measure' , 'kurt' );
    
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


