% Clear workspace and command window
clc;
clear;

KbName('UnifyKeyNames'); % Unify key names for cross-platform compatibility

% User Input
subject_name = input('Please enter your name: ', 's');
subject_ID = input('Please enter the Subject ID: ', 's');
step_number = input('Please enter the step number (1 or 2): ');

if step_number == 1
    starts_block = 0;
    blocks_number = 3;
elseif step_number == 2
    starts_block = 4;
    blocks_number = 2;
else
    error('Invalid step number. Must be 1 or 2.');
end

subjects_blocks = starts_block:(starts_block + blocks_number);

%  Directory Setup
base_path = '/Users/alimotahharynia/Desktop/Checkerboard/';
images_path = fullfile(base_path, 'images');
code_path = fullfile(base_path, 'code');
results_path = fullfile(base_path, 'Results Data');

% Colors and Display Parameters
red = [255 0 0];
yellow = [255 255 0];
white = [255 255 255];
gray = [127 127 127];
dark_gray = [80 80 80];
black = [0 0 0];
green = [0 255 0];
blue = [0 0 255];

square_size = 4; % Size of squares in grid
square_border = 15; % Border diameter
color_balance = 6; % Number of squares with a specific color
sq_swap = 1; % Number of squares to swap colors
bkColor = black; % Background color
d_color = black(1); % border color
p = red; % square color
q = yellow; % square color
c_balacne = (color_balance:1:(square_size^2 - color_balance));
square_traits = [square_size, square_border, c_balacne(1), c_balacne(numel(c_balacne))];

% Cue and Display Parameters
cue_size = 150;
response_circle_size = 30;
fixation_point_size = 4;
x_start_1_m_pos = 175; % position from center
x_end_2_m_pos = 175; % position from center

% Psychtoolbox Iitialization
AssertOpenGL;
screens = Screen('Screens');
screenNumber = max(screens);
Screen('Preference', 'SkipSyncTests', 0); % Skip sync tests for debugging

[window, rect] = Screen('OpenWindow', screenNumber, bkColor);
[centerX, centerY] = RectCenter(rect);

