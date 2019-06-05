function timestamp_flip = TextCenteredOnPos(window,text,x,y,color,when,mirror,angle)
    %% Default settings
    % Set color if it is not supplied in the arguments
    if ~exist('color','var')
        color = BlackIndex(window);
    elseif isempty(color)
        color = BlackIndex(window);
    end

    if ~exist('flip','var')
        mirror = 0;
    elseif isempty(mirror)
        mirror = 0;
    end

    if ~exist('angle','var')
        angle = 0;
    elseif isempty(angle)
        angle = 0;
    end
    
    %% Implementing the Text Position, Rotation and Mirroring of the Text
    % Compute Coordinated to Center text on
    textbounds = Screen('TextBounds', window, text);
    posX = x - textbounds(3)/2;
    posY = y - textbounds(4)/2;

    % Make a backup copy of the current transformation matrix for later
    % use/restoration of default state:
    Screen('glPushMatrix', window);

    % Translate origin into the geometric center of text:
    Screen('glTranslate', window, x, y, 0);
    if mirror
        Screen('glScale', window, -1, 1, 1);
    end
    Screen('glRotate', window, angle);
    Screen('glTranslate', window, -x, -y, 0);

    %% Draw & Flip the text to the screen
    % Draw text on screen and Flip Scree
    Screen('DrawText',window, text, posX, posY, color);

    % Tell PTB no more drawing commands will be issued until the next flip
    Screen('DrawingFinished', window);

    % Flip Screen
    if ~exist('when','var')
        % Flip window immediately
        timestamp_flip = Screen('Flip',window);
    elseif isempty(when)
        % Flip window immediately
        timestamp_flip = Screen('Flip',window);
    else
        % Flip synced to timestamp entered
        timestamp_flip = Screen('Flip',window,when);
    end
    
    % Reset the transformation matrix to default state
    Screen('glPopMatrix', window);
end

%% End of Function
% This function was programmed by Gidon T. Frischkorn, as part of a
% template for MATLAB experiments. If you have any questions please contact
% me via mail: gidon.frischkorn@psychologie.uzh.ch