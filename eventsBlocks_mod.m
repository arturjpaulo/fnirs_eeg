function[Events] = eventsBlocks_mod(evtFile)
%Recebe o arquivo de eventos - evtFile
%Recebe o vetor do tempo em s - t
%Retorna uma matriz com os eventos finais e iniciais de cada bloco
% t = TIME;
M = dlmread(evtFile);

%Achar o tempo dos eventos
sampRate = 7.81; %Hz
eventsTime = M(:,1)/sampRate;
% eventsTime = t(M(:,1));

%Transforma eventos de binário em decimal
for i = 1:length(M)

    b = M(i, 2:end);
    Events(i) =bi2de(b);
end
Events = Events';
Events = [M(:,1) eventsTime Events]; %eventos em decimal

% %find events PARE
% % ind_PARE = find(Events(:,3) == 13);
% % PARE_evt = Events(ind_PARE);% vetor de indices de eventos PARE
% % tPARE = eventsTime(ind_PARE);% vetos com os tempos dos eventos PARE
% %find events ACHE
% ind_ACHE = find(Events(:,3) == 2);
% ACHE_evt = Events(ind_ACHE);% vetor de indices de eventos ACHE
% % ACHE = eventsSegment(ACHE_evt,PARE_evt);
% %find time ACHE
% ACHE_time = eventsTime(ind_ACHE);
% % tACHE = eventsSegment(ACHE_time,tPARE);
% %find events LEMBRE
% ind_LEMBRE = find(Events(:,3) == 1);
% LEMBRE_evt = Events(ind_LEMBRE);
% LEMBRE_time = eventsTime(ind_LEMBRE);
% LEMBRE = eventsSegment(LEMBRE_evt,PARE_evt);
% tLEMBRE = eventsSegment(LEMBRE_time,tPARE);
% %find events CAMINHE
% ind_CAMINHE = find(Events(:,3) == 3);
% CAMINHE_evt = Events(ind_CAMINHE);
% CAMINHE = eventsSegment(CAMINHE_evt,PARE_evt);
% 
% % %find events PARE
% % allEvts = [ACHE,LEMBRE, CAMINHE];
% % evtsPare1 = [];
% % evtsPare2 = [];
% % for i=1:size(allEvts,1)
% %     for j =2:2:size(allEvts,2) %pegando os pares (fim dos blocos)
% %         evtsPare1= [evtsPare1;allEvts(i,j)];
% %     end
% %     for j =1:2:size(allEvts,2)%pegando inds impares (inicio dos blocos)
% %         evtsPare2= [evtsPare2;allEvts(i,j)];
% %     end
% % end
% % %acertando o tamanho dos vetores - ignorando o primeiro e ultimo pare
% % evtsPare1 = evtsPare1(1:length(evtsPare1)-1);
% % evtsPare2 = evtsPare2(2:length(evtsPare2));
% % % montando o vetor de eventos pare
% % PARE = [evtsPare1,evtsPare2];

end