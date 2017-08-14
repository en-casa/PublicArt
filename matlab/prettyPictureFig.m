function prettyPictureFig(f, color)

    if nargin == 1
        color = [0 0 0];
    end

    set(f,'visible', 'on', 'position',[0 0 1 1],...
        'units','normalized','Color',color);
    set(f, 'units', 'normalized', ...
        'Position', [0.43 0.054 0.56 0.91], ...
        'MenuBar', 'none');
    
end