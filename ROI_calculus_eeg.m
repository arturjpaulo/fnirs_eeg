function [FD_ROI] = ROI_calculus_eeg(FD_down)

FD_ROI=FD_down;


 
for i=1: length(FD_down)

    FD_ROI(i).data=[];
    %M1L
    %Fc5 = ch 6
    %Fc1 = ch 7
    %C3 =  ch 8
    
    %S1L
    %Cp5= ch 11
    %Cp1= ch 12
    %P3= ch 14
    
    %M1R
    %Fc2= ch 29
    %Fc6= ch 28
    %C4= ch  25
    
    %S1R oxy
    %Cp2= ch 23
    %Cp6= ch 22
    %P4= ch 19
   
    %%mu
   
M1L= mean( [ FD_down(i).data(:,6) FD_down(i).data(:,7) FD_down(i).data(:,8)],2);
S1L=mean( [ FD_down(i).data(:,11) FD_down(i).data(:,12) FD_down(i).data(:,14)],2);
M1R=mean( [ FD_down(i).data(:,29) FD_down(i).data(:,28) FD_down(i).data(:,25)],2);
S1R=mean( [ FD_down(i).data(:,23) FD_down(i).data(:,22) FD_down(i).data(:,19)],2);
   
FD_ROI(i).data= horzcat(M1L,S1L,M1R,S1R);


end

end
 