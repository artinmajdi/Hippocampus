clc
orientation = 'right';
stateMode = 'BeforeRegistration';
Directory = [mainDir,'/Output/',orientation,'/',stateMode,'/'];
load([Directory,'output.mat'])

sss = cat(3,output.Median);

% WriteSectionMain
