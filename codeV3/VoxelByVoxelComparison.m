clear
clc
close all


%%

mode = 'write';
switch mode
    case 'write'
        subsection = 'ca1';
        [imT1 , imT2 , imWMN] = myImread(subsection);

        
        show = 0;
        [y,x,z] = size(imT1);
        output = zeros(y,x,3,z);
        for sliceNum = 60:150
            
            if mod(sliceNum,5) == 0
                disp(['sliceNum: ',num2str(sliceNum)])
            end
            output(:,:,:,sliceNum) = funcVoxelByVoxel(imT1(:,:,sliceNum) , imT2(:,:,sliceNum) , imWMN(:,:,sliceNum),show);
            
        end
        save output output
        
        %%
        SumNonZero = zeros(1,3);
        for sliceNum = 55:120
            if mod(sliceNum,5) == 0
                disp(['sliceNum: ',num2str(sliceNum)])
            end
            for y = 1:size(output,1)
                for x = 1:size(output,2)

                    a = permute(output(y,x,:,sliceNum),[3,1,2,4]);
                    SumNonZero = SumNonZero + single(a' > 0);

                end
            end

        end

        SumNonZero = (SumNonZero/sum(SumNonZero)*100);
        T1_Per = SumNonZero(1);
        T2_Per = SumNonZero(2);
        wmn_Per = SumNonZero(3);
        save NonZeroPercentages T1_Per T2_Per wmn_Per


    case 'read'
        load('output.mat')
        load('NonZeroPercentages.mat')
end
%%
close all
sliceNum = 90;
imshow(output(:,:,:,sliceNum))
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
drawnow

% myImshowFinalResults(output)

table(T1_Per,T2_Per,wmn_Per,'RowNames',{'Percentage of highest posterior'})




