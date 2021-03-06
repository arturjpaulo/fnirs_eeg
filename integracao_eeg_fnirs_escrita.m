clear all
clc
close all

%% Adicionar tabela demografica NIRS
cd('C:\Users\artur\Documents')
demotbl=readtable('volunteerDemoWriting_final.xls');

%% adicionando o diretório
%adicionar a toolbox no diretório

%mkdir('C:\Users\artur\Documents\GitHub2');
addpath(genpath('C:\Users\artur\Documents\GitHub2'));
%adicionar a pasta scripts com funções usadas
addpath('C:\Users\artur\Documents\scripts');
%diretório dos arquivos nirs
nirs_path='C:\Users\artur\Documents\integracao\escrita\nirs';
%diretorio dos arquivos eeg
eeg_path='C:\Users\artur\Documents\integracao\escrita\eeg';
%markers dos dados eeg
eegmarker_path= [eeg_path filesep 'markers'];



%carregar os dados
nirs_raw=nirs.io.loadDirectory(nirs_path,{'group', 'subject'});
eeg_raw=eeg.io.loadDirectory(eeg_path,{'group', 'subject'});

% NIRS processing
%identify stimulus
nirs_raw2=writing_identify_fnirs(nirs_raw);
%trim baseline
job=nirs.modules.TrimBaseline( );
job.preBaseline=25;
job.postBaseline=25;
nirs_processed= job.run(nirs_raw2);

%add demographics
job=nirs.modules.AddDemographics;
job.demoTable=demotbl;
job.varToMatch = 'subject';
nirs_processed2=job.run(nirs_processed);
job=nirs.modules.FixNaNs();

% compute DPF based on Subjects's age
DPFc=DPF_calc(nirs_processed2);


%Compute TedHb 
job=nirs.modules.OpticalDensity(job);
job=nirs.modules.BeerLambertLaw(job);
HB_ted =job.run(nirs_processed2);
%

Hb_gui= NIRxmBLL(nirs_processed2,HB_ted,DPFc);
% GLM
job=nirs.modules.GLM; %Default 'GLM via AR(P)-IRLS'
SubjStats=job.run(Hb_gui);

%% Run Mixed effects model
job=nirs.modules.MixedEffects;  
job.formula='beta ~ -1 + group:cond + Age + Gender+(1|subject)'; %effect of condition for each cond controlling for subject
job.dummyCoding = 'full';
job.include_diagnostics=true;
GroupStats_nirs=job.run(SubjStats);
%Show regressors in the model
GroupStats_nirs.conditions
%%
c = [eye(4)
    0 0 -1 1;];
 %Visualyzation propreties    
    ContrastStats_nirs = GroupStats_nirs.ttest(c);
   ContrastStats_nirs.probe= ContrastStats_nirs.probe.SetFiducialsVisibility(false);
   ContrastStats_nirs.probe.defaultdrawfcn='2D';
%print and save results
    %  ContrastStats_nirs.draw('tstat', [-5 5], 'q < 0.05')

     results_nirs = [nirs_path filesep 'resuts_2D'];
    ContrastStats_nirs.printAll('tstat', [-5 5], 'q < 0.05', results_nirs,'tif')

%% EEG processing

%EDF load

eeg_edf=eeg_raw;
path_edf_con=('C:\Users\artur\Documents\integracao\escrita\eeg\controlsedf');
path_edf_pat=('C:\Users\artur\Documents\integracao\escrita\eeg\patientsedf');

eeg_edf=load_edf_eeg(path_edf_con,eeg_edf,1);
eeg_edf=load_edf_eeg(path_edf_pat,eeg_edf,22);
%
%Resample to 250Hz
job = nirs.modules.Resample;
job.Fs = 250;
eeg_raw=job.run(eeg_edf);

% Idenfy Stimulus
eeg_raw_2= writing_identify_eeg(eeg_raw, eegmarker_path);
%Trim Basaline
job=nirs.modules.TrimBaseline( );
job.preBaseline=25;
job.postBaseline=25;
eeg_processed=job.run(eeg_raw_2);
%

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


% Compute Wavelets
j=eeg.modules.WaveletTransform;
FD = j.run(eeg_processed);
disp(nirs.createDemographicsTable(FD));

%  Select Somatomotor Channels
FD_selected= FD_ROI(FD);
% Resample to Run GLM
j = nirs.modules.Resample;
j.Fs=7; 
FD_down = j.run(FD_selected);
j=eeg.modules.AverageERP();
j.prewhiten=true; 
j.basis('default')=nirs.design.basis.Canonical;
FDStats=j.run (FD_down);

% Run mixed effects model
j=eeg.modules.MixedEffects;
j.formula='beta ~ -1 + freq: group : cond';
disp(FDStats)
GroupStats=j.run(FDStats);
disp( GroupStats.conditions)

% Design contrastes
c= [eye(6);
       -1 0 0 1 0 0;
       0 -1 0 0 1 0 ;
       0 0 -1 0 0 1;];
ContrastStats= GroupStats.ttest(c);

% save and print results
results_eeg= [eeg_path filesep 'resultsedf_p005_seleted_filtered_cp1_cp2'];
ContrastStats.printAll('tstat',[-5 5], 'q<0.05', results_eeg, 'tif');


%% Block Avg

addpath('C:\Users\artur\Documents\homer2');
% j=nirs.modules.Run_HOMER2( );
% j.fcn='hmrBandpassFilt';
% j.vars.lpf = 0.2;
% j.vars.hpf = 0.01;
% Hb_filter=j.run(Hb_gui);

jobs= nirs.modules.Run_HOMER2( );
jobs.fcn='hmrBlockAvg';
jobs.vars.trange=[-5 45];
Hb_avg=jobs.run(Hb_gui);
Hb_avg.gui
eeg_avg=jobs.run(FD_selected);

%% img recons
j = nirs.modules.ImageReconMFX();


%j.probe('default')=noise.probe;

j.mesh=mesh;  
j.formula = 'beta ~ -1 + group:cond + Age + Gender+(1|subject)';  

% This is the basis set used in the image reconstruction.  The options are:
%  nirs.inverse.basis.identity - an identity matrix
%  nirs.inverse.basis.gaussian - a Gaussian smoothing kernel
%  nirs.inverse.basis.freesurfer_wavelet - The spherical wavelet model

%j.basis=nirs.inverse.basis.identity(mesh);
j.basis = nirs.inverse.basis.gaussian(mesh,20);

j.mask =(mesh.nodes(:,3)>5); % only points below 5mm

prior.hbo=zeros(size(J.hbo,2),1);
prior.hbr=zeros(size(J.hbo,2),1);


% The fields and dimensions in in the prior need to match that of the Jacobian
j.prior=Dictionary();
j.prior('A')=prior;
j.prior('B')=prior;
% Prior is a dictionary and uses the names of the stimulus conditions in the model
% You can also use "default" to use the same prior for all conditions.


ImageStats=j.run(SubjStats);

ImageStats.draw('tstat',[],'p<0.05','beta>.8','superior');
