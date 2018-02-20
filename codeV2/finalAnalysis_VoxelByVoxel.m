function finalAnalysis_VoxelByVoxel(FinalData)

    imT1Segement = FinalData(1).FinalSegment;

    NumOrgans = max(FinalData(1).FinalSegment(:));
    
    switch flag_AnalysisMode
        case 'OrgansSeperately'
            
            for modalityNum = 1:3
                Pos = FinalData(modalityNum).FinalSegmentPosVal;
                Seg = FinalData(modalityNum).FinalSegment;
                
                for OrganInd = 1:NumOrgans
                    OrganIm = OrganExtractor(Pos,Seg,OrganInd);
                    A = zeros(1,3);

                        A(modalityNum) = length(find(OrganIm > 0.4));
                    end
                    wholeHippocampusVoxelAnalysis = A/sum(A)
    AaverageWholeFull(subjectNum,:) = wholeHippocampusVoxelAnalysis;

    %% voxel by voxel for each subsection of hippocampus
    A = zeros(11,3);
    for modalityNum = 1:3
        %                     Pmod = PosteriorComparison(:,:,:,modalityNum);
        Pmod = FinalData(modalityNum).MaxPosteriorChosenVoxelAnalysis ;
        chosenPosts = imT1Segement(Pmod > 0.4);
        for OrganInd = 1:11
            A(OrganInd,modalityNum) = sum(chosenPosts == OrganInd);
            name{OrganInd} = FinalData(1).address(OrganInd).name(16:end-11);
        end
    end
    AverageSegmented = A./repmat(sum(A,2),[1,3]);
    T1_per  = AverageSegmented(:,1);
    T2_per  = AverageSegmented(:,2);
    wmn_per = AverageSegmented(:,3);
    VoxelAnalysisPerSubsegment = table(T1_per,T2_per,wmn_per,'RowNames',name)

end