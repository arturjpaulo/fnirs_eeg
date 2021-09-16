function  [events] = block_mod (tempo)


frame= zeros(length(tempo),1);


for i=1: length (tempo)
    frame(i)= tempo{i};
end

%Achar o tempo em segundos dos eventos
sampRate = 250; %Hz
%para mostrar em data frame
% sampRate=1;
events = frame/sampRate;
% eventsTime = t(M(:,1));











