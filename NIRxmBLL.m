function [hb] = NIRxmBLL(raw, hbted, DPFc)

%Number of subjects
subjs = length(raw);

hb = hbted;

for s=1:subjs
    
    dat = raw(s).data;
    
    s1=size(dat,1);
    s2=size(dat,2);
    dat=dat+eps;
    
    %Baseline based on entire time series
    bl_loweWL =    mean(dat(:,1     :  s2/2));%lower Wavelength
    bl_highWL =    mean(dat(:,s2/2+1:  end));%higher Wavelength
    
    lp_loweWL = dat(:,1:s2/2);
    lp_highWL = dat(:,s2/2+1:end);
    
    %Initialize variables
    Att_highWL = zeros(s1,s2/2);
    Att_loweWL = zeros(s1,s2/2);
    oxy = zeros(s1,s2/2);
    deoxy = zeros(s1,s2/2);
    
    %Optical Density Computation
    for i=1:s2/2
        Att_highWL(:,i)= real(-log( lp_highWL(:,i) / bl_highWL(1,i) ))    ;
        Att_loweWL(:,i)= real(-log( lp_loweWL(:,i) / bl_loweWL(1,i) ))    ;
        C= [Att_highWL;Att_loweWL];
    end
    
    A=C;
    
    %Absorption Coefficients
    e = [2.5264 1.7986; %850nm-oxy ; 850nm-deoxy
        1.4866 3.8437]; %760nm-oxy ; 760nm-deoxy
    
%     e = [2.43657 1.59211;
%         1.34956 3.56624];
    
    %Differential Pathlength Factor
    if nargin < 3
        DPF = [6.38 7.25]; %Essenpreis et al 1993 - 850nm and 760nm, respectively
    else
        if size(DPFc,1) == subjs
            DPF = [DPFc(s,2) DPFc(s,1)]; %retrieve DPF for subject s and invert order
        else
            DPF = DPFc;
        end
    end
    
    %Inter-optode distance (mm)
    Loptoddistance  = 30;
    
    %modified Beer-Lambert Law
    e=e/10;
    e2=   e.* [DPF' DPF']  .*  Loptoddistance;
    
    B = A;
    clear A
    
    %Compute oxy and deoxy
    for i=1:s1
        A(1,:) = B(i,:); A(2,:) = B(s1+i,:);
         c= ( inv(e2)*A  )' ;
           
        oxy(i,:)       =c(:,1)'; %in mmol/l
        deoxy(i,:)       =c(:,2)'; %in mmol/l
    end
    
     for i=1:s2/2

        hb(s).data(:,1+2*(i-1)) = oxy(:,i);
        hb(s).data(:,2*i) = deoxy(:,i);
    end
    
end