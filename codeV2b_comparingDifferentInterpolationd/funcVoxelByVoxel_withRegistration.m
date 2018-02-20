function PosteriorComparison = funcVoxelByVoxel(imT1Slice , imT2Slice , imWMNSlice,show)

    % myShow(imT1Slice,imT2Slice,imWMNSlice)


    %% registring 3D  method 1
    %     clc
    %     [optimizer,metric] = imregconfig('multimodal');
    %     newImT1 = imregister(imT1Slice, imT2Slice, 'similarity', optimizer, metric);
    %% registring 3D  method 1
    %     tform = imregtform(imT1Slice, imT2Slice, 'affine', optimizer, metric)
    % 
    %     movingRegistered = imwarp(imT1Slice,tform,'OutputView',imref3d(size(imT2Slice)));
    %     
    %     clc
    %     ;
    %     newImT1Slice = movingRegistered(:,:,sliceNum);
    %     imT2Slice = imT2Slice;
    %         
    %     imshowpair(newImT1Slice, imT2Slice,'Scaling','joint')

    %% show 3D results
    %     sliceNum = 270;
    % %     newImT1Slice = permute(newImT1(:,sliceNum,:),[1,3,2]);
    %     
    %     newImT1Slice = newImT1(:,sliceNum,:);
    %     imT2Slice = imT2Slice(:,sliceNum,:);
    % 
    %         
    %     imshowpair(newImT1Slice, imT2Slice);
    %     % figure , imshow3D( imT1Slice)
    %     % figure , imshow3D(movingRegisteredDefault)

    %     figure , imshow3D( imT1Slice)
    %     figure , imshow3D(movingRegisteredDefault)

    %% matching T1 and T2
    close all

    %     sliceNum = 70;
        [optimizer,metric] = imregconfig('multimodal');
        tform = imregtform(imT2Slice, imT1Slice, 'rigid', optimizer, metric);
        imT2newSlide = imwarp(imT2Slice,tform,'OutputView',imref2d(size(imT1Slice)));

        tform = imregtform(imT2newSlide, imT1Slice, 'similarity', optimizer, metric);
        imT2newSlide = imwarp(imT2newSlide,tform,'OutputView',imref2d(size(imT1Slice)));
    %     figure
    %     imshowpair(imT1Slice, imT2newSlide,'Scaling','joint')

    %% matching T1 and wmn
    close all

    %     sliceNum = 60;
        [optimizer,metric] = imregconfig('multimodal');
        tform = imregtform(imWMNSlice, imT1Slice, 'rigid', optimizer, metric);
        imWMNnewSlide = imwarp(imWMNSlice,tform,'OutputView',imref2d(size(imT1Slice)));

        tform = imregtform(imWMNnewSlide, imT1Slice, 'similarity', optimizer, metric);
        imWMNnewSlide = imwarp(imWMNnewSlide,tform,'OutputView',imref2d(size(imT1Slice)));
    %     figure
    %     imshowpair(imT1Slice, imWMNnewSlide,'Scaling','joint')    


    %% inverse of T1 2 wmn 
    % close all
    %     sliceNum = 105;
    % 
    %     tform = imregtform(imT1Slice, imWMNSlice, 'similarity', optimizer, metric);
    %     tform2 = inv(tform.T);
    %     tform2(1:2,3) = 0;
    %     tform2(3,3) = 1;
    % 
    %     tform2 = affine2d(tform2);
    %     imWMNnewSlide = imwarp(imWMNSlice,tform2,'OutputView',imref2d(size(imT1Slice)));
    %     imshowpair(imWMNnewSlide, imT1Slice,'Scaling','joint')
    %% finding the maximum posteriori

        A = imT1Slice;
        A(:,:,2) = imT2newSlide;
        A(:,:,3) = imWMNnewSlide;
    [a,b] = sort(A,3,'descend');


    PosteriorComparison = b*0;
    for y = 1:size(b,1)
        for x = 1:size(b,2)
            K = [imT1Slice(y,x) , imT2newSlide(y,x), imWMNnewSlide(y,x)];
            if K(b(y,x,1)) - K(b(y,x,2)) > 0.05
                PosteriorComparison(y,x,b(y,x,1)) = K(b(y,x,1));
            elseif K(b(y,x,2)) - K(b(y,x,3)) > 0.05
                PosteriorComparison(y,x,b(y,x,1)) = K(b(y,x,1));
                PosteriorComparison(y,x,b(y,x,2)) = K(b(y,x,2));
            else
                PosteriorComparison(y,x,b(y,x,1)) = K(b(y,x,1));
                PosteriorComparison(y,x,b(y,x,2)) = K(b(y,x,2));            
                PosteriorComparison(y,x,b(y,x,3)) = K(b(y,x,3));
            end
        end
    end

    if show 
        close all
        imshow(PosteriorComparison)
        drawnow
    end

end