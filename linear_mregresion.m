function [table2]= linear_mregresion(fnirsROI,eegROI)
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
%table=zeros(42,16);
table2=zeros(42,18);
 for i=1:length(fnirsROI)
%for i=1:5
%   
   fnirsROI(i).description
   eegROI(j).description
   %
  b=fnirsROI(i).data(10:255,1);
  
  start= 10;

  A0= eegROI(j).data(start:255,1:2);
   
    start=start-1;
    A1= eegROI(j).data(start:255-1,1:2);
    
    start=start-1;
    
    A2=eegROI(j).data(start:255-2,1:2);
    
    start=start-1;
    
    A3= eegROI(j).data(start:255-3,1:2);
    
     start=start-1;
     
      A4= eegROI(j).data(start:255-4,1:2);
    
      start=start-1;
     
      A5= eegROI(j).data(start:255-5,1:2);
      
      start=start-1;
     
      A6= eegROI(j).data(start:255-6,1:2);
      
      start=start-1;
     
      A7=eegROI(j).data(start:255-7,1:2);
      
      
      
 
    
    A= horzcat(A0,A1,A2,A3,A4,A5,A6,A7);
    
   % A= horzcat(A0,A7);
% A=A0;
    A= [A ones(size(A,1),1)];
 
 
% f=figure('units','normalized','outerposition',[0 0 1 1]);
hold on , grid on 

[x,xint,r,rint,stats] =regress(b,A);

%subplot (3,2,1)
%  subplot (2,2,1)
% plot(b,'k-o');


% hold on , grid on
% plot(A*x,'r-o');
% plot(b,'k-o');
% xlim([0 size(A,1)])
% title('Multlinear regression in Gamma Rythm')
% 
% subplot(2,2,2);
% [b sortind]= sort(b);
% 
% 
% xlim([0 size(A,1)])
% hold on, grid on
% 
% plot(b,'k-o');
% plot(A(sortind,:)*x, 'r-o')
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
% dim = [0.6, 0.45 , 0.1, 0.1];
% annotation('textbox', dim, 'String',txt,'FitBoxToText','on');
% quais fatores foram os mais informativos

% Ax= A(:,1:end-1)* mean(A(:,1));
 Ax= A-ones(size(A,1),1)* mean(A,1);
for u=1:size(A,2)-1
    Axstd= std(Ax(:,u));
    Ax(:,u)=Ax(:,u)/Axstd;
end

Ax=Ax(:,1:end-1);
% % x= categorical({'M1L (t0)',	 'S1L (t0)',	 'S1R (t0)',	'S1R (t0)',...
% %     'M1L (t-1)',	 'S1L (t-1)',	 'S1R (t-1)',	'S1R (t-1)', ...
% %     'M1L (t-2)',	 'S1L (t-2)',	 'S1R (t-2)',	'S1R (t-2)',...
% %     'M1L (t-3)',	 'S1L (t-3)',	 'S1R (t-3)',	'S1R (t-3)',...
% %     'M1L (t-4)',	 'S1L (t-4)',	 'S1R (t-4)',	'S1R (t-4)',...
% %     'M1L (t-5)',	 'S1L (t-5)',	 'S1R (t-5)',	'S1R (t-5)',...
% %     'M1L (t-6)',	 'S1L (t-6)',	 'S1R (t-6)',	'S1R (t-6)',...
% %     'M1L (t-7)',	 'S1L (t-7)',	 'S1R (t-7)',	'S1R (t-7)'});
% %   

%


y= regress(b,Ax);
% yr=reshape(y,8,4);
 %yr=reshape(y,8,2);
 % yr=reshape(y,2,2);

%yr=y;

% subplot(2,2,[3,4]);
% 
% %label=categorical({'t-0', 't-1', 't-2', 't-3', 't-4','t-5','t-6', 't-7'});
% label=categorical({'t-0', 't-7'});
%  bar(label,yr);



% title('Variables` contribution')
%le=legend('M1L', 'S1L', 'M1R', 'S1R');
% le=legend('M1L', 'S1L');

% set(le,'FontSize',8);

%table(i,:)= [y' stats(1)] ;
table2(i,:)= [x' stats(1)] ;



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

% aux= (fnirsROI(i).description);
% filename= [aux(end-15:end-5) '.jpg'];
% path=['C:\Users\artur\Documents\integracao\escrita\eeg\left_hemiedf' filename];
% % 
% exportgraphics(f,path);

  j=j+3; 
clear b A
% [M1L.b,M1L.bint,M1L.r,M1L.rint,...
%     M1L.stats]=regress(fnirsROI(i).data(:,3),A);


end
end

