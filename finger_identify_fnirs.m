function raw2= finger_identify_fnirs(nirs_raw,edat_path)

   for i=1:length (nirs_raw)

      aux= nirs_raw(i).description; % 
      edata= [aux(end-14:end-1)];
      evtFile=[  aux(1:end-1) '\NIRS-' edata '.evt'];
    aux
%     else
%         
%     evtFile=[ aux(end-77:end-4) 'evt']; % carrega arquivo evt do participante    
%     edata= [aux(end-18:end-5)]; 
    
    %end
    edat_file= [edat_path '\' edata 'xls.csv'];
    
    lista= import_edat( edat_file, 2, 14);

  if (isequal({'Running[SubTrial]'},lista(1)))
    
   lista=lista(2:end);
  end
    
    [Events]=eventsBlocks_mod (evtFile);
    eventsTime= Events(:,2);% pega o tempo em segundos de cada trigger
 



         %definindo o começo de cada estimulo
        direita_temp= zeros(4,1);
        esquerda_temp= zeros(4,1);
       juntas_temp=zeros(4,1);
        
        
       %  stim =nirs.design.StimulusEvents;
         k=1;
            
            for j=1:length (lista)
                 
                   
               if      (isequal({'DireitaList'},lista(j,1)))
%                     stim =nirs.design.StimulusEvents;      
                     temp = eventsTime((j*2)-1); 
                     fprintf ( 'direita %f\n',temp)
                     direita_temp(k)= temp;
                     k=k+1;
%                      stim.onset= nonzeros(direita_temp);
%                      stim.name= 'Direita';
%                      stim.dur= 30*ones(4,1);
%                      stim.amp= ones(4,1);
%                      raw(i).stimulus('Direita') = stim;
%                      
%                     
                    
                 
            elseif  (isequal({'EsquerdaList'},lista (j,1 )))
             
%                      stim =nirs.design.StimulusEvents;
                     temp= eventsTime((j*2)-1);
                     fprintf (' esquerda %f\n',temp)
                     esquerda_temp(k)= temp;
                     k=k+1;
%                      stim.onset=nonzeros (esquerda_temp);
%                      stim.name= 'Esquerda';
%                      stim.dur= 30*ones(4,1);
%                      stim.amp= ones(4,1);
%                        
%                    raw(i).stimulus('Esquerda') = stim;
%                      
                     
            
            elseif(isequal({'JuntasList'},lista (j,1 )))
         
%                      stim =nirs.design.StimulusEvents;
                     temp= eventsTime((j*2)-1);
                     fprintf ( 'juntas %f\n',temp)
                     juntas_temp (k)= temp;
                     k=k+1;
%                      stim.onset= nonzeros(juntas_temp);
%                      stim.name= 'Juntas';
%                      stim.dur= 30*ones(4,1);
%                      stim.amp= ones(4,1);
%                       
%                     raw(i).stimulus('Juntas') = stim; 
%                   
                    
                    end  
            
            end
  
stim =nirs.design.StimulusEvents;
stim.onset= nonzeros(direita_temp);
stim.name= 'Direita';
stim.dur= 30*ones(4,1);
stim.amp= ones(4,1);
nirs_raw(i).stimulus('Direita') = stim;
                
stim =nirs.design.StimulusEvents;
stim.onset= nonzeros(esquerda_temp);
stim.name= 'Esquerda';
stim.dur= 30*ones(4,1);
stim.amp= ones(4,1);
nirs_raw(i).stimulus('Esquerda') = stim;
                     
stim =nirs.design.StimulusEvents;
stim.onset= nonzeros(juntas_temp);
stim.name= 'Juntas';
stim.dur= 30*ones(4,1);
stim.amp= ones(4,1);
nirs_raw(i).stimulus('Juntas') = stim;
                     
                     

            o=nirs.modules.KeepStims;
            o.listOfStims={'Direita','Esquerda', 'Juntas'};
            raw2(i) = o.run(nirs_raw(i));
  end
 end