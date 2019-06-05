% This function generates a trial list from the specified Trial
% configurations in the expinfo. Alternatively, we can specify the Trial
% configurations here if there is more complex things to do...

function [Trial] = MakeTrial(expinfo, isPractice)
%% Trial Configurations
% First, we need to obtain the trial configurations crossing all
% experimental conditions
TrialConfigurations = expinfo.TrialConfigurations;

%% Resort Trial Configurations
% Second, we need to randomly sort the trial configuration for a trial list

% Specify the number of trials to be drawn
if isPractice == 1
    nTrials = expinfo.nPracTrials;
else
    nTrials = expinfo.nExpTrials;
end

if strcmp(expinfo.ListGen,'AsIs') % Take Trial Configurations as they are
    TrialMatrix = TrialConfigurations(1:nTrials,:);
elseif strcmp(expinfo.ListGen,'FullRandom') % Fully random trial list
    TrialMatrix = TrialConfigurations(randsample(size(TrialConfigurations,1),nTrials),:);
elseif strcmp(expinfo.ListGen,'ConRandom') % Curated random trial list
    trialsSelected = 0;
    maxIter = 1000; % Specify maximum number of allowed iterations
    while trialsSelected ~= nTrials
        trialsSelected = 0;
        TrialMatrix = zeros(nTrials,size(TrialConfigurations,2));
        SampleMatrix = TrialConfigurations;
        for trial = 1:nTrials
            test = 0; % Logical variable indicating whether we may use the trial
            iter = 0; % Reset iteration variable
            
            while test == 0 % Repeat as long as no valid trial is found
                RandRow = randsample(size(SampleMatrix,1),1);
                
                if trial == 1
                    test = 1;
                elseif trial < 4
                    % Probe Stim should not repeat
                    if SampleMatrix(RandRow,1) ~= TrialMatrix(trial-1,1)
                        test = 1;
                    else
                        test = 0;
                    end
                else
                    % Probe Stim should not repeat more than two times
                    if SampleMatrix(RandRow,1) ~= TrialMatrix(trial-1,1) || ...
                            SampleMatrix(RandRow,1) ~= TrialMatrix(trial-2,1)
                        StimTest = 1;
                    else
                        StimTest = 0;
                    end
                    
                    % Location should not repeat more than two times
                    if SampleMatrix(RandRow,2) ~= TrialMatrix(trial-1,2) || ...
                            SampleMatrix(RandRow,2) ~= TrialMatrix(trial-2,2)
                        LocationTest = 1;
                    else
                        LocationTest = 0;
                    end
                    
                    % Cue Validity should not repeat more than two times
                    if SampleMatrix(RandRow,3) ~= TrialMatrix(trial-1,3) || ...
                            SampleMatrix(RandRow,3) ~= TrialMatrix(trial-2,3)
                        CueTest = 1;
                    else
                        CueTest = 0;
                    end
                    
                    if StimTest == 1 && LocationTest == 1 && CueTest == 1
                        test = 1;
                    else
                        test = 0;
                    end
                    
                    % Count Iterations & break if no trial meets conditions after
                    % maxIter
                    iter = iter + 1;
                    if iter > maxIter
                        break
                    end
                end
            end
            
            if test == 1 % A valid trial was found
                % Write random trial from sample matrix to current row
                % of the trial matrix
                TrialMatrix(trial,:) = SampleMatrix(RandRow,:);
                
                % Delete selected trial from sample matrix
                SampleMatrix(RandRow,:) = [];
                trialsSelected = trialsSelected +1;
            else % No valid trial found in the maximum number of allowed iterations
                % Break and start all over again
                break
            end
        end
    end
end

%% Determine additional Information for each Trial
% Third and final, we need to specify all necessary information from the
% Trial Matrix
for trial = 1:nTrials
    % Speichern der TrialNummer
    Trial(trial).TrialNum = trial;
    
    % Code whether trial is pre or post break
    if mod(trial,expinfo.Trials2Pause) == 0
        Trial(trial).Pause = 'pre';
    elseif mod(trial,expinfo.Trials2Pause) == 1 && trial ~= 1
        Trial(trial).Pause = 'post';
    else
        Trial(trial).Pause = 'no';
    end
    
    % Code experimental manipulations within trial
    Trial(trial).ProbeStim = expinfo.Stimuli{TrialMatrix(trial,1)};
    Trial(trial).LocationCongruency = expinfo.LocationCon{TrialMatrix(trial,2)};
    Trial(trial).CueValidity = expinfo.CueCondition{TrialMatrix(trial,3)};
    
    % Code Correct response
    Trial(trial).CorrResp = expinfo.RespKeys(expinfo.ResponseMapping == TrialMatrix(trial,1));
    if strcmp(Trial(trial).CorrResp,'d')
        Trial(trial).RespLocation = 'left';
    else
        Trial(trial).RespLocation = 'right';
    end
    
    % Code stimulus location
    if strcmp(Trial(trial).LocationCongruency,'congruent')
        Trial(trial).StimLocation = Trial(trial).RespLocation;
    else
        if strcmp(Trial(trial).RespLocation,'left')
            Trial(trial).StimLocation = 'right';
        else
            Trial(trial).StimLocation = 'left';
        end
    end
    
    % Specify the cue direction dependend on the Cue Validity
    if strcmp(Trial(trial).CueValidity,'valid')
        Trial(trial).CueDirection = Trial(trial).StimLocation;
    else
        if strcmp(Trial(trial).StimLocation,'left')
            Trial(trial).CueDirection = 'right';
        else
            Trial(trial).CueDirection = 'left';
        end
    end
    
    % Initialise the response variables
    Trial(trial).response = 0;
    Trial(trial).ACC = -9;
    Trial(trial).RT = -9;
end

% Now we have a MATLAB Structure with as many fields as trials and the
% different variables contain all relevant information of the trials.
end
%% End of Function
% This function was programmed by Gidon T. Frischkorn, as part of a
% template for MATLAB experiments. If you have any questions please contact
% me via mail: gidon.frischkorn@psychologie.uni-heidelberg.de
