

% %      Analysis Methods:
% %                       VoxelByVoxel
% %                       Histogram
% AnaylseMethod = 'VoxelByVoxel';


%      FlagMode.mode:
%                    AllSubfields_AfterSegmentation
%                    OneSubfield  SubfieldIndex: subfield index
flag_InitialReadingMode.mode = 'AllSubfields_AfterSegmentation';
flag_InitialReadingMode.SubfieldIndex = 1;

flag_AnalysisMode = 'SubfieldsSeperately'; % 'SubfieldsSimultaneously'; 'SubfieldsSeperately';
PosThresh = 0.2;

% Directory = [mainDir,'/Output/',orientation,'/',stateMode,'/'];
% load([Directory,'output.mat'], 'output')
for subjectNum = 1:length(DirNames)
    
    fprintf(' \n -----  Subject: %s  -----\n',DirNames(subjectNum).name)
    
    Initialization
    
    
    for modalityNum = 1:length(FinalData)
        disp(['Modality: ',FinalData(modalityNum).name])
                
        if strcmp(stateMode,'BeforeRegistration') && subjectNum == 11 && modalityNum == 3
            flag = 1;
        else
            flag = 0;
        end
        
        [FinalSegment , FinalSegmentPosVal , ZeroMask] = funcFinalSegmentation(FinalData(modalityNum).address,flag_InitialReadingMode,show,flag,100);
        
        FinalData(modalityNum).ZeroMask           = ZeroMask;
        FinalData(modalityNum).FinalSegment       = FinalSegment;
        FinalData(modalityNum).FinalSegmentPosVal = FinalSegmentPosVal;
    end
    
    switch stateMode
        case 'AfterRegistration'
            
            PosteriorComparison = funcVoxelByVoxel3D(FinalData,flag_AnalysisMode);
            for modalityNum = 1:length(FinalData)
                FinalData(modalityNum).MaxPosteriorChosenVoxelAnalysis = PosteriorComparison(:,:,:,:,modalityNum);
            end
    end

    %             save([ADDRESS,'FinalData.mat'], 'FinalData','flag_AnalysisMode','flag_InitialReadingMode')
    
    %% showing the Segments based on which modality is superior
    % sliceNumber = 100;
    % A = cat(3,FinalData(1).MaxPosteriorChosenVoxelAnalysis(:,:,sliceNumber),...
    %     FinalData(2).MaxPosteriorChosenVoxelAnalysis(:,:,sliceNumber), ...
    %     FinalData(3).MaxPosteriorChosenVoxelAnalysis(:,:,sliceNumber));
    % image(A)
    
    %         end
    %%  reading section
    %     case 'readAndAnalysis'
    %
    %         for subjectNum = 1%:11
    %             fprintf(' \n -----  Subject: %s  -----\n',DirNames(subjectNum).name)
    %
    %             ADDRESS =  [DirNames(subjectNum).folder,'/',DirNames(subjectNum).name,'/'];
    %             load([ADDRESS,'FinalData.mat']);
    
    switch stateMode
        case 'AfterRegistration'
            A = [1,2];
        case 'BeforeRegistration'
            A = 2;
    end
    for AnaylseMethod = A
        switch AnaylseMethod
            case {1,'VoxelByVoxel'}
                disp('** -----  VoxelByVoxel Analysis:  -----  **')
                output(subjectNum).AveNumPosMaxChosen = finalAnalysis_VoxelByVoxel(FinalData,flag_AnalysisMode,PosThresh,show);
                
                %                         Pmod = cat(5,FinalData.MaxPosteriorChosenVoxelAnalysis) ;
                %                         Pmod = permute(Pmod,[1,2,5,3,4]);  % [y,x,modalities,slices,subsection]
                %                         image(Pmod(:,:,:,100,1))
                
            case {2,'Histogram'}
                disp('** -----  Histogram Analysis:  -----  **')
                subOutput = finalAnalysis_Histogram(FinalData,flag_AnalysisMode,DirNames,subjectNum,PosThresh,show);
                
                nm = fields(subOutput);
                for sf = 1:length(nm)
                    output(subjectNum).(nm{sf}) = subOutput.(nm{sf});
                end                
        end        
    end
end

Directory = [mainDir,'/Output/',orientation,'/',stateMode,'/'];
mkdir(Directory);
save([Directory,'output.mat'], 'output')

