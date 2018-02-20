function [FinalSegment , FinalSegmentPosVal , ZeroMask] = funcFinalSegmentation(subDir,FlagMode,show,flag,varargin)

    switch FlagMode.mode

        case 'AllSubfields_AfterSegmentation'
            AllSubfieldsParallel = [];
            for i = 1:length(subDir)

                
                if flag == 1
                    dataT1 = load_untouch_nii([subDir(i).folder,'/',subDir(i).name]);
                else
                    dataT1 = load_nii([subDir(i).folder,'/',subDir(i).name]);
                end

                AllSubfieldsParallel(:,:,:,i) = dataT1.img;

            end

            [a,b] = sort(AllSubfieldsParallel,4,'descend');
            ZeroMask = sum(AllSubfieldsParallel,4) < 0.1;

            FinalSegment = b(:,:,:,1); FinalSegment(ZeroMask) = 0;
            FinalSegmentPosVal = a(:,:,:,1); FinalSegmentPosVal(ZeroMask) = 0;

            %  SubfieldIm = SubfieldExtractor(FinalSegmentPosVal,FinalSegment,2);

        case 'OneSubfield'

            OId = FlagMode.SubfieldIndex;

            dataT1 = load_nii([subDir(OId).folder,'/',subDir(OId).name]);
            FinalSegmentPosVal = dataT1.img;
            FinalSegment = ones(size(FinalSegmentPosVal));
            ZeroMask = false(size(FinalSegmentPosVal));
    end


    if show.figShow
        
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