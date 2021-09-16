function [ROI_Beta_juntas, ROI_Beta_direita, ROI_Beta_esquerda ] = get_finger_tapping_betas(FDStats_1)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


FDstats=FDStats_1;

Sub=zeros(42,16);
for i=1:length(Sub) 
    

jM1L_mu= mean( [ FDstats(i).beta(6) FDstats(i).beta(7) FDstats(i).beta(8)]);
jS1L_mu=mean( [ FDstats(i).beta(11) FDstats(i).beta(12) FDstats(i).beta(14)]);
jM1R_mu=mean( [ FDstats(i).beta(29) FDstats(i).beta(28) FDstats(i).beta(25)]);
jS1R_mu=mean( [ FDstats(i).beta(23) FDstats(i).beta(22) FDstats(i).beta(19)]);

jM1L_beta= mean( [ FDstats(i+1).beta(6) FDstats(i+1).beta(7) FDstats(i+1).beta(8)]);
jS1L_beta=mean( [ FDstats(i+1).beta(11) FDstats(i+1).beta(12) FDstats(i+1).beta(14)]);
jM1R_beta=mean( [ FDstats(i+1).beta(29) FDstats(i+1).beta(28) FDstats(i+1).beta(25)]);
jS1R_beta=mean( [ FDstats(i+1).beta(23) FDstats(i+1).beta(22) FDstats(i+1).beta(19)]);

   
jM1L_gama= mean( [ FDstats(i+2).beta(6) FDstats(i+2).beta(7) FDstats(i+2).beta(8)]);
jS1L_gama=mean( [ FDstats(i+2).beta(11) FDstats(i+2).beta(12) FDstats(i+2).beta(14)]);
jM1R_gama=mean( [ FDstats(i+2).beta(29) FDstats(i+2).beta(28) FDstats(i+2).beta(25)]);
jS1R_gama=mean( [ FDstats(i+2).beta(23) FDstats(i+2).beta(22) FDstats(i+2).beta(19)]);


ROI_Beta_juntas(i,:)= horzcat( jM1L_mu, jS1L_mu, jM1R_mu,jS1R_mu, jM1L_beta, jS1L_beta, jM1R_beta,jS1R_beta,jM1L_gama, jS1L_gama, jM1R_gama,jS1R_gama);



dM1L_mu= mean( [ FDstats(i).beta(38) FDstats(i).beta(39) FDstats(i).beta(40)]);
dS1L_mu=mean( [ FDstats(i).beta(43) FDstats(i).beta(44) FDstats(i).beta(46)]);
dM1R_mu=mean( [ FDstats(i).beta(61) FDstats(i).beta(60) FDstats(i).beta(57)]);
dS1R_mu=mean( [ FDstats(i).beta(55) FDstats(i).beta(54) FDstats(i).beta(51)]);


dM1L_beta= mean( [ FDstats(i+1).beta(38) FDstats(i+1).beta(39) FDstats(i+1).beta(40)]);
dS1L_beta=mean( [ FDstats(i+1).beta(43) FDstats(i+1).beta(44) FDstats(i+1).beta(46)]);
dM1R_beta=mean( [ FDstats(i+1).beta(61) FDstats(i+1).beta(60) FDstats(i+1).beta(57)]);
dS1R_beta=mean( [ FDstats(i+1).beta(55) FDstats(i+1).beta(54) FDstats(i+1).beta(51)]);

dM1L_gama= mean( [ FDstats(i+2).beta(70) FDstats(i+2).beta(71) FDstats(i+2).beta(72)]);
dS1L_gama=mean( [ FDstats(i+2).beta(43) FDstats(i+2).beta(44) FDstats(i+2).beta(46)]);
dM1R_gama=mean( [ FDstats(i+2).beta(61) FDstats(i+2).beta(60) FDstats(i+2).beta(57)]);
dS1R_gama=mean( [ FDstats(i+2).beta(55) FDstats(i+2).beta(54) FDstats(i+2).beta(51)]);


ROI_Beta_direita(i,:)= horzcat( dM1L_mu, dS1L_mu, dM1R_mu,dS1R_mu, dM1L_beta, dS1L_beta, dM1R_beta,dS1R_beta,dM1L_gama, dS1L_gama, dM1R_gama,dS1R_gama);

eM1L_mu= mean( [ FDstats(i).beta(38) FDstats(i).beta(39) FDstats(i).beta(40)]);
eS1L_mu=mean( [ FDstats(i).beta(75) FDstats(i).beta(76) FDstats(i).beta(78)]);
eM1R_mu=mean( [ FDstats(i).beta(93) FDstats(i).beta(92) FDstats(i).beta(89)]);
eS1R_mu=mean( [ FDstats(i).beta(87) FDstats(i).beta(86) FDstats(i).beta(83)]);


eM1L_beta= mean( [ FDstats(i+1).beta(38) FDstats(i+1).beta(39) FDstats(i+1).beta(40)]);
eS1L_beta=mean( [ FDstats(i+1).beta(75) FDstats(i+1).beta(76) FDstats(i+1).beta(78)]);
eM1R_beta=mean( [ FDstats(i+1).beta(93) FDstats(i+1).beta(92) FDstats(i+1).beta(89)]);
eS1R_beta=mean( [ FDstats(i+1).beta(87) FDstats(i+1).beta(86) FDstats(i+1).beta(83)]);


eM1L_gama= mean( [ FDstats(i+2).beta(38) FDstats(i+2).beta(39) FDstats(i+2).beta(40)]);
eS1L_gama=mean( [ FDstats(i+2).beta(75) FDstats(i+2).beta(76) FDstats(i+2).beta(78)]);
eM1R_gama=mean( [ FDstats(i+2).beta(93) FDstats(i+2).beta(92) FDstats(i+2).beta(89)]);
eS1R_gama=mean( [ FDstats(i+2).beta(87) FDstats(i+2).beta(86) FDstats(i+2).beta(83)]);

ROI_Beta_esquerda(i,:)= horzcat( eM1L_mu, eS1L_mu, eM1R_mu,eS1R_mu, eM1L_beta, eS1L_beta, eM1R_beta,eS1R_beta,eM1L_gama, eS1L_gama, eM1R_gama,eS1R_gama);





end

end

