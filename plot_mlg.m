function  yr_trans=plot_mlg(fnirsROI,eegROI)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here


j=1;
yr_trans=[1 2 3 4];
for i=1:length(fnirsROI)
  %  for i=1:5
  
   fnirsROI(i).description
   eegROI(j).description
   % b=M1L
  
  dataend=255;
  % dataend=50;
   b=fnirsROI(i).data(10:dataend,1);
  
  start= 10;
  
    A0= horzcat(eegROI(j).data(start:dataend,:), eegROI(j+1).data(start:dataend,:), eegROI(j+2).data(start:dataend,:));
   
  

   j=j+3; 
    
   

    A= [A0 ones(size(A0,1),1)];
 
f=figure('units','normalized','outerposition',[0 0 1 1]);
hold on , grid on 
b=fnirsROI(i).data(10:dataend,1);
[x,xint,r,rint,stats]=regress(b,A);
subplot (2,2,1)
% plot(b,'k-o');
hold on , grid on

R2=sprintf('%.6f',stats(1));
F=sprintf('%.6f',stats(2));
pvalue=sprintf('%.6f',stats(3));
error=sprintf('%.6f',stats(4));


txt= strcat('R²= ',R2,', Fstat= ',F,', p-value= ',pvalue,', Error = ',error);

%text(220,12,txt, 'HorizontalAlignment', 'right');
dim = [0.6, 0.45 , 0.1, 0.1];
annotation('textbox', dim, 'String',txt,'FitBoxToText','on');



% plot(A*x,'r-o');
xlim([0 size(A,1)])
title('multlinear regression')
subplot(2,2,2)
[b sortind]= sort(b);

plot(b,'k-o');
xlim([0 size(A,1)])
hold on, grid on


plot(A(sortind,:)*x, 'r-o')
xlim([0 size(A,1)])
title('Sorted by Oxy value')

l1=legend('Oxy-Hb in M1L', 'regression');
set(l1,'FontSize',8)

% quais fatores foram os mais informativos

Ax= A(:,1:end-1)* mean(A(:,1));
for u=1:size(A,2)-1
    Axstd= std(Ax(:,u));
    Ax(:,u)=Ax(:,u)/Axstd;
end



%
y= regress(b,Ax);
yr=reshape(y,4,3);



yr_trans= cat(1,yr_trans,yr');

% 
% 
% 
% subplot(2,2,[3,4])
% %label=categorical({'Mu', 'Beta', 'Gamma'});
% label=[1 2 3];
% bar(label,yr);
% 
% title('Variable contribution')
% le=legend('M1L', 'S1L', 'M1R', 'S1R');
% set(le,'FontSize',8);


% aux= (fnirsROI(i).description);
% filename= [aux(end-15:end-5) '.jpg'];
% path=['C:\Users\artur\Documents\integracao\escrita\' filename];
% 
% exportgraphics(f,path);
% 
% 



end

end

