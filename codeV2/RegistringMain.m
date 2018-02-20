clear
clc
close all

subsection = 'ca1';
[imT1 , imT2 , imWMN] = myImread(subsection);
show = 0;
sliceNum = 90;
imT1Slice  = imT1(:,:,sliceNum);
imT2Slice  = imT2(:,:,sliceNum);
imWMNSlice = imWMN(:,:,sliceNum);

myShow(imT1Slice,imT2Slice,imWMNSlice)


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

% sliceNum = 80;
% imT1Slice  = imT1(:,:,sliceNum);
% imT2Slice  = imT2(:,:,sliceNum);
% imWMNSlice = imWMN(:,:,sliceNum);


    [optimizer,metric] = imregconfig('multimodal');
    tform0 = imregtform(imT2Slice, imT1Slice, 'rigid', optimizer, metric);
    imT2newSlide = imwarp(imT2Slice,tform0,'OutputView',imref2d(size(imT1Slice)));

    tform = imregtform(imT2newSlide, imT1Slice, 'similarity', optimizer, metric);
    imT2newSlideb = imwarp(imT2newSlide,tform,'OutputView',imref2d(size(imT1Slice)));
    figure
    subplot(121) , imshowpair(imT1Slice, imT2newSlide,'Scaling','joint') , title('T1 & T2')
    subplot(122) , imshowpair(imT1Slice, imT2newSlideb,'Scaling','joint') , title('T1 & T2')

%% matching T1 and wmn
% close all

% sliceNum = 80;
% imT1Slice  = imT1(:,:,sliceNum);
% imT2Slice  = imT2(:,:,sliceNum);
% imWMNSlice = imWMN(:,:,sliceNum);
close all
    [optimizer,metric] = imregconfig('multimodal');
    tform2 = imregtform(imWMNSlice, imT1Slice, 'rigid', optimizer, metric);
    imWMNnewSlide = imwarp(imWMNSlice,tform2,'OutputView',imref2d(size(imT1Slice)));

    tform3 = imregtform(imWMNnewSlide, imT1Slice, 'similarity', optimizer, metric);
    imWMNnewSlideb = imwarp(imWMNnewSlide,tform3,'OutputView',imref2d(size(imT1Slice)));
    
    subplot(121) ,imshowpair(imT1Slice, imWMNnewSlide,'Scaling','joint') , title('T1 & wmn')
    subplot(122) , imshowpair(imT1Slice, imWMNnewSlideb,'Scaling','joint') , title('T1 & wmn')


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
