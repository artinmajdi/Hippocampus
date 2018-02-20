clear
clc
close all

addpath('NIfTI_20140122')


DirNames = dir('../data/old/');
% DirNames = dir('../data/');
DirNames = DirNames(3:end-1);

%% First Step: finding the segment in each modality

    % FlagMode.mode = 'AllOrgans_AfterSegmentation'; % 'OneOrgan'
    flag_InitialReadingMode.mode = 'OneOrgan';
    flag_InitialReadingMode.OrganIndex = 1;
    
    flag_AnalysisMode = 'OrgansSeperately'; % 'OrgansSimultaneously'; 'OrgansSeperately';

    PosThresh_OrganHistSeperately = 0.5;
    
mode= 'write';
switch mode   % 'readAndAnalysis'   'write'
    case 'write'
        for subjectNum = 1:length(DirNames)
            fprintf(' \n -----  Subject: %s  -----\n',DirNames(subjectNum).name)
            
            Initialization
            
            show = 0;
            for modalityNum = 1:length(FinalData)
                disp(['Modality: ',FinalData(modalityNum).name])
                
                [FinalSegment , FinalSegmentPosVal , ZeroMask] = funcFinalSegmentation(FinalData(modalityNum).address,flag_InitialReadingMode,show,100);
                
                FinalData(modalityNum).ZeroMask           = ZeroMask;
                FinalData(modalityNum).FinalSegment       = FinalSegment;
                FinalData(modalityNum).FinalSegmentPosVal = FinalSegmentPosVal;
            end
            
            PosteriorComparison = funcVoxelByVoxel3D(FinalData,flag_AnalysisMode);
            for modalityNum = 1:length(FinalData)
                FinalData(modalityNum).MaxPosteriorChosenVoxelAnalysis = PosteriorComparison(:,:,:,:,modalityNum);
            end
            
            save([ADDRESS,'FinalData.mat'], 'FinalData','flag_AnalysisMode','flag_InitialReadingMode')
    %% showing the Segments based on which modality is superior
%             sliceNumber = 100;
%             A = cat(3,FinalData(1).MaxPosteriorChosenVoxelAnalysis(:,:,sliceNumber),...
%                 FinalData(2).MaxPosteriorChosenVoxelAnalysis(:,:,sliceNumber), ...
%                 FinalData(3).MaxPosteriorChosenVoxelAnalysis(:,:,sliceNumber));
%             image(A)
                               
        end

    case 'readAndAnalysis'
        for subjectNum = 1%:11
            fprintf(' \n -----  Subject: %s  -----\n',DirNames(subjectNum).name)
            
            ADDRESS =  [DirNames(subjectNum).folder,'/',DirNames(subjectNum).name,'/nii/'];
            load([ADDRESS,'FinalData.mat']);
            
            
            %% analysis
            AnaylseMethod = 'Histogram';
            switch AnaylseMethod
                case 'VoxelByVoxel'                    
                    finalAnalysis_VoxelByVoxel(FinalData,flag_AnalysisMode)
                                        
                case 'Histogram'
                    finalAnalysis_Histogram(FinalData,flag_AnalysisMode,DirNames,subjectNum,PosThresh_OrganHistSeperately)
            end
        end
        
        if strcmp(AnaylseMethod ,'VoxelByVoxel')            
            for subjectNum = 1%:11
                name{subjectNum} = DirNames(subjectNum).name;
            end
            T1_per  = AverageSegmented(:,1);
            T2_per  = AverageSegmented(:,2);
            wmn_per = AverageSegmented(:,3);
            wholeHippocampusVoxelAnalysis = table(T1_per,T2_per,wmn_per,'RowNames',name)
        end
end