% This function reads the keyboard and detects wether a left or right
% navigation key is pressed to move forward or backward during instructions
% Besides it detects a pressed abort key to quit the experiment

% This function takes three options:
    % -1 only allows to move backwards
    % 0 allows to move back and forth
    % 1 only allows to move forward

function [response] = BackOrNext(expinfo, options)

validKey = 0; % Logical variable indicaating whether a valid key was pressed.
while validKey == 0
    [keyIsDown,~,keyCode] = KbCheck; % Read keyboard
    
    if keyIsDown % As soon as a key is pressed check whether it is a valid key
        pressedKey = KbName(keyCode); % Get key name for pressed key
        if strcmp(pressedKey,expinfo.RightKey) % right key pressed
            % Options = -1 only allow to move backwards
            if options ~= -1
                validKey = 1;
            end
        elseif strcmp(pressedKey,expinfo.LeftKey) % left key pressed
            % Options = 1 only allow to move foraward
            if options ~= 1
                validKey = 1;
            end
        elseif strcmp(pressedKey,expinfo.AbortKey) % Abort experiment
             % Close PTB window and abort the experiment
            closeexp(expinfo.window);
        end
    end
end

% As soon as a valid key has been pressed, we code whether to move forward
% or backward and
if strcmp(pressedKey,expinfo.LeftKey)
    response = -1;
elseif strcmp(pressedKey,expinfo.RightKey)
    response = 1;
end

%% End of Function
% This function was programmed by Gidon T. Frischkorn, as part of a
% template for MATLAB experiments. If you have any questions please contact
% me via mail: gidon.frischkorn@psychologie.uzh.ch