% This function waits for a response and saves the 
function Trial = getresponse(expinfo, Trial, expTrial, start)
% Start iternal MATLAB stop-clock
tic 

% If timestamp for onset latency is not provided read out current system
% time. Attention this is just a work around and leads to biased reaction
% times
if ~exist('start','var')
    start = GetSecs;
end

% Initialise the response variables
Trial(expTrial).response = 0;
Trial(expTrial).ACC = -9;
Trial(expTrial).RT = -9;

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
        
        % Testen ob die Taste zu den erlaubten Antwort-Tasten geh�rt
        if any(strcmp(pressedKey,expinfo.RespKeys))
            response = 1;
            break; % Dann soll die Loop abgebrochen werden
        else
            response = 0;
        end
        
        % Abbruch des Experiments
        if  strcmp(pressedKey,expinfo.AbortKey)
            closeexp(expinfo.window);
        end
    else
        response = 0;
    end
end
Trial(expTrial).keyPressed = timeSecs;

if response == 1 % Wenn eine erlaubte Taste gedr�ckt wurde
    Trial(expTrial).RT = timeSecs - start; % Berechnung der Reaktionszeit
    
    % Test wether the correct response was given
    if strcmp(pressedKey,Trial(expTrial).CorrResp)
        Trial(expTrial).ACC = 1; 
    else
        Trial(expTrial).ACC = 0; 
    end
    
    Trial(expTrial).response = pressedKey;
else  % Wenn keine erlaubte Antwort gegeben wurde -> Miss
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