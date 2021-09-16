function [HB_ROI] = ROI_calculus_nirs(HB_down)

HB_ROI=HB_down;

for i=1: length(HB_down)
    %M1L Oxy
    %ch7 Oxy = line 13 source 3 det 6    
    %ch6 Oxy =line 11 source 3 det 3    
    %ch16 oxy =line 31 source 6 det 3   
    
    %M1L deoxy
    %ch7 deoxy =line 14 source 3 det 6    
    %ch6 deoxy =line 12 source 3 det 3    
    %ch16 deoxy =line 32 source 6 det 3
    
    %M1R Oxy
    %ch15 Oxy =line 29 source 5 det 8    
    %ch14 Oxy =line 27 source 5 det 5    
    %ch22 Oxy =line 43 source 8 det 5 
    
    %M1L oxy
    %ch15 Oxy =line 30 source 5 det 8    
    %ch14 Oxy =line 28 source 5 det 5    
    %ch22 Oxy =line 44 source 8 det 5 
   
M1L_Oxy=  mean ([HB_down(i).data(:,13) HB_down(i).data(:,11) HB_down(i).data(:,31)],2);
M1L_Deoxy= mean ([HB_down(i).data(:,14) HB_down(i).data(:,12) HB_down(i).data(:,13)],2);
M1R_Oxy=  mean ([HB_down(i).data(:,29) HB_down(i).data(:,27) HB_down(i).data(:,43)],2);
M1R_Deoxy= mean ([HB_down(i).data(:,30) HB_down(i).data(:,28) HB_down(i).data(:,44)],2);


HB_ROI(i).data=[];


HB_ROI(i).data= horzcat(M1L_Oxy, M1L_Deoxy,M1R_Oxy, M1R_Deoxy);


%for j=1:4, HB_ROI(i).data(j,:)=detrend(HB_ROI(i).data(j,:)); end


end

end
 
