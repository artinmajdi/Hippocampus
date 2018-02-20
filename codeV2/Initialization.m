
    ADDRESS =  [DirNames(subjectNum).folder,'/',DirNames(subjectNum).name,'/nii/'];

    subDirT1 = dir([ADDRESS,'*left_*T1_v10.nii']);
    subDirT1T2 = dir([ADDRESS,'*left_*cube_resam_v10.nii']);
    subDirT1wmn = dir([ADDRESS,'*left_*wmn_resam_v10.nii']);

    FinalData(1).address = subDirT1;
    FinalData(2).address = subDirT1T2;
    FinalData(3).address = subDirT1wmn;

    FinalData(1).name = 'T1';
    FinalData(2).name = 'T1T2';
    FinalData(3).name = 'T1wmn';

    FinalData(1).Subject = DirNames(subjectNum).name;
    FinalData(2).Subject = DirNames(subjectNum).name;
    FinalData(3).Subject = DirNames(subjectNum).name;
