function AveNumPosMaxChosen = finalAnalysis_VoxelByVoxel(FinalData,flag_AnalysisMode,PosTh,show)

    NumSubfields = max(FinalData(1).FinalSegment(:));

    switch flag_AnalysisMode
        case 'SubfieldsSeperately'

            A = zeros(NumSubfields,3);
            for modalityNum = 1:3
                Pmod = FinalData(modalityNum).MaxPosteriorChosenVoxelAnalysis ;

                for SubfieldInd = 1:NumSubfields
                    PmodSubsection = Pmod(:,:,:,SubfieldInd);
%                     chosenPosts = PmodSubsection(PmodSubsection > PosTh);                    
%                     A(SubfieldInd,modalityNum) = sum(chosenPosts(:));
                    A(SubfieldInd,modalityNum) = length(find(PmodSubsection > PosTh));
                    
                    name{SubfieldInd} = FinalData(1).address(SubfieldInd).name(16:end-11);
                end
            end
            AveNumPosMaxChosen = A./repmat(sum(A,2),[1,3]);
            
            if show.tableShow
                T1_per  = AveNumPosMaxChosen(:,1);
                T2_per  = AveNumPosMaxChosen(:,2);
                wmn_per = AveNumPosMaxChosen(:,3);
                VoxelAnalysisPerSubsegment = table(T1_per,T2_per,wmn_per,'RowNames',name)
            end
        case 'SubfieldsSimultaneously'

            A = zeros(1,3);            
            for modalityNum = 1:3       
                Pmod = FinalData(modalityNum).MaxPosteriorChosenVoxelAnalysis ;
                PmodSubsection = Pmod(:,:,:,1);
                chosenPosts = PmodSubsection(PmodSubsection > PosTh);
                A(1,modalityNum) = sum(chosenPosts(:));
            end
            AveNumPosMaxChosen = A/sum(A);
            
            if show.tableShow                
                T1_per  = AveNumPosMaxChosen(:,1);
                T2_per  = AveNumPosMaxChosen(:,2);
                wmn_per = AveNumPosMaxChosen(:,3);
                VoxelAnalysisPerSubsegment = table(T1_per,T2_per,wmn_per)
            end
            
    end
    
    
end