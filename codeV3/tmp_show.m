function tmp_show
    %     ADDRESS =  [DirNames(subjectNum).folder,'/',DirNames(subjectNum).name,'/nii/'];
    
    % before
    ADDRESS = '/media/artin/data/documents/MRI/data/old/KevinMRIImages/nii/';
    redshw(ADDRESS), title('before')
    
    figure
%     % after
    ADDRESS = '/media/artin/data/documents/MRI/data/old/KevinMRIImages/';
    redshw(ADDRESS)  , title('after') 
    
end
function redshw(ADDRESS)
    subDirT1 = dir([ADDRESS,'*left_*T1_v10.nii']);
    subDirT1T2 = dir([ADDRESS,'*left_*cube_resam_v10.nii']);
    subDirT1wmn = dir([ADDRESS,'*left_*wmn_resam_v10.nii']);

    FinalData(1).address = subDirT1;
    FinalData(2).address = subDirT1T2;
    FinalData(3).address = subDirT1wmn;

%% showing
    sfInd = 1; %:NumSubfields
    for modalityNum = 1:length(FinalData)
        subDir = FinalData(modalityNum).address;
        im{modalityNum} = load_nii([subDir(sfInd).folder,'/',subDir(sfInd).name]);
    end

    sliceN = 90;
    myShow(im{1}.img(:,:,sliceN),im{2}.img(:,:,sliceN),im{3}.img(:,:,sliceN))
    
end