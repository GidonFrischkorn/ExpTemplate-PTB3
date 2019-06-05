% This function clears the screen by overriding the current screen with a
% filled rectangle of a specified color. Optionally a timestamp for the
% flip "when" can be provided

function timestamp_flip = clearScreen(window,color,when)

Screen('FillRect',window,color);

% Tell PTB no more drawing commands will be issued until the next flip
Screen('DrawingFinished', window);

if ~exist('when','var') || isempty(when)
    % Flip window immediately
    timestamp_flip = Screen('Flip',window);
else
    % Flip synced to timestamp entered
    timestamp_flip = Screen('Flip',window,when);
end

%% End of Function
% This function was programmed by Gidon T. Frischkorn, as part of a
% template for MATLAB experiments. If you have any questions please contact
% me via mail: gidon.frischkorn@psychologie.uzh.ch