function [FinalSegment , FinalSegmentPosVal , ZeroMask] = funcFinalSegmentation(subDir,FlagMode,show,varargin)

    switch FlagMode.mode

        case 'AllOrgans_AfterSegmentation'
            AllOrgansParallel = [];
            for i = 1:length(subDir)

                dataT1 = load_nii([subDir(i).folder,'/',subDir(i).name]);
                AllOrgansParallel(:,:,:,i) = dataT1.img;

            end

            [a,b] = sort(AllOrgansParallel,4,'descend');
            ZeroMask = sum(AllOrgansParallel,4) < 0.1;

            FinalSegment = b(:,:,:,1); FinalSegment(ZeroMask) = 0;
            FinalSegmentPosVal = a(:,:,:,1); FinalSegmentPosVal(ZeroMask) = 0;

            %  OrganIm = OrganExtractor(FinalSegmentPosVal,FinalSegment,2);

        case 'OneOrgan'

            OId = FlagMode.OrganIndex;

            dataT1 = load_nii([subDir(OId).folder,'/',subDir(OId).name]);
            FinalSegmentPosVal = dataT1.img;
            FinalSegment = ones(size(FinalSegmentPosVal));
            ZeroMask = false(size(FinalSegmentPosVal));
    end


    if show
        
        if ~isempty(varargin)
            sliceNum = varargin{1};
        end
        
        ax(1) = subplot(121) ; image(FinalSegment(:,:,sliceNum))
        colormap(colorcube)
        title('Final Segment')

        ax(2) = subplot(122) ; imshow(FinalSegmentPosVal(:,:,sliceNum))
        linkaxes(ax)
        
    end

%     ZeroMask = ~ZeroMask;