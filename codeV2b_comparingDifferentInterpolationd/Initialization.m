subjectNum = 1;
    ADDRESS =  [DirNames(subjectNum).folder,'/',DirNames(subjectNum).name,'/'];
% ADDRESS = '/media/artin/data/documents/MRI/data/old/KevinMRIImages/nii/';
% ADDRESS = '/media/artin/data/documents/MRI/data/old/KevinMRIImages/';

    subDirT1 = dir([ADDRESS,'*left_ca1_T1_v10.nii']);
    subDirT1T2 = dir([ADDRESS,'*left_ca1_T1_cube_v10_resam*.nii']);
    subDirT1wmn = dir([ADDRESS,'*left_ca1_T1_wmn_v10_resam*.nii']);

    FinalData(1).address = subDirT1;
    FinalData(2).address = subDirT1T2;
    FinalData(3).address = subDirT1wmn;

    FinalData(1).name = 'T1';
    FinalData(2).name = 'T1T2';
    FinalData(3).name = 'T1wmn';

    FinalData(1).Subject = DirNames(subjectNum).name;
    FinalData(2).Subject = DirNames(subjectNum).name;
    FinalData(3).Subject = DirNames(subjectNum).name;
