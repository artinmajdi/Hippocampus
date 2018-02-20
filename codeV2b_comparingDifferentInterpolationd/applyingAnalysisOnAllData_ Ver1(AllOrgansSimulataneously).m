clear
clc
close all

addpath('NIfTI_20140122')


DirNames = dir('../data/old/');
% DirNames = dir('../data/');

DirNames = DirNames(3:end-1);

mode= 'write';
switch mode
    case 'write'
        for subjectNum = 1%:length(DirNames)
            fprintf(' \n -----  Subject: %s  -----\n',DirNames(subjectNum).name)
            
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
            
            show = 1;
            for modalityNum = 1:length(FinalData)
                disp(['Modality: ',FinalData(modalityNum).name])
                
                [FinalSegment , FinalSegmentPosVal ,  imAllOrgansParallel , ZeroMask] = findingFinalSegmentation(FinalData(modalityNum).address,show,100);
                
                FinalData(modalityNum).ZeroMask           = ZeroMask;
                FinalData(modalityNum).FinalSegment       = FinalSegment;
                FinalData(modalityNum).FinalSegmentPosVal = FinalSegmentPosVal;
                FinalData(modalityNum).imAllOrgansParallel= imAllOrgansParallel;
            end
            
            PosteriorComparison = funcVoxelByVoxel3D(FinalData(1).FinalSegmentPosVal , FinalData(2).FinalSegmentPosVal , FinalData(3).FinalSegmentPosVal);
            for modalityNum = 1:length(FinalData)
                FinalData(modalityNum).MaxPosteriorChosenVoxelAnalysis = PosteriorComparison(:,:,:,modalityNum);
            end
            
            save([ADDRESS,'FinalData.mat'], 'FinalData')
            
        end
        %     case 'tmp'
        %
        %         for subjectNum = 5:11
        %             fprintf(' \n -----  Subject: %s  -----\n',DirNames(subjectNum).name)
        %
        %             ADDRESS =  [DirNames(subjectNum).folder,'/',DirNames(subjectNum).name,'/nii/'];
        %             load([ADDRESS,'FinalData.mat']);
        %
        %             PosteriorComparison = funcVoxelByVoxel3D(FinalData(1).FinalSegmentPosVal , FinalData(2).FinalSegmentPosVal , FinalData(3).FinalSegmentPosVal);
        %             for modalityNum = 1:length(FinalData)
        %                 FinalData(modalityNum).MaxPosteriorChosenVoxelAnalysis = PosteriorComparison(:,:,:,modalityNum);
        %             end
        %
        %             save([ADDRESS,'FinalData.mat'], 'FinalData')
        %         end
        
    case 'readAndAnalysis'
        for subjectNum = 1%:11
            fprintf(' \n -----  Subject: %s  -----\n',DirNames(subjectNum).name)
            
            ADDRESS =  [DirNames(subjectNum).folder,'/',DirNames(subjectNum).name,'/nii/'];
            load([ADDRESS,'FinalData.mat']);
            
            
            %% analysis
            AnaylseMethod = 'Histogram';
            switch AnaylseMethod
                case 'VoxelByVoxel'
                    
                    imPosT1      = FinalData(1).FinalSegmentPosVal;
                    imT1Segement = FinalData(1).FinalSegment;
                    imPosT2      = FinalData(2).FinalSegmentPosVal;
                    imPosWMN     = FinalData(3).FinalSegmentPosVal;
                    
                    
                    %                         PosteriorComparison = funcVoxelByVoxel3D(imPosT1 , imPosT2 , imPosWMN);
                    
                    %% voxel by voxel for whole hippocampus
                    A = zeros(1,3);
                    for modalityNum = 1:3
                        Pmod = FinalData(modalityNum).MaxPosteriorChosenVoxelAnalysis;
                        A(modalityNum) = length(find(Pmod > 0.4));
                    end
                    wholeHippocampusVoxelAnalysis = A/sum(A)
                    AaverageWholeFull(subjectNum,:) = wholeHippocampusVoxelAnalysis;
                    
                    %% voxel by voxel for each subsection of hippocampus
                    A = zeros(11,3);
                    for modalityNum = 1:3
                        %                     Pmod = PosteriorComparison(:,:,:,modalityNum);
                        Pmod = FinalData(modalityNum).MaxPosteriorChosenVoxelAnalysis ;
                        chosenPosts = imT1Segement(Pmod > 0.4);
                        for subsectionInd = 1:11
                            A(subsectionInd,modalityNum) = sum(chosenPosts == subsectionInd);
                            name{subsectionInd} = FinalData(1).address(subsectionInd).name(16:end-11);
                        end
                    end
                    AverageSegmented = A./repmat(sum(A,2),[1,3]);
                    T1_per  = AverageSegmented(:,1);
                    T2_per  = AverageSegmented(:,2);
                    wmn_per = AverageSegmented(:,3);
                    VoxelAnalysisPerSubsegment = table(T1_per,T2_per,wmn_per,'RowNames',name)
                    
                    
                case 'Histogram'
                    %% histogram
                    NumBins = 30;
                    a = zeros(3,NumBins);
                    b = zeros(3,NumBins);
                    for subsectionInd = 1%:11
                        for modalityNum = 1:3
                            Pos = FinalData(modalityNum).FinalSegmentPosVal;
                            Seg = FinalData(modalityNum).FinalSegment;
                            [a(modalityNum,:),b(modalityNum,:)] = hist(reshape(Pos( Seg == subsectionInd ),1,[]),NumBins);
                        end
                        
                        name = FinalData(1).address(subsectionInd).name(16:end-11);
                        
                        string = ['subject:',DirNames(subjectNum).name , '      organ: ',name];
                        string = strrep(string,'_','\_');
                        figure , title(string,'fontsize',9)
                        ylabel('posteriori histogram')
                        hold on
                        plot(b(1,:),a(1,:),'.g'), plot(b(2,:),a(2,:),'.blue'), plot(b(3,:),a(3,:),'.r')
                        plot(b(1,:),a(1,:),'g') , plot(b(2,:),a(2,:),'blue') , plot(b(3,:),a(3,:),'r')
                        legend('T1','T2','wmn')
%                         pause
                    end
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