function [Contrast_both] = merge_fnirs_eeg(ContrastStats_eeg,ContrastStats_nirs)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
Contrast_both= ContrastStats_nirs;

aux=height(ContrastStats_eeg.probe.link);
aux2=  [ContrastStats_eeg.probe.link zeros(aux,1)];

Contrast_both.probe.link= [ConstrastStats_nirs aux2];


end

