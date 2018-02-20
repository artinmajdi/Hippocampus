function PosteriorComparison = funcVoxelByVoxel(imT1Slice , imT2Slice , imWMNSlice,show)


    %% finding the maximum posteriori

        A        = imT1Slice;
        A(:,:,2) = imT2Slice;
        A(:,:,3) = imWMNSlice;
    [a,b] = sort(A,3,'descend');


    PosteriorComparison = b*0;
    for y = 1:size(b,1)
        for x = 1:size(b,2)
            K = [imT1Slice(y,x) , imT2Slice(y,x), imWMNSlice(y,x)];
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