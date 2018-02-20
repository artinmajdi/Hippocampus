clear
clc
close all

subsection = 'ca1';
[imT1 , imT2 , imWMN] = myImread(subsection);

%% 
% sliceNum = 90;
% imT1slice  = imT1(:,:,sliceNum);
% imT2slice  = imT2(:,:,sliceNum);
% imWMNslice = imWMN(:,:,sliceNum);

% myShow(imT1slice,imT2slice,imWMNslice)
%%
NumBins = 30;
lowerBand = 0.5;
[a,b] =  hist(imT1(imT1 > lowerBand),NumBins);
[a2,b2] =  hist(imT2(imT2 > lowerBand),NumBins);
[a3,b3] =  hist(imWMN(imWMN > lowerBand),NumBins);


figure , subplot(121),title('posteriory histogram')
    hold on 
    plot(b,a,'.g'), plot(b2,a2,'.blue'), plot(b3,a3,'.r')
    plot(b,a,'g')    , plot(b2,a2,'blue')    , plot(b3,a3,'r')
legend('T1','T2','wmn')

%%
subplot(122)
    hold on 
    plot(b,smooth(a),'g') 
    plot(b2,smooth(a2),'blue')
    plot(b3,smooth(a3),'r')
legend('T1','T2','wmn')
