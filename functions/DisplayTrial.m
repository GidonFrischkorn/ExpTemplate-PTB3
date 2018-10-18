% This function displays one trial of a Simon Task

function Trial = DisplayTrial(expinfo, Trial, expTrial, isPractice)
%% Trial Procedure
if expTrial == 1
    WaitSecs(1); % Pre-hac timing so that experimental trials do not start right away
elseif strcmp(Trial(expTrial).Pause,'post')
    WaitSecs(1); % Pre-hac timing so that experimental trials do not start right away
end

% display Fixation Cross
Trial(expTrial).time_fixation = TextCenteredOnPos(expinfo.window,'+',expinfo.centerX,expinfo.centerY,expinfo.Colors.stimColor);
next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_fixation,expinfo.Fix_Duration);

% Clear Screen for ISI
Trial(expTrial).time_ISI1 = clearScreen(expinfo.window,expinfo.Colors.bgColor,next_flip);
next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_ISI1,expinfo.MinISIduration);

% Cue
if strcmp(Trial(expTrial).CueDirection,'left')
    Trial(expTrial).time_Cue = TextCenteredOnPos(expinfo.window,'<',0.5*expinfo.maxX,0.5*expinfo.maxY,expinfo.Colors.stimColor,next_flip);
else
    Trial(expTrial).time_Cue = TextCenteredOnPos(expinfo.window,'>',0.5*expinfo.maxX,0.5*expinfo.maxY,expinfo.Colors.stimColor,next_flip);
end
next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_Cue,expinfo.Fix_Duration);


% Clear Screen for ISI
Trial(expTrial).time_ISI2 = clearScreen(expinfo.window,expinfo.Colors.bgColor,next_flip);
next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_ISI2,expinfo.MinISIduration);


% display Probe Stimulus
if strcmp(Trial(expTrial).StimLocation,'left')
    Trial(expTrial).time_probe = TextCenteredOnPos(expinfo.window,Trial(expTrial).ProbeStim,0.45*expinfo.maxX,0.5*expinfo.maxY,expinfo.Colors.stimColor,next_flip);
else
    Trial(expTrial).time_probe = TextCenteredOnPos(expinfo.window,Trial(expTrial).ProbeStim,0.55*expinfo.maxX,0.5*expinfo.maxY,expinfo.Colors.stimColor,next_flip);
end
Trial = getresponse(expinfo, Trial, expTrial, Trial(expTrial).time_probe);

if isPractice == 1 % Show feedback in practice trials
    if Trial(expTrial).ACC == 1
        timestamp_FB = TextCenteredOnPos(expinfo.window,'RICHTIG',0.5*expinfo.maxX,0.5*expinfo.maxY,expinfo.Colors.green);
    elseif Trial(expTrial).ACC == 0
        timestamp_FB = TextCenteredOnPos(expinfo.window,'FALSCH',0.5*expinfo.maxX,0.5*expinfo.maxY,expinfo.Colors.red);
    elseif Trial(expTrial).ACC == -2
        timestamp_FB = TextCenteredOnPos(expinfo.window,'ZU LANGSAM',0.5*expinfo.maxX,0.5*expinfo.maxY,expinfo.Colors.stimColor);
    end
    next_flip = getAccurateFlip(expinfo.window,timestamp_FB,expinfo.FeedbackDuration);
end

% Clear Screen for ITI
Trial(expTrial).time_ITI1 = clearScreen(expinfo.window,expinfo.Colors.bgColor,next_flip);
next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_ITI1,expinfo.MinITIduration);

%% Recording Data
if isPractice == 1
    fid = fopen(expinfo.pracFile, 'a');
else
    fid = fopen(expinfo.expFile, 'a');
end

% Print general information into data file
fprintf(fid, '%3d %3d %4s ', expinfo.subject, Trial(expTrial).TrialNum, Trial(expTrial).Pause);
% Print stimuli and Response Properties into data file
fprintf (fid, '%1s %11s %7s ', Trial(expTrial).ProbeStim, Trial(expTrial).LocationCongruency, Trial(expTrial).CueValidity);
% Print Response information into data file
fprintf (fid, '%1d %1.4f %1s %1s ', Trial(expTrial).ACC, Trial(expTrial).RT, Trial(expTrial).response, Trial(expTrial).CorrResp{1});
% Print new Line after each Trial
fprintf (fid, '\n');

% Close file after information has been written into it
fclose (fid);

% Flip again after ITI is over
Trial(expTrial).time_ITI2 = clearScreen(expinfo.window,expinfo.Colors.bgColor,next_flip);

end

%% End of Function
% This function was programmed by Gidon T. Frischkorn, as part of a
% template for MATLAB experiments. If you have any questions please contact
% me via mail: gidon.frischkorn@psychologie.uni-heidelberg.de