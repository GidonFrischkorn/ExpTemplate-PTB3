% This function loads all settings for the experiment

function expinfo = ExpSettings(expinfo)
%% Get Date an time for this session
expinfo.DateTime = datetime('now');

expinfo.DateTime.Format = 'dd-MMM-yyyy';
expinfo.Date = cellstr(expinfo.DateTime);
expinfo.Date = expinfo.Date{1};

expinfo.DateTime.Format = 'hh:mm:ss';
expinfo.Time = cellstr(expinfo.DateTime);
expinfo.Time = expinfo.Time{1};

%% Specify Stimulus and Text properties (Size, Position, etc.)
expinfo.stimulussize = 40; % in Pixel bzw. Point
expinfo.BoxSize = [0 0 0.05*expinfo.maxX 0.05*expinfo.maxY]; % Box-size with 5% of screen size

%% Secify number of general instruction slides
expinfo.InstStop = 6;

%% Timing - fixed in all trials
expinfo.Fix_Duration=0.3; % Dauer des Fixationskreuzes zu Beginn eines Trials

expinfo.MinISIduration = 0.4; % Minimale Dauer des Inter-Stimulus-Intervalls (ISI)
expinfo.ISIjitter = 0.2; % ISI Jitter = Intervall in dem das ISI variieren darf

expinfo.MaxRT = 3; % Maximal erlaubte Reaktionszeit bei einer Abfrage

expinfo.MinITIduration =1; % Minimale Dauer des Inter-Trial-Intervalls (ITI)
expinfo.ITIjitter =0.5; %ITI Jitter

expinfo.FeedbackDuration = 0.8;

%% Experimental Manipulations
expinfo.LocationCon = {'congruent' 'incongruent'};
expinfo.LocConFactor = 1:length(expinfo.LocationCon);

expinfo.CueCondition = {'valid' 'invalid'};
expinfo.CueCondFactor = 1:length(expinfo.CueCondition);

%% Specify Stimuli to be shown
expinfo.Stimuli = {'R' 'L'};
expinfo.StimFactor = 1:length(expinfo.Stimuli);

%% Specify Response Keys used in the experiment
expinfo.LeftKey = 'LeftArrow';
expinfo.RightKey = 'RightArrow';
expinfo.AbortKey = 'F12';
expinfo.RespKeys = {'d' 'l'};
expinfo.ResponseMapping = [2 1];

% Example: Balance response mapping across participants
% if mod(expinfo.subject,2) == 0
%     expinfo.ResponseMapping = [1 2];
%     else
%     expinfo.ResponseMapping = [2 1];
% end

%% Defining trials to be conducted
% Specify how many practice trials should be conducted
expinfo.nPracTrials = 10;

% Specify how many Trials in each cell of the experimental design should be
% conducted
expinfo.Trial2Cond = 10;

% get Trial Configurations of all experimental conditions
[StimList, LocationConList, CueConList] = BalanceFactors(expinfo.Trial2Cond, 0,expinfo.StimFactor, expinfo.LocConFactor, expinfo.CueCondFactor);
expinfo.TrialConfigurations = horzcat(StimList, LocationConList, CueConList);

% Number of total Trials to be conducted
expinfo.nExpTrials = size(expinfo.TrialConfigurations,1);

% Specify after how many trials in the experimental blocks there will be a
% break
expinfo.Trials2Pause = floor(expinfo.nExpTrials*0.20);

% Specify how trial lists should be generated. Options are:
    % FullRandom = fully randomized without any conditions
    % ConRandom = conditionally randomized, with individually programmend
    % conditions -> see MakeTrial.m
    % AsIs = not randomized, not recommended
expinfo.ListGen = 'ConRandom';

%% Colors
if mean(expinfo.Colors.bgColor) ~= 0
    expinfo.Colors.textColor = expinfo.Colors.black;
    expinfo.Colors.stimColor = expinfo.Colors.black;
else
    expinfo.Colors.textColor = expinfo.Colors.white;
    expinfo.Colors.stimColor = expinfo.Colors.white;
end

%% Fonts
expinfo.Fonts.textFont  = expinfo.Fonts.sansSerifFont;

%% Specify Instruction folder
expinfo.InstFolder      = 'Instructions/';
expinfo.InstExtension   = '.JPG';
expinfo.DataFolder      = 'DataFiles/';

%% datafiles and messages
pracFile = 'prac.txt'; % extension for the practice trial data
expFile  = 'exp.txt';  % extension fot the expreimental trial data

% Adjusting the file-names to a different name for each subject
expinfo.pracFile = [expinfo.DataFolder,expinfo.taskName,'_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),pracFile];
expinfo.expFile  = [expinfo.DataFolder,expinfo.taskName,'_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),expFile];

%% End of Function
% This function was programmed by Gidon T. Frischkorn, as part of a
% template for MATLAB experiments. If you have any questions please contact
% me via mail: gidon.frischkorn@psychologie.uni-heidelberg.de
