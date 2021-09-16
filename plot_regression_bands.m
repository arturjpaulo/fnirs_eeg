function  plot_regression_bands(fnirsROI,eegROI)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

j=1;
% 
% for i=1:5
%   
for i=1:length(fnirsROI)

  fnirsROI(i).description
   eegROI(j).description
   % b=M1L
  
  dataend=40;
  % dataend=50;
   b=fnirsROI(i).data(1:dataend,1);
  
  start= 1;
  
   % A0= horzcat(eegROI(j).data(start:dataend,:), eegROI(j+1).data(start:dataend,:), eegROI(j+2).data(start:dataend,:));
   A0= horzcat(eegROI(j+2).data(start:dataend,1:2));
   
  

   j=j+3; 
   
    
   

     A= [A0 ones(size(A0,1),1)];
     
    
f=figure('units','normalized','outerposition',[0 0 1 1]);
hold on , grid on 
b=fnirsROI(i).data(1:40,1);
[x,xint,r,rint,stats] =regress(b,A);

%subplot (3,2,1)
 subplot (2,2,1)

plot(b,'k-o');
 yl=ylim;
 ymax=max(yl);
 ymin=min(yl);
 
hold on , grid on
plot(A*x,'r-o');
xlim([0 size(A,1)])
xticks(0:5:40);

xticklabels({'-5','0','5','10','15','20','25','30','35'})
patch([5 35 35 5],[ymin ymin ymax ymax],'y','FaceAlpha',.3);
hold on, grid on
title('Multlinear regression in Gamma Rythm (Block Average)')
xlabel('seconds');

%subplot(3,2,2);
subplot(2,2,2);
[b sortind]= sort(b);

plot(b,'k-o');
xlim([0 size(A,1)])
xticks(0:5:40);
xticklabels({'-5','0','5','10','15','20','25','30','35'})
hold on, grid on


plot(A(sortind,:)*x, 'r-o')
xlim([0 size(A,1)])
xticks(0:5:40);
xticklabels({'-5','0','5','10','15','20','25','30','35'})
title('Sorted by Oxy-Hb value')

l1=legend('Oxy-Hb in M1R', 'regression');
set(l1,'FontSize',12)

R2=sprintf('%.6f',stats(1));
F=sprintf('%.6f',stats(2));
pvalue=sprintf('%.6f',stats(3));
error=sprintf('%.6f',stats(4));


txt= strcat('R²= ',R2,', Fstat= ',F,', p-value= ',pvalue,', Error = ',error);

%text(220,12,txt, 'HorizontalAlignment', 'right');
dim = [0.6, 0.45 , 0.1, 0.1];
annotation('textbox', dim, 'String',txt,'FitBoxToText','on');
% rodar a cross-correlation

[c,lag]=xcorr(b,A(:,1),30,'normalized');
subplot(2,2,3)
stem(lag,c)
title('Cross-correlation in Gamma Rythm(M1L x M1L-OxyHb)') 
xlabel('Seconds');
ylabel('Normalized correlation coefiecients');


[c,lag]=xcorr(b,A(:,2),30,'normalized');
subplot(2,2,4)
 stem(lag,c)
 title('Cross-correlation in Gamma Rythm (S1L x M1L-OxyHb)') 
 xlabel('Seconds');
ylabel('Normalized correlation coefiecients');
 

 

 
% Ax= A(:,1:end-1)* mean(A(:,1));
% for u=1:size(A,2)-1
%     Axstd= std(Ax(:,u));
%     Ax(:,u)=Ax(:,u)/Axstd;
% end
% 
% 
% 
% y= regress(b,Ax);
% yr=reshape(y,4,3);
% yr_trans= cat(1,yr_trans,yr');


%subplot(2,2,[3,4]);
%subplot(3,2,[3,4]);
% 
% label=categorical({'Mu', 'Beta', 'Gamma'});
%  title('Variable contribution')
% le=legend('M1L', 'S1L', 'M1R', 'S1R');
%  set(le,'FontSize',8);
% 
% bar(label,yr);



% [c,lag]=xcorr(b,A0(:,1),40,'normalized');
% subplot(3,3,7)
%  stem(lag,c)
%  title('Cross-correlation (M1L x M1L-OxyHb)') 
% %  
%  
%  [c,lag]=xcorr(b,A0(:,2),40,'normalized');
% subplot(3,3,8)
%  stem(lag,c)
%  title('Cross-correlation (S1L x M1L-OxyHb)') 
%  
% 
aux= (fnirsROI(i).description);
filename= [aux(end-15:end-5) '.jpg'];
path=['C:\Users\artur\Documents\integracao\escrita\regression_block_average' filename];
% 
exportgraphics(f,path);



% [M1L.b,M1L.bint,M1L.r,M1L.rint,...
%     M1L.stats]=regress(fnirsROI(i).data(:,3),A);


end
end

