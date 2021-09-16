function raw_2= finger_identify_eeg (raw,marker_directory,edat_path)

for i=1:length(raw)
aux = raw(i).description;
aux2=[aux((end-19):(end -4)),'vmrk.csv'];

file_directory= [marker_directory aux2];

edat_file=[ edat_path, aux2(1:end-9) 'xls.csv'];


[T]= csvimport(file_directory);
T(1)=[];
T(1)=[];
[events]= block_mod(T);

 aux
lista= import_edat(edat_file, 2,14);
% incluir cabeças com problemas na importação dos trigger
if isequal('C:\Users\artur\Documents\integracao\finger\eeg\Controls\20170801_s0002.vhdr', raw(i).description)
lista= {'JuntasList';
'DireitaList';
'EsquerdaList';
'JuntasList';
'EsquerdaList';
'DireitaList';
'EsquerdaList';
'JuntasList';
'DireitaList';
'EsquerdaList';
'JuntasList';
'DireitaList';};


% 
 elseif isequal ( 'C:\Users\artur\Documents\integracao\finger\eeg\Controls\20180814_s0002.vhdr', raw(i).description)
lista= {'EsquerdaList';
'DireitaList';
'JuntasList';
'DireitaList';
'EsquerdaList';
'JuntasList';
'DireitaList';
'JuntasList';
'EsquerdaList';
'DireitaList';
'EsquerdaList';
'JuntasList';};
    
%     
% 
% 
elseif isequal('C:\Users\artur\Documents\integracao\finger\eeg\Controls\20181106_s0002.vhdr', raw(i).description)

lista={
'EsquerdaList';
'JuntasList';
'DireitaList';
'JuntasList';
'EsquerdaList';
'DireitaList';
'EsquerdaList';
'JuntasList';
'DireitaList';
'JuntasList';
'EsquerdaList';
'DireitaList';};


 
elseif isequal('C:\Users\artur\Documents\integracao\finger\eeg\Patients\20181113_s0002.vhdr', raw(i).description)

lista= {'Running[SubTrial]';
'EsquerdaList';
'JuntasList';
'DireitaList';
'JuntasList';
'EsquerdaList';
'DireitaList';
'EsquerdaList';
'JuntasList';
'DireitaList';
'JuntasList';
'EsquerdaList';
'DireitaList';};


elseif isequal ('C:\Users\artur\Documents\integracao\finger\eeg\Patients\20200910_s0002.vhdr', raw(i).description)
    
lista={'JuntasList';
'EsquerdaList';
'DireitaList';
'JuntasList';
'DireitaList';
'EsquerdaList';
'DireitaList';
'JuntasList';
'EsquerdaList';
'JuntasList';
'EsquerdaList';
'DireitaList';};
 end
% 


if (isequal({'Running[SubTrial]'},lista(1)))

   lista=lista(2:end);
    
end


        direita_temp= zeros(4,1);
        esquerda_temp= zeros(4,1);
        juntas_temp= zeros(4,1);
                
         stim =nirs.design.StimulusEvents;
         k=1;
            
            for j=1:length (lista)
                 
           
            if      (isequal({'DireitaList'},lista(j,1)))
                    stim =nirs.design.StimulusEvents;      
                     temp = events((j*2)-1); 
                     fprintf ( 'direita %f\n',temp)
                     direita_temp(k)= temp;
                     k=k+1;
                     stim.onset= nonzeros(direita_temp);
                     stim.name= 'Direita';
                     stim.dur= 30*ones(4,1);
                     stim.amp= ones(4,1);
                     raw(i).stimulus('Direita') = stim;
                     
                    
                    
                 
            elseif  (isequal({'EsquerdaList'},lista (j,1 )))
             
                     stim =nirs.design.StimulusEvents;
                     temp= events((j*2)-1);
                     fprintf (' esquerda %f\n',temp)
                     esquerda_temp(k)= temp;
                     k=k+1;
                     stim.onset=nonzeros (esquerda_temp);
                     stim.name= 'Esquerda';
                     stim.dur= 30*ones(4,1);
                     stim.amp= ones(4,1);
                       
                   raw(i).stimulus('Esquerda') = stim;
                     
                     
            
            elseif(isequal({'JuntasList'},lista (j,1 )))
         
                     stim =nirs.design.StimulusEvents;
                     temp= events((j*2)-1);
                     fprintf ( 'juntas %f\n',temp)
                     juntas_temp (k)= temp;
                     k=k+1;
                     stim.onset= nonzeros(juntas_temp);
                     stim.name= 'Juntas';
                     stim.dur= 30*ones(4,1);
                     stim.amp= ones(4,1);
                      
                    raw(i).stimulus('Juntas') = stim; 
            
                    
                    
                    
            
                                     
                end
  
   


            o=nirs.modules.KeepStims;
%             
               o.listOfStims={'Direita','Esquerda', 'Juntas'};
            raw_2(i) = o.run(raw(i));
            end
  raw_2=raw_2';
 end