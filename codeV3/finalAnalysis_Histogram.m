function output = finalAnalysis_Histogram(FinalData,flag_AnalysisMode,DirNames,subjectNum,PosThresh,show)

    %     flag_AnalysisMode = 'SubfieldsSeperately'; % 'SubfieldsSimultaneously'

    %% histogram
    NumBins = 30;

    NumSubfields = max(FinalData(1).FinalSegment(:));

    switch flag_AnalysisMode
        case 'SubfieldsSeperately'
            ah = zeros(3,NumBins,NumSubfields);   ac = ah*0;
            bh = zeros(3,NumBins,NumSubfields);   bc = bh*0;

            Mean   = zeros(NumSubfields,3);
            Median = zeros(NumSubfields,3);
            SD     = zeros(NumSubfields,3);

            for modalityNum = 1:3
                Pos = FinalData(modalityNum).FinalSegmentPosVal;
                Seg = FinalData(modalityNum).FinalSegment;

                for SubfieldInd = 1:NumSubfields
                    SubfieldIm = SubfieldExtractor(Pos,Seg,SubfieldInd);

                    K = SubfieldIm(SubfieldIm > PosThresh );
                    Mean(SubfieldInd,modalityNum) = mean(K(:));
                    Median(SubfieldInd,modalityNum) = median(K(:));
                    SD(SubfieldInd,modalityNum) = std(K(:));

                    [ah(modalityNum,:,SubfieldInd),bh(modalityNum,:,SubfieldInd)] = hist(reshape(K,1,[]),NumBins);
                    %                     [ah(modalityNum,:,SubfieldInd),bh(modalityNum,:,SubfieldInd)] = ecdf(reshape(SubfieldIm(SubfieldIm>PosThresh),1,[]));
                    bc(modalityNum,:,SubfieldInd) = fliplr(bh(modalityNum,:,SubfieldInd));
                    ac(modalityNum,:,SubfieldInd) = cumsum(fliplr(ah(modalityNum,:,SubfieldInd)))/sum(ah(modalityNum,:,SubfieldInd));

                end
            end

            for SubfieldInd = 1:NumSubfields
                name = FinalData(1).address(SubfieldInd).name(16:end-11);

                string = ['subject:',DirNames(subjectNum).name , '      Subfield: ',name];
                string = strrep(string,'_','\_');

                if show.figShow
                    close
                    figure

                    subplot(121) , title(string,'fontsize',9)
                    ylabel('posteriori histogram')
                    hold on
                    plot(bh(1,:,SubfieldInd),ah(1,:,SubfieldInd),'.g'), plot(bh(2,:,SubfieldInd),ah(2,:,SubfieldInd),'.blue'), plot(bh(3,:,SubfieldInd),ah(3,:,SubfieldInd),'.r')
                    plot(bh(1,:,SubfieldInd),ah(1,:,SubfieldInd),'g') , plot(bh(2,:,SubfieldInd),ah(2,:,SubfieldInd),'blue') , plot(bh(3,:,SubfieldInd),ah(3,:,SubfieldInd),'r')
                    legend('T1','T2','wmn')

                    subplot(122)
                    set ( gca, 'xdir', 'reverse' )
                    ylabel('cumulative fliplr of histogram')
                    hold on
                    plot(bc(1,:,SubfieldInd),ac(1,:,SubfieldInd),'.g'), plot(bc(2,:,SubfieldInd),ac(2,:,SubfieldInd),'.blue'), plot(bc(3,:,SubfieldInd),ac(3,:,SubfieldInd),'.r')
                    plot(bc(1,:,SubfieldInd),ac(1,:,SubfieldInd),'g') , plot(bc(2,:,SubfieldInd),ac(2,:,SubfieldInd),'blue') , plot(bc(3,:,SubfieldInd),ac(3,:,SubfieldInd),'r')
                    legend('T1','T2','wmn')

                    if NumSubfields > 1  && SubfieldInd < NumSubfields
                        pause
                    end

                end
            end

        case 'SubfieldsSimultaneously'

            ah = zeros(3,NumBins);  ac = ah*0;
            bh = zeros(3,NumBins);  bc = bh*0;

            Mean   = zeros(3);
            Median = zeros(3);
            SD = zeros(3);

            for modalityNum = 1:3
                Pos = FinalData(modalityNum).FinalSegmentPosVal;

                K = Pos(Pos > PosThresh );
                Mean(1,modalityNum)   = mean(K(:));
                Median(1,modalityNum) = median(K(:));
                SD(1,modalityNum)     = std(K(:));

                [ah(modalityNum,:),bh(modalityNum,:)] = hist(reshape(K,1,[]),NumBins);
                bc(modalityNum,:) = fliplr(bh(modalityNum,:));
                ac(modalityNum,:) = cumsum(fliplr(ah(modalityNum,:)))/sum(ah(modalityNum,:));

                %                 [f,x] = ecdf(reshape(Pos(Pos>PosThresh),1,[]));
                %                 [a(modalityNum,:),b(modalityNum,:)] = ecdfhist(f,x,NumBins);
            end
            if show.figShow
                close
                figure

                subplot(121)
                ylabel('posteriori histogram')
                hold on
                plot(bh(1,:),ah(1,:),'.g'), plot(bh(2,:),ah(2,:),'.blue'), plot(bh(3,:),ah(3,:),'.r')
                plot(bh(1,:),ah(1,:),'g') , plot(bh(2,:),ah(2,:),'blue') , plot(bh(3,:),ah(3,:),'r')
                legend('T1','T2','wmn')

                subplot(122)
                set ( gca, 'xdir', 'reverse' )
                ylabel('cumulative fliplr of histogram')
                hold on
                plot(bc(1,:),ac(1,:),'.g'), plot(bc(2,:),ac(2,:),'.blue'), plot(bc(3,:),ac(3,:),'.r')
                plot(bc(1,:),ac(1,:),'g') , plot(bc(2,:),ac(2,:),'blue') , plot(bc(3,:),ac(3,:),'r')
                legend('T1','T2','wmn')
            end
    end

    if show.tableShow
        
        clear name
        for IM = 1:NumSubfields
            name{IM} = FinalData(1).address(IM).name(16:end-11);
        end
        T1_mean  = Mean(:,1);
        T2_mean  = Mean(:,2);
        wmn_mean = Mean(:,3);
        MeanValues = table(T1_mean,T2_mean,wmn_mean,'RowNames',name)
        
        T1_median  = Median(:,1);
        T2_median  = Median(:,2);
        wmn_median = Median(:,3);
        MedianValues = table(T1_median,T2_median,wmn_median,'RowNames',name)
        
        T1_SD  = SD(:,1);
        T2_SD  = SD(:,2);
        wmn_SD = SD(:,3);
        SDValues = table(T1_SD,T2_SD,wmn_SD,'RowNames',name)
        
    end
    
    output.Mean   = Mean;
    output.Median = Median;
    output.SD     = SD;

end