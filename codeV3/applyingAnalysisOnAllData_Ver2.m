clear
clc
close all

addpath('NIfTI_20140122')
mainDir = '../../freesurfer/subjects/';
DirNames = dir(mainDir);
k = [];
for i = 1:length(DirNames)
    if(length(DirNames(i).name) == 13)
        k = [k,i];
    end
end
DirNames = DirNames(k);

warning('off')
%% First Step: finding the segment in each modality

show.figShow = 0;
show.tableShow = 1;

%% writing section

mode = 'read';
switch mode
    case 'write'
        for orientation = {'right'} % {'left' , 'right'}
            orientation = cell2mat(orientation);
            for stateMode = {'AfterRegistration' , 'BeforeRegistration'}
                stateMode = cell2mat(stateMode);
                fprintf('***     orientation: %s \t state: %s    ***\n',orientation,stateMode)
                WriteSectionMain
                %                 Directory = [mainDir,'/Output/',orientation,'/',stateMode,'/'];
                %                 load([Directory,'output.mat'], 'output')
                %                 output = output(1:15);
                %                 save([Directory,'output.mat'], 'output')
            end
        end
        
    case 'read'
        for orientation = {'left' , 'right'}
            orientation = cell2mat(orientation);
            for stateMode2 = {'with11' , 'without11'}
                stateMode2 = cell2mat(stateMode2);
                for RegMode = 1:2
                    
                    %                 switch Mode11
                    %                     case 1
                    %                         stateMode2 = 'with11';
                    %                     case 2
                    %                         stateMode2 = 'without11';
                    %                 end
                    
                    switch RegMode
                        case 1
                            stateMode = 'AfterRegistration';
                            LL = 3;
                        case 2
                            stateMode = 'BeforeRegistration';
                            LL = 2;
                    end
                    for strgInd = 1:LL
                        
                        switch strgInd
                            case 1
                                strg = 'Mean';
                            case 2
                                strg = 'Median';
                            case 3
                                strg = 'AveNumPosMaxChosen';
                        end
                        fprintf('* orientation: %s , %s , %s , %s  ***\n',orientation,stateMode2,stateMode,strg)
                        
                        ReadSectionMain
                        
                        OutputDir = [mainDir,'/Output/',orientation,'/',stateMode,'/',stateMode2,'/',strg,'/'];
                        mkdir(OutputDir)
                        
                        %% mode to Analyse
                        % a: [subjects , modality , subfields]
                        
                        nameString = [strg,' ', stateMode , ' ', stateMode2];
                        DiaryName = [nameString,'.txt'];
                        diary(DiaryName)
                        
                        a = Data.(strg);
                        
                        for subfieldInd = 1:L
                            name{subfieldInd} = subDirT1(subfieldInd).name(16:end-11);
                        end
                        name{L+1} = '**WHOLE HIPPOCAMPUS**';
                        
                        %% t-test results
                        show.name = name;
                        show.OutputDir = OutputDir;
                        
                        ttestPvalueO = t_testing(a,L,show);
                        
                        %% mean of values
                        
                        % a:  [subjects , modality , subfields]
                        % a_mean: [subfields , modality , subjects]
                        a_mean = permute(a,[3,2,1]);
                        % a_mean: [subfields , modality]
                        a_mean = mean(a_mean,3);
                        b_mean = round(a_mean*100)/100;
                        if show.tableShow
                            T1  = a_mean(:,1);       T1(end+1)  = mean(T1);
                            T2 = a_mean(:,2);        T2(end+1)  = mean(T2);
                            wmn = a_mean(:,3);       wmn(end+1) = mean(wmn);
                            meanValues = table(T1,T2,wmn,'RowName',name)
                            
                            writetable(meanValues,[OutputDir,'Output.xls'],'Sheet','meanValues','WriteRowNames',true)
                        end
                        
                        %% Which modality is significant?
                        
                        [SigMap , SigMap2] = Significance(a,ttestPvalueO,show);
                        diary off
                        movefile(DiaryName,[OutputDir,DiaryName]);
                        
                        %%  boxploting the results
                        % a: [subjects , modality , subfields]
                        close all
                        modeShowResult = 'Subfield';
                        for subfieldInd = 1:L
                            switch modeShowResult
                                case 'Subfield'
                                    bpA = a(:,:,subfieldInd);
                                    
                                case 'wholeHippocampus'
                                    % [subjects , modality , subfields]
                                    [y,md,z] = size(a);
                                    bpA = zeros(y*z,md);
                                    for mdId = 1:md
                                        bpA(:,mdId) = reshape(a(:,mdId,:),[],1);
                                    end
                            end
                            nme = strrep(name{subfieldInd},'_','\_');
                            
                            aS = ['T1(',num2str(b_mean(subfieldInd,1)),')'];
                            bS = ['T2(',num2str(b_mean(subfieldInd,2)),')'];
                            cS = ['wmn(',num2str(b_mean(subfieldInd,3)),')'];
                            
                            % wmn - T2                              % T1 - T2                               % T1 - wmn
                            if strcmp(SigMap{subfieldInd,3} ,'---') && strcmp(SigMap{subfieldInd,1} ,'T2') &&  strcmp(SigMap{subfieldInd,2} ,'WMN')
                                bS = ['*',bS];
                                cS = ['*',cS];
                                
                                % T1 - T2                              % T1 - wmn                               % T2 - wmn
                            elseif strcmp(SigMap{subfieldInd,1} ,'---') && strcmp(SigMap{subfieldInd,2} ,'T1') &&  strcmp(SigMap{subfieldInd,3} ,'T2')
                                aS = ['*',aS];
                                bS = ['*',bS];
                                
                                % wmn - T1                              % T1 - T2                               % wmn - T2
                            elseif strcmp(SigMap{subfieldInd,2} ,'---') && strcmp(SigMap{subfieldInd,1} ,'T1') &&  strcmp(SigMap{subfieldInd,3} ,'WMN')
                                aS = ['*',aS];
                                cS = ['& ',cS];
                                
                            else
                                
                                
                                if     strcmp(SigMap{subfieldInd,1} , 'T1') % T1 - T2
                                    if strcmp(SigMap{subfieldInd,2} , 'T1') % T1 - wmn
                                        
                                        aS = ['*',aS];
                                        if strcmp(SigMap{subfieldInd,3} , 'WMN')  % T2 - wmn
                                            cS = ['& ',cS];
                                        elseif strcmp(SigMap{subfieldInd,3} , 'T2')  % T2 - wmn
                                            bS = ['& ',bS];
                                        end
                                        
                                    end
                                elseif strcmp(SigMap{subfieldInd,1} , 'T2') % T2 - T1
                                    if strcmp(SigMap{subfieldInd,3} , 'T2') % T2 - wmn
                                        
                                        bS = ['*',bS];
                                        if strcmp(SigMap{subfieldInd,2} , 'WMN')  % T1 - wmn
                                            cS = ['& ',cS];
                                        elseif strcmp(SigMap{subfieldInd,2} , 'T1')  % T1 - wmn
                                            aS = ['& ',aS];
                                        end
                                        
                                    end
                                end
                                
                                % wmn - T1                                % wmn - T2
                                if strcmp(SigMap{subfieldInd,2} , 'WMN')  && strcmp(SigMap{subfieldInd,3} , 'WMN')
                                    cS = ['*',cS];
                                    
                                    if strcmp(SigMap{subfieldInd,1} , 'T1')  % T1 - T2
                                        aS = ['& ',aS];
                                    elseif strcmp(SigMap{subfieldInd,1} , 'T2')  % T1 - T2
                                        bS = ['& ',bS];
                                    end
                                end
                                
                                
                            end
                            
                            
                            boxplot(bpA,{aS,bS,cS}),title(nme)
                            ylabel(strg)
                            
                            %         AxesH = gca;   % Not the GCF
                            %         F = getframe(AxesH);
                            %         imwrite(F.cdata, [mainDir,'Outputs/Mean ' , name{subfieldInd},'.jpg']);
                            
                            saveas(gca, [OutputDir,nameString, ' ', name{subfieldInd},'.jpg'])
                        end
                    end
                end
            end
        end
end













