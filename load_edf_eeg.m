function eeg_edf = load_edf_eeg(path,eeg_edf,j)




a=dir(path);


for i=3: length(a)
    
sub= [a(i).folder '\' a(i).name]

aux = eeg.io.loadEDF(sub);
j
eeg_edf(j).description
eeg_edf(j).time=aux.time;
eeg_edf(j).data= aux.data;

j=j+1;

end


