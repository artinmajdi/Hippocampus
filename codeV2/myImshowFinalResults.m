function myImshowFinalResults(output)

    sliceNum = 69;
    while 1
        h = figure; 
        set(h,'KeyPressFcn',@KeyPressCb);
        sliceNum = KeyPressCb(10,evnt,sliceNum);
        function KeyPressCb(~,evnt,sliceNum)
            fprintf('key pressed: %s\n',evnt.Key);
            if strcmp(evnt.Key,'rightarrow')==1
                sliceNum = sliceNum + 1;
            elseif strcmp(evnt.Key, 'leftarrow')==1
                sliceNum = sliceNum - 1;
            end
        end

        close all
        imshow(output(:,:,:,sliceNum))
    end
    
end



