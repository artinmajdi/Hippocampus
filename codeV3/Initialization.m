ADDRESS =  [DirNames(subjectNum).folder,'/',DirNames(subjectNum).name,'/'];
% ADDRESS = '/media/artin/data/documents/MRI/data/old/KevinMRIImages/nii/';
% ADDRESS = '/media/artin/data/documents/MRI/data/old/KevinMRIImages/';


subDirT1 = dir([ADDRESS,'*',orientation,'_*T1_v10.nii']);


switch stateMode
    case 'AfterRegistration'
        subDirT1T2  = dir([ADDRESS,'*',orientation,'_*cube_resam_weighted_v10.nii']);
        subDirT1wmn = dir([ADDRESS,'*',orientation,'_*wmn_resam_weighted_v10.nii']);
        
    case 'BeforeRegistration'
        
        subDirT1T2 = dir([ADDRESS,'*',orientation,'_*cube_v10.nii']);
        subDirT1wmn = dir([ADDRESS,'*',orientation,'_*wmn_v10.nii']);
        
%         if subjectNum == 11
%             subDirT1wmn = dir([ADDRESS,'*left_*wmn_v10.nii']);
%         else
%             subDirT1wmn = dir([ADDRESS,'*left_*wmn_resam_weighted_v10.nii']);             
%         end
end

FinalData(1).address = subDirT1;
FinalData(2).address = subDirT1T2;
FinalData(3).address = subDirT1wmn;

FinalData(1).name = 'T1';
FinalData(2).name = 'T1T2';
FinalData(3).name = 'T1wmn';

FinalData(1).Subject = DirNames(subjectNum).name;
FinalData(2).Subject = DirNames(subjectNum).name;
FinalData(3).Subject = DirNames(subjectNum).name;
