function ttestPvalueO = t_testing(a,L,show)

    A = [1,2;1,3;2,3];

    for i = 1:3
        for subfieldInd = 1:L

            % [subjects , modality , subfields]
            a1 = a(:,A(i,1),subfieldInd);
            a2 = a(:,A(i,2),subfieldInd);
            [h,p,ci,stats] = ttest2(a1 , a2);
            ttestPvalueO(i,subfieldInd) = p;
        end

        % for whole hippocampal Area
        a1 = reshape(a(:,A(i,1),:),[],1);
        a2 = reshape(a(:,A(i,2),:),[],1);
        [h,p,ci,stats] = ttest2(a1 , a2);
        ttestPvalueO(i,L+1) = p;

    end

    if show.tableShow
        ttestPvalue = round(ttestPvalueO*1e6)/1e6;
        T1_T2  = ttestPvalue(1,:)';
        T1_wmn = ttestPvalue(2,:)';
        T2_wmn = ttestPvalue(3,:)';
        
        tTest_Pvalues = table(T1_T2,T1_wmn,T2_wmn,'RowName',show.name)
        
        writetable(tTest_Pvalues,[show.OutputDir,'Output.xls'],'Sheet','tTest_Pvalues','WriteRowNames',true)
        
    end

end