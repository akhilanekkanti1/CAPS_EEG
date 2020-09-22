%% Script from Rene Huster on 8/7/2020 - does not include channel locations
cd '/Users/acer/Desktop/EEG_Project/eeglab_current/eeglab2019_1'
eeglab

cd '//cas-fs1/psy-ctn/psy-ctn/FABBLab/CAPS-Assessment/CAPS_Data/Data_Processing/EEG/raw_files/wv1/Child_files/BATCH_1'
[file, path, indx] = uigetfile( '*.raw' , 'Select One or More Files' , 'MultiSelect' , 'on' );

for s = 1:size(file,2) 
    EEG = pop_readegi([path, file{s}], [], [], 'auto' );
    EEG = eeg_checkset( EEG); 
    EEG = pop_chanedit(EEG, 'load',{'C:/Users/acer/Desktop/CAPS_EEG/electrode_locations/GSN-HydroCel-64_1.0.sfp','filetype' 'sfp'}); 

    EEG = pop_eegfiltnew(EEG, 0.1); 

    [throwAway, badChannels] = pop_rejchan(EEG, 'elec' ,1:64 , 'threshold' ,5, 'norm' , 'on' , 'measure' , 'kurt' );
    
    EEG = pop_interp(EEG, badChannels, 'spherical' ); 

    EEG = pop_reref( EEG, []); 

    EEG = pop_eegfiltnew(EEG, [],50); 

    EEG = pop_resample(EEG, 250); 

    EEG = pop_runica(EEG, 'interupt' , 'on' ); 

    name = file{s}; 
    name = [name(1:end-4), '.mat' ]; 
    save(name, 'EEG' , 'badChannels' );

    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[]; 
end 


