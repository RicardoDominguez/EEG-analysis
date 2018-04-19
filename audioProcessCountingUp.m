% Analyze audio of a person counting out loud during the experiment in
% order to obtain word frequency per minute and number of error while
% counting

%% ------------------------------------------------------------------------
% Options you may want to change
% -------------------------------------------------------------------------
experiment_name = 'wordcounter';
save_folder = 'Audio/Processed/';

%% -------------------------------------------------------------------------
% Set key presses associated with each action
disp 'Start';   start = returnkeypress();
disp 'Word';    word = returnkeypress();
disp 'Error';   error = returnkeypress();
disp 'End';     exit = returnkeypress();

% Record data as inputted by user
in = -1; % Key pressed value will be stored here
disp '-----------';
while(in ~= exit)
    in = returnkeypress();
    if in == start % Start timer and reset data variables
        tic; disp 'Tic'
        words = []; % Store the time stamp of each word
        nerrors = 0; % Numer of errors recorded
    elseif in == word
        disp 'Toc'
        elaps = toc; words = [words, toc]; % Store time of word
    elseif in == error
        disp 'Err'
        nerrors = nerrors + 1; % Add 1 error
    end
end

% Print for verification purposes
fprintf("Number of words counted: %d\n", length(words));
fprintf("Numer of errors: %d\n", nerrors)

% Compute parameters
time_between_words = diff(words);
avg_time = mean(time_between_words);
sigma_time = std(time_between_words);
avg_freq = 1/avg_time*60;

% Save all data
mkdir(save_folder); % Create folder for output text files
save([save_folder, experiment_name, '.mat'], 'words', 'nerrors', 'avg_time', 'sigma_time', 'avg_freq')

%% ------------------------------------------------------------------------
% Function used to return the value of a key press
% -------------------------------------------------------------------------
function in = returnkeypress()
   k = waitforbuttonpress;
   in = double(get(gcf,'CurrentCharacter'));
end
