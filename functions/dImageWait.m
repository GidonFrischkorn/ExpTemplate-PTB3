% This is a generic functions that shows a predefined image (ima) and waits
% for a key press. As soon as any key on the keyboard is pressed, the
% screen is cleared.

function dImageWait(expinfo, ima)
    InstScreen = Screen('MakeTexture',expinfo.window,ima);
    Screen('DrawTexture', expinfo.window, InstScreen); % draw the scene
    Screen('Flip', expinfo.window);
    
    while KbCheck; end      %clear keyboard queue
    KbWait;                 %wait for any key
    clearScreen(expinfo.window,expinfo.Colors.bgColor);
end

%% End of Function
% This function was programmed by Gidon T. Frischkorn, as part of a
% template for MATLAB experiments. If you have any questions please contact
% me via mail: gidon.frischkorn@psychologie.uni-heidelberg.de