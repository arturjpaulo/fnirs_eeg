function [R,P,RL,RU,Sub] = Run_eeg_nirs_correlation(SubjStats,FDstats)
%Utiliza os Betas de Oxy e Deoxy-Hb e a potencia de Mu, Beta e Gama para
%fazer uma matriz de correlação

Sub=zeros(42,16);
for i=1:length(SubjStats)
    
    
M1L_Oxy=  mean ([SubjStats(i).beta(13) SubjStats(i).beta(11) SubjStats(i).beta(31)]);
M1L_Deoxy= mean ([SubjStats(i).beta(14) SubjStats(i).beta(12) SubjStats(i).beta(13)]);
M1R_Oxy=  mean ([SubjStats(i).beta(29) SubjStats(i).beta(27) SubjStats(i).beta(43)]);
M1R_Deoxy= mean ([SubjStats(i).beta(30) SubjStats(i).beta(28) SubjStats(i).beta(44)]);

M1L_mu= mean( [ FDstats(i).beta(6) FDstats(i).beta(7) FDstats(i).beta(8)]);
S1L_mu=mean( [ FDstats(i).beta(11) FDstats(i).beta(12) FDstats(i).beta(14)]);
M1R_mu=mean( [ FDstats(i).beta(29) FDstats(i).beta(28) FDstats(i).beta(25)]);
S1R_mu=mean( [ FDstats(i).beta(23) FDstats(i).beta(22) FDstats(i).beta(19)]);

M1L_beta= mean( [ FDstats(i+1).beta(6) FDstats(i+1).beta(7) FDstats(i+1).beta(8)]);
S1L_beta=mean( [ FDstats(i+1).beta(11) FDstats(i+1).beta(12) FDstats(i+1).beta(14)]);
M1R_beta=mean( [ FDstats(i+1).beta(29) FDstats(i+1).beta(28) FDstats(i+1).beta(25)]);
S1R_beta=mean( [ FDstats(i+1).beta(23) FDstats(i+1).beta(22) FDstats(i+1).beta(19)]);

   
M1L_gama= mean( [ FDstats(i+2).beta(6) FDstats(i+2).beta(7) FDstats(i+2).beta(8)]);
S1L_gama=mean( [ FDstats(i+2).beta(11) FDstats(i+2).beta(12) FDstats(i+2).beta(14)]);
M1R_gama=mean( [ FDstats(i+2).beta(29) FDstats(i+2).beta(28) FDstats(i+2).beta(25)]);
S1R_gama=mean( [ FDstats(i+2).beta(23) FDstats(i+2).beta(22) FDstats(i+2).beta(19)]);


Sub(i,:)= horzcat(M1L_Oxy,M1L_Deoxy,M1R_Oxy, M1R_Deoxy, M1L_mu, S1L_mu, M1R_mu,S1R_mu, M1L_beta, S1L_beta, M1R_beta,S1R_beta,M1L_gama, S1L_gama, M1R_gama,S1R_gama);

end

[R,P,RL,RU] = corrcoef(Sub);


end

