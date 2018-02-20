function finalAnalysis_Histogram(FinalData,flag_AnalysisMode,DirNames,subjectNum,PosThresh)

    %     flag_AnalysisMode = 'OrgansSeperately'; % 'OrgansSimultaneously'

    %% histogram
    NumBins = 30;
    
    NumOrgans = max(FinalData(1).FinalSegment(:));
    
    switch flag_AnalysisMode
        case 'OrgansSeperately'
            ah = zeros(3,NumBins,NumOrgans);   ac = ah*0;
            bh = zeros(3,NumBins,NumOrgans);   bc = bh*0;
            for modalityNum = 1:3
                Pos = FinalData(modalityNum).FinalSegmentPosVal;
                Seg = FinalData(modalityNum).FinalSegment;

                for OrganInd = 1:NumOrgans
                    OrganIm = OrganExtractor(Pos,Seg,OrganInd);
                    [ah(modalityNum,:,OrganInd),bh(modalityNum,:,OrganInd)] = hist(reshape(OrganIm(OrganIm>PosThresh),1,[]),NumBins);
%                     [ah(modalityNum,:,OrganInd),bh(modalityNum,:,OrganInd)] = ecdf(reshape(OrganIm(OrganIm>PosThresh),1,[]));
                    bc(modalityNum,:,OrganInd) = fliplr(bh(modalityNum,:,OrganInd));
                    ac(modalityNum,:,OrganInd) = cumsum(fliplr(ah(modalityNum,:,OrganInd)))/sum(ah(modalityNum,:,OrganInd));
                    
                end
            end
            
            for OrganInd = 1:NumOrgans
                name = FinalData(1).address(OrganInd).name(16:end-11);
                
                string = ['subject:',DirNames(subjectNum).name , '      organ: ',name];
                string = strrep(string,'_','\_');
                figure , 
                subplot(121) , title(string,'fontsize',9)
                ylabel('posteriori histogram')
                hold on
                plot(bh(1,:,OrganInd),ah(1,:,OrganInd),'.g'), plot(bh(2,:,OrganInd),ah(2,:,OrganInd),'.blue'), plot(bh(3,:,OrganInd),ah(3,:,OrganInd),'.r')
                plot(bh(1,:,OrganInd),ah(1,:,OrganInd),'g') , plot(bh(2,:,OrganInd),ah(2,:,OrganInd),'blue') , plot(bh(3,:,OrganInd),ah(3,:,OrganInd),'r')
                legend('T1','T2','wmn')
                
                subplot(122)
                set ( gca, 'xdir', 'reverse' )
                ylabel('cumulative fliplr of histogram')
                hold on
                plot(bc(1,:,OrganInd),ac(1,:,OrganInd),'.g'), plot(bc(2,:,OrganInd),ac(2,:,OrganInd),'.blue'), plot(bc(3,:,OrganInd),ac(3,:,OrganInd),'.r')
                plot(bc(1,:,OrganInd),ac(1,:,OrganInd),'g') , plot(bc(2,:,OrganInd),ac(2,:,OrganInd),'blue') , plot(bc(3,:,OrganInd),ac(3,:,OrganInd),'r')
                legend('T1','T2','wmn')

                if NumOrgans > 1  && OrganInd < NumOrgans
                    pause
                end
            end
        case 'OrgansSimultaneously'
            ah = zeros(3,NumBins);  ac = ah*0;
            bh = zeros(3,NumBins);  bc = bh*0;
            for modalityNum = 1:3
                Pos = FinalData(modalityNum).FinalSegmentPosVal;
                [ah(modalityNum,:),bh(modalityNum,:)] = hist(reshape(Pos(Pos>PosThresh),1,[]),NumBins);
                bc(modalityNum,:) = fliplr(bh(modalityNum,:));
                ac(modalityNum,:) = cumsum(fliplr(ah(modalityNum,:)))/sum(ah(modalityNum,:));
                
%                 [f,x] = ecdf(reshape(Pos(Pos>PosThresh),1,[]));
%                 [a(modalityNum,:),b(modalityNum,:)] = ecdfhist(f,x,NumBins);
                
            end
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