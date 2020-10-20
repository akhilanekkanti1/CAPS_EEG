cd '/Users/acer/Desktop/EEG_Project/eeglab_current/eeglab2019_1'
eeglab

cd 'C:/Users/acer/Dropbox (University of Oregon)/EEG_Data/'

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename','CAPS414-C1_20171027_103607.mat','filepath','C:\\Users\\acer\\Dropbox (University of Oregon)\\EEG_Data\\preprocessed\\');
 
          
% creates eventlist, erplab  (probably not necessary here)
%    erplab
%    [EEG EVENTLIST] = pop_creabasiceventlist(EEG, 'Eventlist', ['CAPS410_elist.txt'], 'BoundaryNumeric', {-99}, 'BoundaryString', {'boundary'}, 'Warning', 'off');
    
%
    zoo = ['CAPS414-C1_zoo_stim'];
    %EEG = pop_epoch( EEG, {  'Fbck'  'SESS'  'TRSP'  'fedT'  'fedp'  'fixZ'  'fixp'  'fixt'  'resp'  'stiT'  'stim'  }, [-1  2], 'newname', zoo, 'epochinfo', 'yes');
    
%stimulus only    
    EEG = pop_epoch( EEG, { 'stim'  }, [-1  2], 'newname', zoo, 'epochinfo', 'yes');

    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    EEG = eeg_checkset( EEG );

[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'savenew', zoo ,'gui','off'); 

%figures

EEG = pop_loadset('filename','CAPS414-C1_zoo_stim.set','filepath','C:\\Users\\acer\\Dropbox (University of Oregon)\\EEG_Data\\');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = eeg_checkset( EEG );
figure; pop_timtopo(EEG, [-1000  1996], [NaN], 'ERP data and scalp maps of CAPS414-C1_zoo_stim');
EEG = eeg_checkset( EEG );
figure; pop_plottopo(EEG, [1:64] , 'CAPS414-C1_zoo_stim', 0, 'ydir',1);