try
    for block = subjects_blocks
        % Block Settings
        if block == 0 % Training block
            number_of_trial = 10;
            block = 100;
        else
            number_of_trial = 30;
        end
        
        % Preallocate Data Storage
        start_date_time = NaN(1,6, number_of_trial);
        daylight_saving_time = NaN(number_of_trial, 1);
        reaction_time = NaN(number_of_trial, 1);
        subject_performance = NaN(number_of_trial, 1);
        selected_key = NaN(number_of_trial, 1);
        same_square_data = NaN(square_size, square_size, 3, number_of_trial);
        different_square_data = NaN(square_size, square_size, 3, number_of_trial);
        time_of_delay = NaN(number_of_trial, 1);
        same_location = NaN(number_of_trial, 1);
        different_location =  NaN(number_of_trial, 1);
        end_date_time = NaN(1,6, number_of_trial);
        
        % Display Start Screen
        HideCursor;
        cd(images_path);
        start_img = imread('start.png');
        start_texture = Screen('MakeTexture', window, start_img);
        Screen('DrawTexture', window, start_texture, [], ...
            [centerX - centerX/2-150, centerY - 400, centerX + centerX/2+150, centerY + 400], 0);
        Screen('Flip', window);
        cd(code_path);

        % Wait for Key Press to Start
        kb_wait = 0;
        while kb_wait ~= KbName('space')
            [wait_key_down, ~, wait_key_code] = KbCheck;
            
            if (wait_key_down)
                
                kb_wait = find(wait_key_code, 1);
            end
        end
      
        fixation_rect = [centerX - fixation_point_size, centerY - fixation_point_size, ...
                centerX + fixation_point_size, centerY + fixation_point_size];
        
        % Defining the response circle
        responseCircle_rect = [centerX-response_circle_size, centerY-response_circle_size...
            centerX+response_circle_size, centerY+response_circle_size];
        
        % Define delay-time and shapes-position
        rng shuffle
        if block == 100
            
        delay_time = [repmat(0.5, 1, number_of_trial/5), repmat(0.5, 1, number_of_trial/5)...
             repmat(0.5, 1, number_of_trial/5), repmat(0.5, 1, number_of_trial/5), repmat(0.5, 1, number_of_trial/5)]; 
        else
            
         delay_time = [repmat(0.5, 1, number_of_trial/5), ones(1, number_of_trial/5)...
              repmat(2, 1, number_of_trial/5), repmat(4, 1, number_of_trial/5), repmat(8, 1, number_of_trial/5)]; 
        end
        
        pos_dist = [ones(1, number_of_trial/(5*2)), repmat(2, 1, number_of_trial/(5*2))];
        shape_position = repmat(pos_dist, 1, 5);
        
        % Random generator for delay-time and shape-position selection
        c = randperm(number_of_trial);
        
        % Setting the background color
        Screen('FillRect', window, bkColor);
        
        % Changing the background color
        Screen('Flip', window)
        
        % Press any key to continue
        % load question image
        cd(images_path)
        continue_1 = imread('continue_1.png');
        continue_texture = Screen('MakeTexture', window, continue_1);
        Screen('DrawTexture', window, continue_texture, [], [centerX-centerX/2-150, centerY-400,...
            centerX+centerX/2+150, centerY+400]);
        
        cd(code_path)
        Screen('Flip', window) % Changing screen buffer
        
        % Press space to continue
        kb_wait = 0;
        while kb_wait ~= KbName('space')
            [wait_key_down, ~, wait_key_code] = KbCheck;
            
            if (wait_key_down)
                
                kb_wait = find(wait_key_code, 1);
            end
        end
        
        Screen('Flip', window) % Changing screen buffer
        WaitSecs(2);
        [s_d_t, dst] = clock; % date and time of the task
        
        % starting the Trials
        for trialCounter = 1:number_of_trial
            
            % saving the date and time of the block and daylight saving time
            start_date_time(:,:,trialCounter) = s_d_t;
            daylight_saving_time(trialCounter) = dst;
            
            % calling squares color
            [sqColor1, sqColor2] = randomColor(square_size, c_balacne, sq_swap, p, q);
            
            % Same square information
            Square1 = sampleSquare(subject_ID, block, trialCounter,...
                sqColor1, square_size, square_border, base_path, code_path, d_color);
            define_same_square = Screen('MakeTexture', window, Square1);
            
            % different square information
            Square2 = differentSquare(subject_ID, block, trialCounter,...
                sqColor2, square_size, square_border, base_path, code_path, d_color);
            define_different_square = Screen('MakeTexture', window, Square2);
            
            % save the pattern of square_Color
            same_square_data(:, :, :, trialCounter) = sqColor1;
            different_square_data(:, :, :, trialCounter) = sqColor2;
            
            % fixation point
            Screen ('FillOval',window, white, fixation_rect);
            Screen('Flip', window)
            
            WaitSecs(1.5); % fixation point presentation
            
            % Showing the same square
            Screen('DrawTexture', window, define_same_square,[],...
                [centerX - cue_size/2, centerY - cue_size/2,...
                centerX + cue_size/2, centerY + cue_size/2] );
            Screen('Flip', window);
            
            WaitSecs(0.4); % square presentation
            
            % fixation point
            Screen ('FillOval',window, white, fixation_rect);
            Screen('Flip', window)
            
            % delay time
            % random delay time generator
            delay_Time = delay_time(c(trialCounter));
            WaitSecs(delay_Time);
            time_of_delay(trialCounter) = delay_Time;
            
            % random shape position generator and presentation
            if shape_position(c(trialCounter)) == 1
                Screen('DrawTexture', window, define_same_square,[],...
                    [centerX - x_start_1_m_pos, centerY - cue_size/2,...
                    centerX-(x_start_1_m_pos - cue_size), centerY + cue_size/2] );
                
                Screen('DrawTexture', window, define_different_square,[],...
                    [centerX+(x_end_2_m_pos - cue_size), centerY - cue_size/2,...
                    centerX + x_end_2_m_pos, centerY + cue_size/2]);
                
                B = KbName('LeftArrow');
                square1_location = 2; % left
                square2_location = 1;
            else
                Screen('DrawTexture', window, define_different_square,[],...
                    [centerX - x_start_1_m_pos, centerY - cue_size/2,...
                    centerX-(x_start_1_m_pos - cue_size), centerY + cue_size/2]);
                
                Screen('DrawTexture', window, define_same_square,[],...
                    [centerX + (x_end_2_m_pos - cue_size), centerY - cue_size/2,...
                    centerX + x_end_2_m_pos, centerY + cue_size/2]);
                
                B = KbName('RightArrow');
                square1_location = 1;
                square2_location = 2;
            end
            
            % square location recorder
            same_location(trialCounter) = square1_location ;
            different_location(trialCounter) = square2_location ;
            
            Screen('Flip', window) % same and different buffer presentation
            start_time = GetSecs;
            
            % time limit for presentation
            time = 0;
            while time < 4
                % reaction time
                [keyIsDown, responseTime, keyCode] = KbCheck;
                time = responseTime - start_time;
                
                if (keyIsDown)
                    selected_key(trialCounter) = find(keyCode, 1);
                    
                    %  getting left or right key
                    if selected_key(trialCounter) == KbName('RightArrow') || selected_key(trialCounter) == KbName('LeftArrow')
                        reaction_time(trialCounter) = time;
                        
                        % correct response feedback
                        if B == KbName('LeftArrow') && selected_key(trialCounter) == KbName('LeftArrow')
                            subject_performance(trialCounter) = 1;
                            Screen ('FillOval',window, green, responseCircle_rect);
                            Screen('Flip', window)
                            WaitSecs(1); % feedback time
                            
                        % wrong response feedback
                        elseif B == KbName('LeftArrow') && selected_key(trialCounter) == KbName('RightArrow')
                            subject_performance(trialCounter) = 0;
                            
                            Screen ('FillOval',window, red, responseCircle_rect);
                            Screen('Flip', window)
                            WaitSecs(1);
                            
                        % correct response feedback
                        elseif B == KbName('RightArrow')  && KbName('RightArrow') == selected_key(trialCounter)
                            subject_performance(trialCounter) = 1;
                            
                            Screen ('FillOval',window, green, responseCircle_rect);
                            Screen('Flip', window)
                            WaitSecs(1);
                            
                        % wrong response feedback
                        elseif B == KbName('RightArrow') && KbName('LeftArrow') == selected_key(trialCounter)
                            subject_performance(trialCounter) = 0;
                            
                            Screen ('FillOval',window, red, responseCircle_rect);
                            Screen('Flip', window)
                            WaitSecs(1);
                        end
                        
                        break;
                    end
                end
                
                % terminate the task at will in any time
                [~, ~, escape_key] = KbCheck;
                if escape_key(KbName('q')) == 1 % terminate suddenly, nothing will be saved
                    Screen('Close', window);
                    Screen('CloseAll');
                    
                    Priority(0);
                    sca;
                    ShowCursor;
                elseif escape_key(KbName('escape')) == 1 % data will be saved but take a little longer
                    
                    break
                end
            end
            
            % no response feedback
            if  isnan(subject_performance(trialCounter))
                reaction_time(trialCounter) = NaN;
                selected_key(trialCounter) = NaN;
                Screen ('FillOval',window, blue, responseCircle_rect);
                Screen('Flip', window)
                WaitSecs(1);
            end

            if escape_key(KbName('escape')) == 1
                % terminate the task
                break
            end
            
            % Setting the background color
            Screen('FillRect', window, bkColor);
            Screen('Flip', window)
            WaitSecs(1);
        end
        
        % date and time at the end of the block
        [e_d_t] = clock;
        end_date_time(:,:,block) = e_d_t;
        
        % left = 2 & right = 1
        for substitution = 1:number_of_trial
            if selected_key(substitution) == KbName('RightArrow')
                selected_key(substitution) = 1;
            elseif selected_key(substitution) == KbName('LeftArrow')
                selected_key(substitution) = 2;
            end
        end
        
        Screen('FillRect', window, bkColor);
        
        % Press any key to continue
        cd(images_path)
        continue_2 = imread('continue_2.png');
        continue_2Texture = Screen('MakeTexture', window, continue_2);
        Screen('DrawTexture', window, continue_2Texture, [], [centerX-centerX/2-150, centerY-400,...
            centerX+centerX/2+150, centerY+400], 0);
        cd(code_path)
        
        Screen('Flip', window)
        
        % Press space to continue
        kb_wait = 0;
        while kb_wait ~= KbName('space')
            [wait_key_down, ~, wait_key_code] = KbCheck;
            
            if (wait_key_down)
                
                kb_wait = find(wait_key_code, 1);
            end
        end
        
        % setting the background color
        Screen('FillRect', window, bkColor);
        
        for filling = 1:number_of_trial
            
            end_date_time(1,1:6,filling) = end_date_time(:,:,block);
        end
        
        % save data
        subject_Folder = fullfile(append('Subject',' ',subject_ID));
        mr_directory = append(base_path,'/Results Data/',subject_Folder);
        mkdir (mr_directory);
        save_results = fullfile(append(base_path,'/Results Data/',subject_Folder));
        cd(save_results)
        
        % convert results to structure
        results.performance = subject_performance;
        results.reaction_time = reaction_time;
        results.time_of_delay =  time_of_delay;
        results.key_response = selected_key;
        results.same_pattern = same_square_data;
        results.different_pattern = different_square_data;
        results.same_location = same_location;
        results.different_location = different_location;
        results.start_blocks_date = start_date_time;
        results.end_blocks_date = end_date_time;
        results.daylight_saving_time = daylight_saving_time;
        results.subject_name = subject_name;

        % create sub-folder for subjects data
        data_folder = fullfile(append('Subject',' ',subject_ID),...
            append('Block',' ',num2str(block)),'Data');
        
        m_s_r_directory = append(base_path,'/Results Data/',data_folder);
        mkdir (m_s_r_directory);
        
        save_s_path = fullfile(append(base_path,'/Results Data/',data_folder));
        cd (save_s_path)
        blocks_data = append('Block',' ',num2str(block),'.mat');
        save(blocks_data, 'results')
        
        % saving all data together
        m_all_results_directory = append(base_path,...
            '/Results Data/All_Subjects');
        mkdir(m_all_results_directory)
        
        save_all_results = fullfile(append(base_path,...
            '/Results Data/All_Subjects'));
        cd (save_all_results)
        
        all_data = append('Subject', ' ',subject_ID, ' ', 'Block',' ',num2str(block),'.mat');
       
        % the last blocks contains the information of all blocks
        all_results(block) = results;
        save(all_data, 'all_results')
    end
    
catch
    
    rethrow(lasterror)
end

% terminate the task
Screen('Close', window);
Screen('CloseAll');
Priority(0);
sca;
ShowCursor;