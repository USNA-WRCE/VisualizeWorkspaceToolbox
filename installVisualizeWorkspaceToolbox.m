function installVisualizeWorkspaceToolbox(replaceExisting)
% Install the visualize workspace toolbox
%
%   M. Kutzer, 02Mar2023, JHU/USNA

%% Install/Update required toolboxes
installSupportToolboxes;

%% Assign tool/toolbox specific parameters
dirName = 'VisualizeWorkspaceToolbox';

%% Check inputs
if nargin == 0
    replaceExisting = [];
end

%% Installation error solution(s)
adminSolution = sprintf(...
    ['Possible solution:\n',...
     '\t(1) Close current instance of MATLAB\n',...
     '\t(2) Open a new instance of MATLAB "as administrator"\n',...
     '\t\t(a) Locate MATLAB shortcut\n',...
     '\t\t(b) Right click\n',...
     '\t\t(c) Select "Run as administrator"\n']);

%% Check for toolbox directory
toolboxRoot  = fullfile(userpath,dirName);
isToolbox = exist(toolboxRoot,'file');
if isToolbox == 7
    % Apply replaceExisting argument
    if isempty(replaceExisting)
        choice = questdlg(sprintf(...
            ['MATLAB Root already contains the Visualize Workspace Toolbox.\n',...
            'Would you like to replace the existing toolbox?']),...
            'Replace Existing Visualize Workspace Toolbox','Yes','No','Cancel','Yes');
    elseif replaceExisting
        choice = 'Yes';
    else
        choice = 'No';
    end
    % Replace existing or cancel installation
    switch choice
        case 'Yes'
            rmpath(toolboxRoot);
            [isRemoved, msg, msgID] = rmdir(toolboxRoot,'s');
            if isRemoved
                fprintf('Previous version of Visualize Workspace Toolbox removed successfully.\n');
            else
                fprintf('Failed to remove old Visualize Workspace Toolbox folder:\n\t"%s"\n',toolboxRoot);
                fprintf(adminSolution);
                error(msgID,msg);
            end
        case 'No'
            fprintf('Visualize Workspace Toolbox currently exists, installation cancelled.\n');
            return
        case 'Cancel'
            fprintf('Action cancelled.\n');
            return
        otherwise
            error('Unexpected response.');
    end
end

%% Create Toolbox Path
[isDir,msg,msgID] = mkdir(toolboxRoot);
if isDir
    fprintf('Visualize Workspace toolbox folder created successfully:\n\t"%s"\n',toolboxRoot);
else
    fprintf('Failed to create Visualize Workspace Toolbox folder:\n\t"%s"\n',toolboxRoot);
    fprintf(adminSolution);
    error(msgID,msg);
end

%% Migrate toolbox folder contents
toolboxContent = 'VisualizeWorkspaceToolboxFunctions';
if ~isdir(toolboxContent)
    error(sprintf(...
        ['Change your working directory to the location of "installVisualizeWorkspaceToolbox.m".\n',...
         '\n',...
         'If this problem persists:\n',...
         '\t(1) Unzip your original download of "VisualizeWorkspaceToolbox" into a new directory\n',...
         '\t(2) Open a new instance of MATLAB "as administrator"\n',...
         '\t\t(a) Locate MATLAB shortcut\n',...
         '\t\t(b) Right click\n',...
         '\t\t(c) Select "Run as administrator"\n',...
         '\t(3) Change your "working directory" to the location of "installVisualizeWorkspaceToolbox.m"\n',...
         '\t(4) Enter "installVisualizeWorkspaceToolbox" (without quotes) into the command window\n',...
         '\t(5) Press Enter.']));
end
files = dir(toolboxContent);
wb = waitbar(0,'Copying Visualize Workspace Toolbox toolbox contents...');
n = numel(files);
fprintf('Copying Visualize Workspace Toolbox contents:\n');
for i = 1:n
    % source file location
    source = fullfile(toolboxContent,files(i).name);
    % destination location
    destination = toolboxRoot;
    if files(i).isdir
        switch files(i).name
            case '.'
                %Ignore
            case '..'
                %Ignore
            otherwise
                fprintf('\t%s...',files(i).name);
                nDestination = fullfile(destination,files(i).name);
                [isDir,msg,msgID] = mkdir(nDestination);
                if isDir
                    [isCopy,msg,msgID] = copyfile(source,nDestination,'f');
                    if isCopy
                        fprintf('[Complete]\n');
                    else
                        bin = msg == char(10);
                        msg(bin) = [];
                        bin = msg == char(13);
                        msg(bin) = [];
                        fprintf('[Failed: "%s"]\n',msg);
                    end
                else
                    bin = msg == char(10);
                    msg(bin) = [];
                    bin = msg == char(13);
                    msg(bin) = [];
                    fprintf('[Failed: "%s"]\n',msg);
                end
        end
    else
        fprintf('\t%s...',files(i).name);
        [isCopy,msg,msgID] = copyfile(source,destination,'f');
        
        if isCopy == 1
            fprintf('[Complete]\n');
        else
            bin = msg == char(10);
            msg(bin) = [];
            bin = msg == char(13);
            msg(bin) = [];
            fprintf('[Failed: "%s"]\n',msg);
        end
    end
    waitbar(i/n,wb);
end
set(wb,'Visible','off');

%% Save toolbox path
%addpath(toolboxRoot,'-end');
%savepath;

%% Rehash toolbox cache
%fprintf('Rehashing Toolbox Cache...');
%rehash TOOLBOXCACHE
%fprintf('[Complete]\n');

%% Display path to user
fprintf([...
    'The Visualize Workspace Toolbox is available within your User Path:\n',...
    '%s'],toolboxRoot);