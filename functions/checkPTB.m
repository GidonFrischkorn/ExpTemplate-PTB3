% Check wether PTB is installed and save PTB infos to the expinfo object

function checkPTB

ptbInfo = PsychtoolboxVersion;  %if ptb not installed, error will be trapped
if ischar(ptbInfo)
    PTBversion = str2double(ptbInfo(1)); 
end

ptb3 = (PTBversion >= 3);

%% End of Function
% This function was programmed by Gidon T. Frischkorn, as part of a
% template for MATLAB experiments. If you have any questions please contact
% me via mail: gidon.frischkorn@psychologie.uni-heidelberg.de