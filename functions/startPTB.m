% Open PTB window and specify some basic settings

function expinfo = startPTB(expinfo, testExp)
%% General Settings
% Check whether PTB is installed, if not error will occur and the
% experiment will stop
expinfo.ptbInfo = PsychtoolboxVersion;

% Unify KeyNames and set range of color space betwenn 0 and 1
PsychDefaultSetup(2);
KbName('UnifyKeyNames');

% Save the PTB version to the expinfo structure
if ischar(expinfo.ptbInfo)
    expinfo.PTBversion = str2double(expinfo.ptbInfo(1));
end

% Check wether PTB3 is installed
expinfo.ptb3 = (expinfo.PTBversion >= 3);

% Cursor needed for experiment
expinfo.Cursor = 0;

% Set Background color if not already defined
if ~exist('expinfo.Colors.bgColor','var')
    expinfo.Colors.bgColor = [255 255 255]; % Default Background Color is white
end

% Specify if this is a test rund if not provided as input
if ~exist('test','var') || isempty(expinfo)
    testExp = 0;
end

% Suppres output of warnings
Screen('Preference', 'Verbosity', 0);
Screen('Preference','SuppressAllWarnings', 1);

% Suppres output of keyboard to MATLAB: to switch this back on hit: CRTL+C
ListenChar(2);

% Set CutOff Values for SyncTests - SD set to 5 ms, 50 samples, 15 percent
% deviation allowed, and max 5 secs for SyncTests - useful in setups with a
% little noisier timing
Screen('Preference','SyncTestSettings' , 0.05, 50, 0.15, 5);

if testExp % testRun
    % SyncTestSettings
    Screen('Preference','SkipSyncTests', 1); % switched off
else
    % SyncTestSettings
    Screen('Preference','SkipSyncTests', 0); % switched on
end

%% Open Psychtoolbox window
if testExp % test run
    testWindow = [100 100 700 500];
    expinfo.numScreens=Screen('Screens');
    if max(expinfo.numScreens) > 1 % More than one screen on the setup
        expinfo.ScreenNum = 1;
        % Open test window with the specified background color
        % on the screen with screen Num = 1
        [expinfo.window, expinfo.rect] = Screen('OpenWindow',expinfo.ScreenNum,expinfo.Colors.bgColor, testWindow);
    else
        expinfo.ScreenNum = 0;
        % Open test window on the installed screen with the
        % specified background color
        [expinfo.window, expinfo.rect] = Screen('OpenWindow',expinfo.ScreenNum,expinfo.Colors.bgColor, testWindow);
    end
else 
    expinfo.numScreens=Screen('Screens');
    if max(expinfo.numScreens) > 1 % More than one screen on the setup
        expinfo.ScreenNum = 1;
        % Open Full Screen window with the specified background color
        % on the screen with screen Num = 1
        [expinfo.window, expinfo.rect] = Screen('OpenWindow',expinfo.ScreenNum,expinfo.Colors.bgColor);
    else
        expinfo.ScreenNum = 0;
        % Open Full Screen window on the installed screen with the
        % specified background color
        [expinfo.window, expinfo.rect] = Screen('OpenWindow',expinfo.ScreenNum,expinfo.Colors.bgColor);
    end
end

%% Read basic infos and save to expinfo
% Get maximal and center pixels for X and Y axis of the PTB window
expinfo.maxX = expinfo.rect(RectRight) - expinfo.rect(RectLeft);
expinfo.maxY = expinfo.rect(RectBottom) - expinfo.rect(RectTop);
[expinfo.centerX, expinfo.centerY] = RectCenter(expinfo.rect);

% Get basic infos about the screen and monitor
expinfo.ifi = Screen('GetFlipInterval', expinfo.window);
expinfo.FrameRate = FrameRate(expinfo.window);
expinfo.NominalFrameRate = Screen('NominalFrameRate', expinfo.window);
[expinfo.displayWidth, expinfo.displayHeight] = Screen('DisplaySize', expinfo.ScreenNum);
expinfo.maxLum = Screen('ColorRange', expinfo.window);

%% Hide cursor for usual experiments
% if cursor input is needed switch back on
if testExp
    if expinfo.Cursor == 0
        HideCursor;
    else
        ShowCursor(0);	% arrow cursor
    end
else
   if expinfo.Cursor == 0
        HideCursor;
    else
        ShowCursor(0);	% arrow cursor
    end 
end

%% Code colors used within the experiment
expinfo.Colors.white = WhiteIndex(expinfo.window);
expinfo.Colors.black = BlackIndex(expinfo.window);
expinfo.Colors.grey  = floor((expinfo.Colors.white+expinfo.Colors.black)/2);
expinfo.Colors.red=[255 0 0];
expinfo.Colors.blue=[0 0 255];
expinfo.Colors.green=[0 255 0];

%% Choose fonts likely to be installed on this platform
switch computer
    case 'MAC2'
        expinfo.Fonts.serifFont = 'Bookman';
        expinfo.Fonts.sansSerifFont = 'Arial'; % or Helvetica
        expinfo.Fonts.symbolFont = 'Symbol';
        expinfo.Fonts.displayFont = 'Impact';
    case 'MACI64'
        expinfo.Fonts.serifFont = 'Bookman';
        expinfo.Fonts.sansSerifFont = 'Arial'; % or Helvetica
        expinfo.Fonts.symbolFont = 'Symbol';
        expinfo.Fonts.displayFont = 'Impact';
    case 'PCWIN64'
        expinfo.Fonts.serifFont = 'Bookman Old Style';
        expinfo.Fonts.sansSerifFont = 'Arial';
        expinfo.Fonts.symbolFont = 'Symbol';
        expinfo.Fonts.displayFont = 'Impact';
    case 'PCWIN'
        expinfo.Fonts.serifFont = 'Bookman Old Style';
        expinfo.Fonts.sansSerifFont = 'Arial';
        expinfo.Fonts.symbolFont = 'Symbol';
        expinfo.Fonts.displayFont = 'Impact';
    otherwise
        error(['Unsupported OS: ' computer]);
end

%% End of Function
% This function was programmed by Gidon T. Frischkorn, as part of a
% template for MATLAB experiments. If you have any questions please contact
% me via mail: gidon.frischkorn@psychologie.uni-heidelberg.de