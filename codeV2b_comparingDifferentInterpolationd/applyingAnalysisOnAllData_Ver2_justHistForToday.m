clear
clc
close all

addpath('NIfTI_20140122')
% 
DirNames = dir('../../freesurfer/subjects/');
NumSubInterpolate = 1;

% DirNames = dir('../data/');
% NumSubInterpolate = 11;

DirNames = DirNames(3:end-1);
                   
flag_InitialReadingMode.mode = 'OneOrgan';
flag_InitialReadingMode.OrganIndex = 1;

flag_AnalysisMode = 'OrgansSeperately'; % 'OrgansSimultaneously'; 'OrgansSeperately';
show = 0;

Initialization
    
NumSubInterpolate = 4;
    show = 0;
    NumBins = 30;
    PosThresh = 0.5;
    ah = zeros(3,NumBins,NumSubInterpolate);   ac = ah*0;
    bh = zeros(3,NumBins,NumSubInterpolate);   bc = bh*0;
    Mean = zeros(NumSubInterpolate,3);
    Median = zeros(NumSubInterpolate,3);
    FWHM = nan(NumSubInterpolate,3);
    
    
for IM = 1:NumSubInterpolate

    for modalityNum = 1:length(FinalData)
        subDir = FinalData(modalityNum).address;
            
            if modalityNum == 1
                ca1_interpolate = load_nii([subDir(1).folder,'/',subDir(1).name]);
            else
                ca1_interpolate = load_nii([subDir(IM).folder,'/',subDir(IM).name]);
            end
            
            ca1_ipIm = ca1_interpolate.img;
            
            K = ca1_ipIm(ca1_ipIm > PosThresh );
            Mean(IM,modalityNum) = mean(K(:));
            Median(IM,modalityNum) = median(K(:));
            [ah(modalityNum,:,IM),bh(modalityNum,:,IM)] = hist(reshape(ca1_ipIm(ca1_ipIm>PosThresh),1,[]),NumBins);
            bc(modalityNum,:,IM) = fliplr(bh(modalityNum,:,IM));
            ac(modalityNum,:,IM) = cumsum(fliplr(ah(modalityNum,:,IM)))/sum(ah(modalityNum,:,IM));

            try
                FWHM(IM,modalityNum) = fwhm(bh(modalityNum,:,IM),ah(modalityNum,:,IM));
            catch
            end

        
    end

end
%% showing
if show 
    for IM = 1:NumSubInterpolate
        name = FinalData(1).address(IM).name(16:end-11);

        string = ['subject:',DirNames(subjectNum).name , '      organ: ',name];
        string = strrep(string,'_','\_');
        figure ,
        subplot(121) , title(string,'fontsize',9)
        ylabel('posteriori histogram')
        hold on
        plot(bh(1,:,IM),ah(1,:,IM),'.g'), plot(bh(2,:,IM),ah(2,:,IM),'.blue'), plot(bh(3,:,IM),ah(3,:,IM),'.r')
        plot(bh(1,:,IM),ah(1,:,IM),'g') , plot(bh(2,:,IM),ah(2,:,IM),'blue') , plot(bh(3,:,IM),ah(3,:,IM),'r')
        legend('T1','T2','wmn')

        subplot(122)
        set ( gca, 'xdir', 'reverse' )
        ylabel('cumulative fliplr of histogram')
        hold on
        plot(bc(1,:,IM),ac(1,:,IM),'.g'), plot(bc(2,:,IM),ac(2,:,IM),'.blue'), plot(bc(3,:,IM),ac(3,:,IM),'.r')
        plot(bc(1,:,IM),ac(1,:,IM),'g') , plot(bc(2,:,IM),ac(2,:,IM),'blue') , plot(bc(3,:,IM),ac(3,:,IM),'r')
        legend('T1','T2','wmn')

        if NumSubInterpolate > 1  && IM < NumSubInterpolate
            pause
        end
    end
end
%%
clear name
    for IM = 1:NumSubInterpolate
        name{IM} = FinalData(2).address(IM).name(38:end-4);
    end
    T1_mean  = Mean(:,1);
    T2_mean  = Mean(:,2);
    wmn_mean = Mean(:,3);
    MeanValues = table(T1_mean,T2_mean,wmn_mean,'RowNames',name)
    
    T1_median  = Median(:,1);
    T2_median  = Median(:,2);
    wmn_median = Median(:,3);
    MedianValues = table(T1_median,T2_median,wmn_median,'RowNames',name)

    T1_FWHM  = FWHM(:,1);
    T2_FWHM  = FWHM(:,2);
    wmn_FWHM = FWHM(:,3);
    FWHMValues = table(T1_FWHM,T2_FWHM,wmn_FWHM,'RowNames',name)    
    