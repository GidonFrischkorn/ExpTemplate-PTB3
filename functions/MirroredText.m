function timestamp_flip = MirroredText(window,text,x,y,color,flip,when)

% Set color if it is not supplied in the arguments
if ~exist('color','var')
    color = BlackIndex(window);
elseif isempty(color)
    color = BlackIndex(window);
end

% Compute Coordinated to Center text on
textbounds = Screen('TextBounds', window, text);
posX = x - textbounds(3)/2;
posY = y - textbounds(4)/2;

textbox = OffsetRect(textbounds, posX, posY);
[xc, yc] = RectCenterd(textbox);

% Make a backup copy of the current transformation matrix for later
% use/restoration of default state:
Screen('glPushMatrix', window);

% Translate origin into the geometric center of text:
Screen('glTranslate', window, xc, yc, 0);

if flip
    Screen('glScale', window, -1, 1, 1);
end

% note that for the PTB screen, a positive rotation is
% clockwise.
Screen('glRotate', window, ang);

% We need to undo the translations...
Screen('glTranslate', window, -xc, -yc, 0);

% Draw text on screen and Flip Scree
Screen('DrawText',window, text, posX, posY, color);
Screen('glPopMatrix', window);

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


end

%% End of Function
% This function was programmed by Gidon T. Frischkorn, as part of a
% template for MATLAB experiments. If you have any questions please contact
% me via mail: gidon.frischkorn@psychologie.uni-heidelberg.de