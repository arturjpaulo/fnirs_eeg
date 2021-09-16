function raw_id= writing_identify_fnirs (raw_fnirs)

for i=1:length(raw_fnirs)
aux = raw_fnirs(i).description;
aux2=aux((end-14):(end-1));

evtFile = [ aux((1):(end)) 'NIRS-' aux2 '.evt']; 
 [Events]=eventsBlocks_mod (evtFile);
eventsTime= Events(:,2);

COND= eventsTime (2:2:8);
COND_rest= eventsTime(1);

if (isequal(aux2,'2020-10-27_001'))
    COND= eventsTime(3:2:9);
    COND_rest=eventsTime(2);
    
end
  

                stim =nirs.design.StimulusEvents;
                stim.name = 'escrita';
                stim.onset = COND;
                stim.dur = 30*ones(length(COND),1);%time fix at 30s
                stim.amp = 1*ones(length(COND),1);
                raw_fnirs(i).stimulus('escrita')=stim;
                
                stim=nirs.design.StimulusEvents;
                stim.name='resting';
                stim.onset= COND_rest;
                stim.dur=[60];
                stim.amp = 1*ones(length(COND),1);
                raw_fnirs(i).stimulus('resting')=stim;
% %                 if (isequal(aux2,'2020-03-17_001')|| isequal(aux2,'2020-02-05_001')|| isequal(aux2,'2020-03-03_001')|| isequal(aux2,'2020-02-04_001'))
% %                     stim.dur=[30];
% %                 end
%                 stim.amp=[1];
%                 raw_fnirs(i).stimulus('resting')=stim;
%                           
%                
            j=nirs.modules.KeepStims;
          %  j.listOfStims={'Escrita','resting'};
            j.listOfStims={'escrita'};
            raw_id(i) = j.run(raw_fnirs(i));
             

end
  raw_id = raw_id';  

end
        
    
    

