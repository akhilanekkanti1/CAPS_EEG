
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd '/Users/acer/Desktop/EEG_Project/eeglab_current/eeglab2019_1'
eeglab

cd 'C:/Users/acer/Dropbox (University of Oregon)/EEG_Data/'
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename','CAPS417-C1_20180322_102604.mat','filepath','C:\\Users\\acer\\Dropbox (University of Oregon)\\EEG_Data\\preprocessed\\');
 
eyeoset = ['CAPS417-C1_eyeo'];
eyecset = ['CAPS417-C1_eyec'];

EEGo = pop_epoch( EEG, {  'eyeo'  }, [0  60], 'newname', eyeoset, 'epochinfo', 'yes');

[ALLEEG EEGo CURRENTSET] = pop_newset(ALLEEG, EEGo, 1,'savenew', eyeoset ,'gui','off'); 
EEG = eeg_checkset( EEG );

EEGc = pop_epoch( EEG, {  'eyec'  }, [0  60], 'newname', eyecset, 'epochinfo', 'yes'); 
[ALLEEG EEGc CURRENTSET] = pop_newset(ALLEEG, EEGc, 1,'savenew', eyecset ,'gui','off'); 


STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;


%%%%plotting
%EEG = pop_loadset('filename','CAPS410-C1_eyeo.set','filepath','C:\\Users\\acer\\Dropbox (University of Oregon)\\EEG_Data\\');
%[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

%EEG = eeg_checkset( EEG );
%figure; pop_spectopo(EEG, 1, [0  60], 'EEG' , 'percent', 100, 'freq', [6 7 8 9 10 11 12], 'freqrange',[2 25],'electrodes','on');
%EEG = eeg_checkset( EEG );