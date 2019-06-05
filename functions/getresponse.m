% This function waits for a response and saves the 
function Trial = getresponse(expinfo, Trial, expTrial, start)
% If timestamp for onset latency is not provided read out current system
% time. Attention this is just a work around and leads to biased reaction
% times
if ~exist('start','var')
    start = GetSecs;
end

% Start iternal MATLAB stop-clock
tic 

% clear Buffer of Keyboard
while KbCheck; end 

% read out keyboard until valid key is pressed or maximal allowed response
% time is reached
while toc < expinfo.MaxRT
    % Read keyboard
    [keyIsDown,timeSecs,keyCode] = KbCheck;
    
    if keyIsDown
        % get pressed Key
        pressedKey = KbName(keyCode);
        
        % Test whether the pressed key is one of the response keys
        if any(strcmp(pressedKey,expinfo.RespKeys))
            response = 1;
            break; % Break loop if a valid key was pressed
        else
            response = 0;
        end
        
        % Implement abort key during response stage
        if  strcmp(pressedKey,expinfo.AbortKey)
            closeexp(expinfo.window);
        end
    else
        response = 0;
    end
end
% Save timeStamp of key press to the Trial structure
Trial(expTrial).keyPressed = timeSecs;

if response == 1 % If valid key was pressed
    Trial(expTrial).RT = timeSecs - start; % Calculate the Reaction Time
    
    % Test wether the correct response was given
    if strcmp(pressedKey,Trial(expTrial).CorrResp)
        Trial(expTrial).ACC = 1; 
    else
        Trial(expTrial).ACC = 0; 
    end
    
    % Save the actual response as well
    Trial(expTrial).response = pressedKey;
else  % If no valid key was pressed
    Trial(expTrial).RT = expinfo.MaxRT;
    Trial(expTrial).ACC = -2;
    Trial(expTrial).response = 'miss';
end

while KbCheck; end % clear buffer
FlushEvents('keyDown');

%% End of Function
% This function was programmed by Gidon T. Frischkorn, as part of a
% template for MATLAB experiments. If you have any questions please contact
% me via mail: gidon.frischkorn@psychologie.uni-heidelberg.de