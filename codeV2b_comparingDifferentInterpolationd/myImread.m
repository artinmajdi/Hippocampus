function [imT1 , imT2 , imWMN] = myImread(subsection)
    Directory = '../data/old/KevinMRIImages/nii/';
    nameT1  = ['posterior_left_',subsection,'_T1_v10.nii'];              
    nameT2  = ['posterior_left_',subsection,'_T1_cube_resam_v10.nii'];
    nameWMN = ['posterior_left_',subsection,'_T1_wmn_resam_v10.nii'];

    addpath('NIfTI_20140122')

    dataT1 = load_nii([Directory,nameT1]);
    dataT2 = load_nii([Directory,nameT2]);
    dataWMN = load_nii([Directory,nameWMN]);

    % view_nii(dataT1)
    imT1  = dataT1.img;
    imT2  = dataT2.img;
    imWMN = dataWMN.img;
end