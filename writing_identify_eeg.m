function raw_2= writing_identify_eeg (raw,marker_directory)

for i=1:length(raw)
aux = raw(i).description;
aux2=[aux((end-19):(end -4)),'vmrk.csv'];

file_directory= [marker_directory aux2];



[T]= csvimport(file_directory);
T(1)=[];
[events]= block_mod(T);

COND_rest= events(2);
temp_escrita= events (3:2:9);
%temp_resting= events(2);

                stim =nirs.design.StimulusEvents;
                stim.name = 'escrita';
                stim.onset = temp_escrita;
                stim.dur = 30*ones(length(temp_escrita),1);%time fix at 30s
                stim.amp = 1*ones(length(temp_escrita),1);
                raw(i).stimulus('escrita')=stim;
                
                
                
                stim=nirs.design.StimulusEvents;
                stim.name='resting';
                stim.onset= COND_rest;
                stim.dur=[60];
                stim.amp = 1*ones(length(COND_rest),1);
                raw(i).stimulus('resting')=stim;
                

            j=nirs.modules.KeepStims;
            
            j.listOfStims={'escrita'};
            
           % j.listOfStims={'resting'};
            
            raw_2(i) = j.run(raw(i));
end

    
raw_2=raw_2';
end


