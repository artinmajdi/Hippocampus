function [SigMap , SigMap2] = Significance(a,ttestPvalueO,show)


    A = [1 , 2 ;...
        1 , 3 ;...
        2 , 3 ];

    th = 0.05;  % threshold to see how significantly two values are different modalities
    

    ModalityNames = {'T1','T2','WMN'};

    % a: [subjects , modality , subfields]
    [sbN,mN,sfN] = size(a);

    SigMap  = cell(sfN+1 , mN);
    SigMap2 = cell(sfN+1 , mN);
    for j = 1:sfN+1
        for i = 1:mN
            SigMap{j,i}  = '---';
            SigMap2{j,i} = '---';
        end
    end

    mn = zeros(mN,sfN+1);
    for i = 1:mN
        mn(i,1:sfN) = mean(squeeze(a(:,i,:)),1);

        mn(i,sfN+1) = mean(reshape(a(:,i,:),[],1));


    end

    mn = mn';
    % mn: [subfields , modality]
    for i = 1:3
        % ttestPvalueO: [modality , subfields]
        % Pvalue: [subfields]
        Pvalue = ttestPvalueO(i,:)';

        f = find(Pvalue <= 0.05);

        for j = 1:sfN+1
            if ~isempty(intersect(f,j))
                if mn(j,A(i,1)) - mn(j,A(i,2)) > 0
                    SigMap{j,i} = ModalityNames{A(i,1)};
                elseif mn(j,A(i,1)) - mn(j,A(i,2)) < 0
                    SigMap{j,i} = ModalityNames{A(i,2)};
                end
            end

            % a: [subjects , modality , subfields]
            if j < sfN+1
                K = a(:,A(i,1),j) - a(:,A(i,2),j);
            else
                K = reshape( a(:,A(i,1),:) - a(:,A(i,2),:) ,[],1);
            end

            if sum(K > th) - sum(K < -th) > 0
                SigMap2{j,i} = [ModalityNames{A(i,1)} , ': ',num2str(sum(K > th)), '_' , num2str(sum(K < -th))];
            elseif sum(K > th) - sum(K < -th) < 0
                SigMap2{j,i} = [ModalityNames{A(i,2)} , ': ',num2str(sum(K > th)), '_' , num2str(sum(K < -th))];
            end

        end
    end

    if show.tableShow
        T1_T2  = SigMap(:,1);
        T1_wmn = SigMap(:,2);
        T2_wmn = SigMap(:,3);
        SignificanceMap = table(T1_T2,T1_wmn,T2_wmn,'RowName',show.name)

        T1_T2  = SigMap2(:,1);
        T1_wmn = SigMap2(:,2);
        T2_wmn = SigMap2(:,3);
        SignificanceMap2 = table(T1_T2,T1_wmn,T2_wmn,'RowName',show.name)
        
        writetable(SignificanceMap,[show.OutputDir,'Output.xls'],'Sheet','SignificanceMap','WriteRowNames',true)
        writetable(SignificanceMap2,[show.OutputDir,'Output.xls'],'Sheet','SignificanceMap2','WriteRowNames',true)

    end

end