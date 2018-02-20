function PosteriorComparison = funcVoxelByVoxel3D(FinalData,VoxelByVoxelAnalysisMode)

    imT1  = FinalData(1).FinalSegmentPosVal;
    imT2  = FinalData(2).FinalSegmentPosVal;
    imWMN = FinalData(3).FinalSegmentPosVal; 
                            
    [y,x,z] = size(imT1);
    NumberOfModalities = 3;
    % ----------------------
    % ----------------------
    switch VoxelByVoxelAnalysisMode
        case 'SubfieldsSeperately'
            segT1  = FinalData(1).FinalSegment;
            segT2  = FinalData(2).FinalSegment;
            segWMN = FinalData(3).FinalSegment; 

            NumberOfSubfields     = max(segT1(:));
            

            PosteriorComparison = zeros(y,x,z,NumberOfSubfields,NumberOfModalities);   
            for SubfieldInd = 1:NumberOfSubfields

                imT1org  = SubfieldExtractor(imT1,segT1,SubfieldInd);
                imT2org  = SubfieldExtractor(imT2,segT2,SubfieldInd);
                imWMNorg = SubfieldExtractor(imWMN,segWMN,SubfieldInd);

                [A1,A2,A3] = PosterioryEvaluation2(imT1org , imT2org , imWMNorg);
                PosteriorComparison(:,:,:,SubfieldInd,1) = A1;
                PosteriorComparison(:,:,:,SubfieldInd,2) = A2;
                PosteriorComparison(:,:,:,SubfieldInd,3) = A3;

            end
    
    case 'SubfieldsSimultaneously'

        [A1,A2,A3] = PosterioryEvaluation2(imT1, imT2, imWMN);  
        
        SubfieldInd = 1;
        PosteriorComparison = zeros(y,x,z,1,NumberOfModalities);

            PosteriorComparison(:,:,:,SubfieldInd,1) = A1;
            PosteriorComparison(:,:,:,SubfieldInd,2) = A2;
            PosteriorComparison(:,:,:,SubfieldInd,3) = A3;        

    end
        
end

function [A1,A2,A3] = PosterioryEvaluation2(imT1 , imT2 , imWMN)

    [y,x,z] = size(imT1);
    L = length(size(imT1));
    A = cat(L+1,imT1,imT2,imWMN);
    [a,b] = sort(A,L+1,'descend'); 

    f1 = find(a(:,:,:,1) - a(:,:,:,2) > 0.05);
    BBx = zeros(size(a));
    BBx(f1) = b(f1);
    
    f2 = find( (a(:,:,:,1) - a(:,:,:,2) < 0.05) & (a(:,:,:,2) - a(:,:,:,3) > 0.05) );

    BBx([ f2 ; f2 + y*x*z ]) = b([ f2 ; f2 + y*x*z ]);
    
    f3 = find( (a(:,:,:,1) - a(:,:,:,2) < 0.05) & (a(:,:,:,2) - a(:,:,:,3) < 0.05)  );
    BBx([ f3 ; f3 + y*x*z ; f3 + 2*y*x*z ]) = b([ f3 ; f3 + y*x*z ; f3 + 2*y*x*z ]);

    
    A1 = zeros(size(imT1));
    A2 = zeros(size(imT2));
    A3 = zeros(size(imWMN));
    for i = 1:3
        bbx = BBx(:,:,:,i);
        A1(bbx == 1) = imT1(bbx == 1);
        A2(bbx == 2) = imT2(bbx == 2);
        A3(bbx == 3) = imWMN(bbx == 3);
    end
       
end

function PosteriorComparison = PosterioryEvaluation(imT1 , imT2 , imWMN)

    A = cat(4,imT1,imT2,imWMN);
    [a,b] = sort(A,4,'descend'); 


    PosteriorComparison = a*0;
    for sliceNum = 1:size(b,3)
        if mod(sliceNum,20) == 0
            disp(['sliceNum: ',num2str(sliceNum)])
        end
        for y = 1:size(b,1)
            for x = 1:size(b,2)
                K = [imT1(y,x,sliceNum) , imT2(y,x,sliceNum), imWMN(y,x,sliceNum)];
                if a(y,x,sliceNum,1) - a(y,x,sliceNum,2) > 0.05
                    PosteriorComparison(y,x,sliceNum,b(y,x,sliceNum,1)) = a(y,x,sliceNum,1);
                elseif a(y,x,sliceNum,2) - a(y,x,sliceNum,3) > 0.05
                    PosteriorComparison(y,x,sliceNum,b(y,x,sliceNum,1)) = a(y,x,sliceNum,1);
                    PosteriorComparison(y,x,sliceNum,b(y,x,sliceNum,2)) = a(y,x,sliceNum,2);
                else
                    PosteriorComparison(y,x,sliceNum,b(y,x,sliceNum,1)) = a(y,x,sliceNum,1);
                    PosteriorComparison(y,x,sliceNum,b(y,x,sliceNum,2)) = a(y,x,sliceNum,2);
                    PosteriorComparison(y,x,sliceNum,b(y,x,sliceNum,3)) = a(y,x,sliceNum,3);
                end
            end
        end
    end

end
