%% Name of the experiment %%
% It is good practice to give a short desctiption of your experiment

clear all; % Start the experiment with empty workspace
clc; % Clear command window
    
%% Enter Subject & Session ID + further Info if needed %%
expinfo.taskName = 'SimonExample';
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%% ' expinfo.taskName ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']);

% Specify subject ID
expinfo.subject = input('Enter participant number: ');

% Specify session ID
expinfo.session = input('Enter session number: '); 

% Switch on test mode. This opens up a smaller PTB window, so that you can
% exit the PTB window and see whether an error occurs in your code
testExp = input('Is this a test run (0 = no, 1 = yes): ');

% You can request further information here, if needed. 
expinfo.showPractice = 1;

%% Allgemeine Einstellungen & Start von PTB %%
% Add folders to MATLAB to access functions, instruction slides, and
% location for data backup
addpath('functions', 'Instructions', 'DataFiles');

% Setting a seed for randomization ensures that you can reproduce
% randomized variables for each subject and session id.
expinfo.mySeed = 100 * expinfo.subject+ expinfo.session;
rng(expinfo.mySeed);

% Check wether PTB is installed
% checkPTB(); % no longer necessary because implemented in the startPTB function

% Open PTB windown
expinfo = startPTB(expinfo,testExp); 

% Read in Exp Settings. This is only to keep your wrapper code tidy and
% structured. All Settings for the Experiment should be specified in this
% funtion. Rarely you will perform complex programming in this function.
% Rather you will define variables or experimental factors, etc.
expinfo = ExpSettings(expinfo); 

% Set priority for PTB processes to ensure best possible timing
topPriorityLevel = MaxPriority(expinfo.window);
Priority(topPriorityLevel);

%% General Instructions

% This is a loop running through the general instruction slides allowing to
% move back and forth within these slides. As soon as the last slide is
% finished you cannot move back.

InstSlide = 1; % Start with the first slide
while InstSlide <= expinfo.InstStop % Loop until last slide of general instruction
    % Paste the FileName for the Instrcution Slide depending on the current
    % slide to be displayed
    Instruction=[expinfo.InstFolder 'Slide' num2str(InstSlide) expinfo.InstExtension];
    ima=imread(Instruction); % Read in the File
    
    % Put the File on the PTB window
    InstScreen = Screen('MakeTexture',expinfo.window,ima);
    Screen('DrawTexture', expinfo.window, InstScreen); % draw the scene
    Screen('Flip', expinfo.window);
    WaitSecs(0.3);
    
    % Wait for a key press of the right or left key to navigate back an
    % forth within the instructions
    if InstSlide == 1
        [ForwardBackward] = BackOrNext(expinfo,1);
    else
        [ForwardBackward] = BackOrNext(expinfo,0);
    end
    InstSlide = InstSlide + ForwardBackward;
end

% clean up no longer relevant variables after the instrction to keep the
% workspace tidy
clearvars Instruction ima InstSlide
clearScreen(expinfo.window,expinfo.Colors.bgColor);
WaitSecs(0.1);

%% PracticeBlock
if expinfo.showPractice == 1
    isPractice = 1; % Local variable specifying that we are running practice trials
    
    % Generate a TrialList for the Practice Trials
    PracticeTrials = MakeTrial(expinfo, isPractice);
    
    % Usually an additional instruction slide is displayed before the practice
    % trials
    PracStart=[expinfo.InstFolder 'PracStart.jpg'];
    ima=imread(PracStart, 'jpg');
    dImageWait(expinfo,ima);
    
    % Show PracticeTrials
    for pracTrial = 1:expinfo.nPracTrials % Loop through the practice trials
        PracticeTrials = DisplayTrial(expinfo, PracticeTrials, pracTrial, isPractice);
    end
end

%% ExpBlock
isPractice = 0; % Local variable specifying that we are running practice trials

% Generate a TrialList for the experimental trials
ExpTrials = MakeTrial(expinfo,isPractice); % function that sets up the trial

% Similarly like before the practice trials, there usually is one
% instruction slide before the experimental trials start.
ExpStart=[expinfo.InstFolder 'ExpStart.jpg'];
ima=imread(ExpStart, 'jpg');
dImageWait(expinfo,ima);
    
%Show Shifting Trials
for expTrial = 1:expinfo.nExpTrials % Loop durch alle Experimental-Trials
    ExpTrials = DisplayTrial(expinfo, ExpTrials, expTrial, isPractice);
    
    % Show pause screen after the pre-defined number of trials
    if mod(expTrial,expinfo.Trials2Pause) == 0
        Pause=[expinfo.InstFolder 'Break.jpg'];
        ima=imread(Pause, 'jpg');
        dImageWait(expinfo,ima);
    end
end

% Save all information: i.e. the trial objects, and the expinfo structure.
% This ensures that all information used within the experiment can be
% accsessed later
BackUp_PracTrial = [expinfo.DataFolder,expinfo.taskName,'_PracTrials_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session)];
BackUp_Trial     = [expinfo.DataFolder,expinfo.taskName,'_Trials_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session)];
BackUp_ExpInfo   = [expinfo.DataFolder,expinfo.taskName,'_ExpInfo_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session)];
save(BackUp_PracTrial,'PracticeTrials');
save(BackUp_Trial,'ExpTrials');
save(BackUp_ExpInfo,'expinfo');

%% End Experiment

% Display one final slide telling the participant that the experiment is
% finished.
EndExp=[expinfo.InstFolder 'ExpEnd.jpg'];
ima=imread(EndExp, 'jpg');
dImageWait(expinfo,ima);

Priority(0); % Reset priority to low level
closeexp(expinfo.window); % Close the experiment

%% End of Script
% This script was programmed by Gidon T. Frischkorn, as part of a
% template for MATLAB experiments. If you have any questions please contact
% me via mail: gidon.frischkorn@psychologie.uni-heidelberg.de