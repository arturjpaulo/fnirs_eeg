clear all
clc
close all
%%
cd('C:\Users\artur\Documents')
demotbl=readtable('volunteerDemoFinge_final.xls');
%% adicionando o diretório
%adicionar a toolbox no diretório

%mkdir('C:\Users\artur\Documents\GitHub2');
addpath(genpath('C:\Users\artur\Documents\GitHub2'));
%adicionar a pasta scripts com funções usadas
addpath('C:\Users\artur\Documents\scripts');
%diretório dos arquivos nirs
nirs_path='C:\Users\artur\Documents\integracao\finger\nirs';
%diretorio dos arquivos eeg
eeg_path='C:\Users\artur\Documents\integracao\finger\eeg';
%markers dos dados eeg
eegmarker_path= [eeg_path filesep 'markers'];
edat_path='C:\Users\artur\Documents\integracao\finger\edat2';
edat_nirs='C:\Users\artur\Documents\integracao\finger\edat_nirs';
cd('C:\Users\artur\Documents\integracao\finger\eeg\aux_data')
load ('dado_06')
load ('dado_24')
load ('dado_27')

%
%nirs_raw=nirs.io.loadDirectory(nirs_path,{'group', 'subject'});
eeg_raw=eeg.io.loadDirectory(eeg_path,{'group', 'subject'});
%% Nirs processing
%identify stimulus
nirs_processed=finger_identify_fnirs(nirs_raw,edat_nirs);
%Trim baseline
job=nirs.modules.TrimBaseline( );
job.preBaseline=2;
job.postBaseline=2;
nirs_processed2= job.run(nirs_processed);
%
job=nirs.modules.AddDemographics;
job.demoTable=demotbl;
job.varToMatch = 'subject';
nirs_processed2=job.run(nirs_processed2);
job=nirs.modules.FixNaNs();
% compute DPF based on Subjects's age
DPFc=DPF_calc(nirs_processed2);


%Compute TedHb 
job=nirs.modules.OpticalDensity(job);
job=nirs.modules.BeerLambertLaw(job);
HB_ted =job.run(nirs_processed2);

%Compute DPF based on subject's age    
Hb_gui= NIRxmBLL(nirs_processed2,HB_ted,DPFc);
%GLM
job=nirs.modules.GLM; %Default 'GLM via AR(P)-IRLS'
SubjStats=job.run(Hb_gui);

% Run Mixed effects model
job=nirs.modules.MixedEffects;  
job.formula='beta ~ -1 + group:cond +Age+Gender+(1|subject)'; %effect of condition for each cond controlling for subject
job.dummyCoding = 'full';
job.include_diagnostics=true;
GroupStats_nirs=job.run(SubjStats);
%Show regressors in the model
GroupStats_nirs.conditions
%
c=[eye(8);
  0 -1 1 0 0 0 0 0;
  0 0 0 -1 1 0 0 0 ;
  0 0 0 0 0 0 -1 1;];
ContrastStats_nirs = GroupStats_nirs.ttest(c);

     ContrastStats_nirs.probe=ContrastStats_nirs.probe.SetFiducialsVisibility(false);
     ContrastStats_nirs.probe.defaultdrawfcn='10-20';

    %ContrastStats_nirs.draw('tstat',[-5 5], 'q < 0.05');
    
    results_nirs = [nirs_path filesep 'results-p001_10-20'];
    ContrastStats_nirs.printAll('tstat', [-5 5], 'q < 0.01', results_nirs,'tif')


%% EEG processing

% EDF load


eeg_edf=eeg_raw;
path_edf_con=('C:\Users\artur\Documents\integracao\finger\eeg\controlsedf');
path_edf_pat=('C:\Users\artur\Documents\integracao\finger\eeg\patientsedf');

eeg_edf=load_edf_eeg(path_edf_con,eeg_edf,1);
eeg_edf=load_edf_eeg(path_edf_pat,eeg_edf,21);

eeg_edf(26,1).data=dado_24';
eeg_edf(27,1).data=dado_27';
eeg_edf(31,1).data=dado_06';

%20171024    
%20171027
%20180306

% Resample to 250Hz
job = nirs.modules.Resample;
job.Fs = 250;
eeg_edf=job.run(eeg_edf);
% identify stimulus b b
eeg_processed = finger_identify_eeg(eeg_edf, eegmarker_path,edat_path);

job=nirs.modules.TrimBaseline( );
job.preBaseline=2;
job.postBaseline=2;
eeg_processed=job.run(eeg_processed);

