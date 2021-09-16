function [FD_trimmed] = FD_ROI(FD)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here



FD_trimmed=FD;

for i=1: length(FD)
    
   FD_trimmed(i).probe.electrodes=[];
   FD_trimmed(i).probe.link=[];
   FD_trimmed(i).data=[];
   
   %left S1 e M1
%    FD_trimmed(i).probe.electrodes= vertcat (FD(i).probe.electrodes(6,:),FD(i).probe.electrodes(7,:), FD(i).probe.electrodes(8,:), FD(i).probe.electrodes(11,:), FD(i).probe.electrodes(12,:), FD(i).probe.electrodes(14,:));
%    
%    FD_trimmed(i).probe.link= vertcat (FD(i).probe.link(6,:),FD(i).probe.link(7,:), FD(i).probe.link(8,:), FD(i).probe.link(11,:), FD(i).probe.link(12,:), FD(i).probe.link(14,:));
% 
%   FD_trimmed(i).data= horzcat (FD(i).data(:,6),FD(i).data(:,7), FD(i).data(:,8), FD(i).data(:,11), FD(i).data(:,12), FD(i).data(:,14));


%  FD_trimmed(i).probe.electrodes= vertcat (FD(i).probe.electrodes(6,:),FD(i).probe.electrodes(28,:), FD(i).probe.electrodes(8,:), FD(i).probe.electrodes(11,:), FD(i).probe.electrodes(22,:), FD(i).probe.electrodes(24,:), FD(i).probe.electrodes(25,:), FD(i).probe.electrodes(9,:), FD(i).probe.electrodes(26,:), FD(i).probe.electrodes(12,:), FD(i).probe.electrodes(23,:));
%    
%   FD_trimmed(i).probe.link= vertcat (FD(i).probe.link(6,:),FD(i).probe.link(28,:), FD(i).probe.link(8,:), FD(i).probe.link(11,:), FD(i).probe.link(22,:), FD(i).probe.link(24,:),FD(i).probe.link(25,:), FD(i).probe.link(9,:), FD(i).probe.link(26,:), FD(i).probe.link(12,:), FD(i).probe.link(23,:));
% 
%   FD_trimmed(i).data= horzcat (FD(i).data(:,6),FD(i).data(:,28), FD(i).data(:,8), FD(i).data(:,11), FD(i).data(:,22), FD(i).data(:,24), FD(i).data(:,25), FD(i).data(:,9), FD(i).data(:,26), FD(i).data(:,12), FD(i).data(:,23));

 FD_trimmed(i).probe.electrodes= vertcat (FD(i).probe.electrodes(6,:),FD(i).probe.electrodes(7,:),FD(i).probe.electrodes(29,:),FD(i).probe.electrodes(28,:), FD(i).probe.electrodes(8,:), FD(i).probe.electrodes(11,:), FD(i).probe.electrodes(22,:), FD(i).probe.electrodes(24,:), FD(i).probe.electrodes(25,:), FD(i).probe.electrodes(9,:), FD(i).probe.electrodes(26,:), FD(i).probe.electrodes(12,:), FD(i).probe.electrodes(23,:));
   
  FD_trimmed(i).probe.link= vertcat (FD(i).probe.link(6,:),FD(i).probe.link(7,:),FD(i).probe.link(29,:),FD(i).probe.link(28,:), FD(i).probe.link(8,:), FD(i).probe.link(11,:), FD(i).probe.link(22,:), FD(i).probe.link(24,:),FD(i).probe.link(25,:), FD(i).probe.link(9,:), FD(i).probe.link(26,:), FD(i).probe.link(12,:), FD(i).probe.link(23,:));

  FD_trimmed(i).data= horzcat (FD(i).data(:,6),FD(i).data(:,7),FD(i).data(:,29),FD(i).data(:,28), FD(i).data(:,8), FD(i).data(:,11), FD(i).data(:,22), FD(i).data(:,24), FD(i).data(:,25), FD(i).data(:,9), FD(i).data(:,26), FD(i).data(:,12), FD(i).data(:,23));

end

