
% output(subfields) : [subjects , modality]

Directory = [mainDir,'/Output/',orientation,'/',stateMode,'/'];
load([Directory,'output.mat'])

% switch stateMode 
%     case {1,'AfterRegistration'}
%         load([Directory,'output',orientation,'.mat'])
%         
%     case {2,'BeforeRegistration'}
%         load([mainDir,'outputNotRegistered',orientation,'.mat'])
%         output = outputNotRegistered;
% end



flds = fields(output);
for i = 1:length(flds)
    switch stateMode2
        % a: [subfields , modality , subjects]
        case {1,'with11'}
            Data.(flds{i}) = cat(3,output.(flds{i}));
        case {2,'without11'}
            Data.(flds{i}) = cat(3,output([1:10,12:end]).(flds{i}));
    end
    % a: [subjects , modality , subfields]
    Data.(flds{i}) = permute(Data.(flds{i}),[3,2,1]);
end



% a: [subfields , modality , subjects]
%         AveNumPosMaxChosen = cat(3,output.AveNumPosMaxChosen);
%         Mean               = cat(3,output.Mean);
%         Median             = cat(3,output.Median);
%         SD                 = cat(3,output.SD);

% a: [subjects , modality , subfields]
%         AveNumPosMaxChosen = permute(AveNumPosMaxChosen,[3,2,1]);
%         Mean               = permute(Mean  ,[3,2,1]);
%         Median             = permute(Median,[3,2,1]);
%         SD                 = permute(SD    ,[3,2,1]);


ADDRESS  =  [DirNames(1).folder,'/',DirNames(1).name,'/'];
% subDirT1 = dir([ADDRESS,'*',orientation,'_*T1_v10.nii']);
subDirT1 = dir([ADDRESS,'*left*T1_v10.nii']);
L = length(subDirT1);

%         L = 11;
%% show the results
%         subjectNum = 2;
%
%         clear name
%         for subfieldInd = 1:11
%             name{subfieldInd} = subDirT1(subfieldInd).name(16:end-11);
%         end

%         subMean  = permute(Data.Mean,[3,2,1]);  subMean = subMean(:,:,subjectNum);
%         T1_mean  = subMean(:,1);
%         T2_mean  = subMean(:,2);
%         wmn_mean = subMean(:,3);
%         MeanValues = table(T1_mean,T2_mean,wmn_mean,'RowNames',name)

%         subMedian  = permute(Data.Median,[3,2,1]);  subMedian = subMedian(:,:,subjectNum);
%         T1_median  = subMedian(:,1);
%         T2_median  = subMedian(:,2);
%         wmn_median = subMedian(:,3);
%         MedianValues = table(T1_median,T2_median,wmn_median,'RowNames',name)

%         subSD  = permute(Data.SD,[3,2,1]);  subSD = subSD(:,:,subjectNum);
%         T1_SD  = subSD(:,1);
%         T2_SD  = subSD(:,2);
%         wmn_SD = subSD(:,3);
%         SDValues = table(T1_SD,T2_SD,wmn_SD,'RowNames',name)

%         subAP  = permute(Data.AveNumPosMaxChosen,[3,2,1]);  subMean = subMean(:,:,subjectNum);
%         T1_AP  = subAP(:,1);
%         T2_AP  = subAP(:,2);
%         wmn_AP = subAP(:,3);
%         APValues = table(T1_AP,T2_AP,wmn_AP,'RowNames',name)