%high-pass filter
for i=1:length(eeg_processed)
eeg_processed(i).data = eegfilt (eeg_processed(i).data',eeg_processed(i).Fs,0.5, [ ]);
eeg_processed(i).data=eeg_processed(i).data';
end

%filtro low-pass
for i=1:length(eeg_processed)
eeg_processed(i).data = eegfilt (eeg_processed(i).data',eeg_processed(i).Fs,[ ], 50);
eeg_processed(i).data=eeg_processed(i).data';
end


%notch_filter em 60hz
j=eeg.modules.NotchFilter; 
j.notchlower=59;
j.notchhigher=61;
eeg_processed=j.run(eeg_processed);

%Compute wavelets
j=eeg.modules.WaveletTransform;
FD = j.run(eeg_processed);  
disp(nirs.createDemographicsTable(FD));

%Select somatomotor channels
FD_selected= FD_ROI(FD);

% Resample to Run GlM
j = nirs.modules.Resample;
j.Fs=7; 
FD_down = j.run(FD_selected);
% pre-whitenning
j=eeg.modules.AverageERP();
j.prewhiten=true;  
j.basis('default')=nirs.design.basis.Canonical;
FDStats=j.run (FD_down);
% Mixed effects model 
j=eeg.modules.MixedEffects;
j.formula='beta ~ -1 + freq: group : cond';
disp(FDStats)
GroupStats=j.run(FDStats);
disp( GroupStats.conditions)
% plot eeg graphs
%%
c = [eye(18);
  -1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
  0 -1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0;
  0 0 -1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0;
  0 0 0 0 0 0 -1 0 0 1 0 0 0 0 0 0 0 0;
  0 0 0 0 0 0 0 -1 0 0 1 0 0 0 0 0 0 0;
  0 0 0 0 0 0 0 0 -1 0 0 1 0 0 0 0 0 0;
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 0 0 1;
  0 0 0 0 0 0 0 0 0 0 0 0 0 -1 0 0 1 0;
  0 0 0 0 0 0 0 0 0 0 0 0 -1 0 0 1 0 0;
  ];

ContrastStats= GroupStats.ttest(c);
%%
%ContrastStats.draw('tstat', [-5 5], 'q<0.01' )
results_eeg= [eeg_path filesep 'results_edf_selected_p005f'];
ContrastStats.printAll('tstat', [-5 5], 'q<0.05', results_eeg, 'tiff');
%%
j=nirs.modules.ImageReconMFX;
j.formula='beta ~ -1 + cond:freq';

FTfwd=eeg.forward.FieldTrip;
FTfwd.mesh=nirs.registration.Colin27.mesh;
FTfwd.probe=FDStats2(1).probe;
FTfwd.prop=[1 NaN 1 1];

J=FTfwd.jacobian;
j.jacobian('default')=J;   
j.probe('default')=FDStats2.probe;
j.mesh=FTfwd.mesh(end);  

%j.basis=nirs.inverse.basis.identity(j.mesh);
j.basis = nirs.inverse.basis.gaussian(j.mesh,20);

ImageStats=j.run(FDStats2(1,2));

% to draw
ImageStats.draw('tstat',[],'p<0.05','beta>.8');
%%
cfg            = [];
cfg.dataset    = '20201203_s0002.edf';
cfg.continuous = 'yes';
cfg.channel    = 'all';
data           = ft_preprocessing(cfg);
%%
cfg=[];
cfg.method = 'wavelet';
cfg.foilim=[15 25];
cfg.toi =30;
[freq] = ft_freqanalysis(cfg,data);

 
%%
cfg = [];
cfg.xlim = [0.3 0.5];
cfg.zlim = [0 6e-14];
cfg.layout = 'CTF151.lay';
cfg.parameter = 'individual'; % the default 'avg' is not present in the data
figure; ft_topoplotER(cfg,data); colorbar
 
%% GLM fNIRS
% job=nirs.modules.Resample;
% % job.Fs=4;
% HB_glm=job.run(HB);
job=nirs.modules.GLM; %Default 'GLM via AR(P)-IRLS'
SubjStats=job.run(HB);

job=nirs.modules.MixedEffects;  
job.formula='beta ~ -1 + group:cond +(1|subject)'; %effect of condition for each cond controlling for subject
job.dummyCoding = 'full';
job.include_diagnostics=true;
GroupStats_nirs=job.run(SubjStats);
GroupStats_nirs.conditions


% job=nirs.modules.MixedEffects;
% job.formula='beta ~ -1 + group:cond +juntasM1L +juntasS1L+ juntasM1R+juntasS1R+esquerdaM1L+esquerdaS1L+esquerdaM1R+esquerdaS1R+direitaM1L+direitaS1L+direitaM1R+direitaS1R+(1|subject)';
% job.dummyCoding = 'full';
% job.include_diagnostics=true;
% GroupStats_nirs=job.run(Substats1);
% GroupStats_nirs.conditions
% c=[eye(18)];
% ContrastStats_nirs = GroupStats_nirs.ttest(c);
% % ContrastStats_nirs.draw('tstat',[-5 5], 'q < 0.01');
% 
%  results_nirs = [nirs_path filesep 'results-nirs-finger_cov_05'];
% ContrastStats_nirs.printAll('tstat', [-5 5], 'q < 0.05', results_nirs,'tif')

% 
%% plot fnis graphs
% c = [ eye(6)
%     -1 0 0 1 0 0;
%     0 -1 0 0 1 0;
%     0 0 -1 0 0 1];


job=nirs.modules.MixedEffects;  
job.formula='beta ~ -1 + group:cond +Age+Gender+(1|subject)'; %effect of condition for each cond controlling for subject
job.dummyCoding = 'full';
job.include_diagnostics=true;
GroupStats_nirs=job.run(SubjStats);
GroupStats_nirs.conditions
%%
c = [eye(6)
     -1 1 0 0 0 0  ;
     0 0 -1 1 0 0;
     0 0 0 0 -1 1 ];
 

    ContrastStats_nirs = GroupStats_nirs.ttest(c);
%      ContrastStats_nirs=  ContrastStats_nirs.probe.SetFiducialsVisibility(false);
%     ContrastStats_nirs.probe.defaultdrawfcn='3D mesh(top)';
    %ContrastStats_nirs.draw('tstat',[-5 5], 'q < 0.05');
    
    results_nirs = [nirs_path filesep 'results-nirsedf-draw10-20_p001_3d'];
    ContrastStats_nirs.printAll('tstat', [-5 5], 'q < 0.01', results_nirs,'tif')

   %% Calculate ROIS contribuition and EEG/fNIRS corralation
   
%    [R,P,RL,RU,Sub] = Run_eeg_nirs_correlation(SubjStats,FDStats);
%     ROIS_EEG= horzcat(Sub(:,5), Sub(:,9), Sub(:,13));
    
%demotbl=readtable('VolunteerDemoEEG.xlsx');
% job=nirs.modules.AddDemographics;    
% job.demoTable=demotbl;
% job.varToMatch = 'subject';
% SubStats_fnirsEEG=job.run(SubjStats);
%    
%    
% job=nirs.modules.MixedEffects;  
% job.formula='beta ~ -1 + group:cond +MuM1L+ BetaM1L+GamaM1L+MuM1R+BetaM1R+GamaM1R+(1|file)'; %effect of condition for each cond controlling for subject
% job.dummyCoding = 'full';
% job.include_diagnostics=true;
% GroupStats_nirs=job.run(SubStats_fnirsEEG);
% GroupStats_nirs.conditions
%     
% 
% 
% c=eye(8);
% ContrastStats = GroupStats_nirs.ttest(c);
% ContrastStats.printAll('tstat', [-4 4], 'q < 0.05',nirs_path,'tif')
    %% ROI fNIRS

job= nirs.modules.Resample;
job.Fs=1;
HB_down= job.run(HB_filter);

fnirsROI= ROI_calculus_nirs(HB_down);

%% ROI EEG

job=nirs.modules.Resample;
job.Fs=1;
FD_down= job.run(FD);

eegROI= ROI_calculus_eeg(FD_down);
%%


table = linear_mregresion(fnirsROI,eegROI);
close all
% plot_mlg(fnirsROI,eegROI);


%%
% jobs = nirs.modules.Run_HOMER2( );
% jobs.fcn = 'hmrBlockAvg';
% jobs.vars.trange = [-5 45]; % define the time range for averaging with respect to the task onset  
% Hb_avg = jobs.run(HB_filter);
% job= nirs.modules.Resample;
% job.Fs=1;
% 
% HB_down= job.run(Hb_avg);
% fnirsROI= ROI_calculus_nirs(HB_down);
% 
%  
%  %%
%  jobs = nirs.modules.Run_HOMER2( );
% jobs.fcn = 'hmrBlockAvg';
% jobs.vars.trange = [-5 45]; % define the time range for averaging with respect to the task onset  
% FD_avg = jobs.run(FD);
% job=nirs.modules.Resample;
% job.Fs=1;
% FD_down= job.run(FD);
% eegROI= ROI_calculus_eeg(FD_avg);
