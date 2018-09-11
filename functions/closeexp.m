% This function clears the buffer and closes the currnetly running
% experiment

function closeexp(window)

ShowCursor(1);  % Show cursor again
ListeChar();    % Enable listening to the keyboard
Screen(window,'CloseAll'); % Close window

% Clear buffer for saved evetns
while KbCheck; end
FlushEvents('keyDown');

%% End of Function
% This function was programmed by Gidon T. Frischkorn, as part of a
% template for MATLAB experiments. If you have any questions please contact
% me via mail: gidon.frischkorn@psychologie.uni-heidelberg.de