function myShow(varargin)

    L = length(varargin);

        
    if length(size(varargin)) == 2
        for i = 1:L
            ax(i) = subplot(1,L,i) ; imshow(varargin{i},[])
        end
    else
        for i = 1:L
            ax(i) = subplot(1,L,i) ; imshow3D(varargin{i})
        end
    end
    linkaxes(ax)
end