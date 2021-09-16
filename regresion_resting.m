function [table table2]= regresion_resting(fnirsROI,eegROI)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

% fNIRSROI
%M1L Oxy= 1
%M1L deOxy= 2
%M1R Oxy= 3
%M1R deOxy= 4


% j=1 Mu
% j=2 beta
% j=3 gama
j=3;

%table=zeros(44,17);
table=zeros(42,5);
table2=zeros(42,5);
 for i=1:length(fnirsROI)
%for i=1:5
%   
   fnirsROI(i).description
   eegROI(j).description
   %
  b=fnirsROI(i).data(8:60,1);
  
  start= 8;

  A0= eegROI(j).data(start:60,1:2);
     
  A7=eegROI(j).data(start-7:60-7,1:2);
      
      
      
 
    
    %A= horzcat(A0,A1,A2,A3,A4,A5,A6,A7);
    
    A= horzcat(A0,A7);
% A=A0;
    A= [A ones(size(A,1),1)];
 
 
% f=figure('units','normalized','outerposition',[0 0 1 1]);
hold on , grid on 

[x,xint,r,rint,stats] =regress(b,A);

%subplot (3,2,1)
%  subplot (2,2,1)
%  plot(b,'k-o');
% 
% 
% hold on , grid on
% plot(A*x,'r-o');
% plot(b,'k-o');
% xlim([0 size(A,1)])
% title('Multlinear regression in Gamma Rythm')
% 
% subplot(2,2,2);
% [b sortind]= sort(b);
% 
% plot(b,'k-o');
% xlim([0 size(A,1)])
% hold on, grid on
% 
% 
%  plot(A(sortind,:)*x, 'r-o')
% xlim([0 size(A,1)])
% title('Sorted by Oxy-Hb value')
% 
% l1=legend('Oxy-Hb in M1R', 'regression');
% set(l1,'FontSize',12)
% 
% R2=sprintf('%.6f',stats(1));
% F=sprintf('%.6f',stats(2));
% pvalue=sprintf('%.6f',stats(3));
% error=sprintf('%.6f',stats(4));
% 
% 
% txt= strcat('R²= ',R2,', Fstat= ',F,', p-value= ',pvalue,', Error = ',error);
% 
% 
%  dim = [0.6, 0.45 , 0.1, 0.1];
% annotation('textbox', dim, 'String',txt,'FitBoxToText','on');
% % quais fatores foram os mais informativos
% 
% % Ax= A(:,1:end-1)* mean(A(:,1));
 Ax= A-ones(size(A,1),1)* mean(A,1);
for u=1:size(A,2)-1
    Axstd= std(Ax(:,u));
    Ax(:,u)=Ax(:,u)/Axstd;
end

Ax=Ax(:,1:end-1);



y= regress(b,Ax);
% yr=reshape(y,8,4);
 %yr=reshape(y,8,2);
  yr=reshape(y,2,2);

%yr=y;
% 
% subplot(2,2,[3,4]);
% 
% %label=categorical({'t-0', 't-1', 't-2', 't-3', 't-4','t-5','t-6', 't-7'});
% label=categorical({'t-0', 't-7'});
%  bar(label,yr);



% title('Variables` contribution')
% %le=legend('M1L', 'S1L', 'M1R', 'S1R');
% le=legend('M1L', 'S1L');
% 
% set(le,'FontSize',8);

table(i,:)= [y' stats(1)] ;
table2(i,:)=[x'] ;




% [c,lag]=xcorr(b,A0(:,1),30,'normalized');
% subplot(3,3,7)
%  stem(lag,c)
%  title('Cross-correlation (M1L x M1L-OxyHb)') 
%  
%  
%  [c,lag]=xcorr(b,A0(:,2),30,'normalized');
% subplot(3,3,8)
%  stem(lag,c)
%  title('Cross-correlation (S1L x M1L-OxyHb)') 
%  
% 
% aux= (fnirsROI(i).description);
% filename= [aux(end-15:end-5) '.jpg'];
% path=['C:\Users\artur\Documents\integracao\escrita\left_hemi2' filename];
% % 
% exportgraphics(f,path);

  j=j+3; 
clear b A
% [M1L.b,M1L.bint,M1L.r,M1L.rint,...
%     M1L.stats]=regress(fnirsROI(i).data(:,3),A);


end
end

