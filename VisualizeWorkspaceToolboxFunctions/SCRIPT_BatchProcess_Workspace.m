%% SCRIPT_BatchProcess_Workspace
clear all
close all
clc

batchProcess = true;
makeVideo = true;

%% Define test criteria (PRR)
q_lims{1} = [...
    0, 5;...    % Prismatic
    0, pi;...   % Revolute
    0, 2*pi];   % Revolute
Ls{1} = [10,5];

q_lims{end+1} = [...
    0, 5;...    % Prismatic
    0, pi;...   % Revolute
    0, 2*pi];   % Revolute
Ls{end+1} = [5,3];

q_lims{end+1} = [...
    0, 5;...    % Prismatic
    0, pi/2;... % Revolute
    0, 2*pi];   % Revolute
Ls{end+1} = [10,5];

q_lims{end+1} = [...
    0, 5;...    % Prismatic
    0, pi/2;... % Revolute
    0, 2*pi];   % Revolute
Ls{end+1} = [5,3];

q_lims{end+1} = [...
    0, 5;...    % Prismatic
    0, pi;...   % Revolute
    0, 2*pi];   % Revolute
Ls{end+1} = [5,3];

q_lims{end+1} = [...
    0, 5;...    % Prismatic
    0, 2*pi;... % Revolute
    0, 2*pi];   % Revolute
Ls{end+1} = [10,5];

q_lims{end+1} = [...
    0, 5;...    % Prismatic
    0, 2*pi;... % Revolute
    0, 2*pi];   % Revolute
Ls{end+1} = [5,3];

q_lims{end+1} = [...
    0, 30;...    % Prismatic
    0, pi;...   % Revolute
    0, 2*pi];   % Revolute
Ls{end+1} = [10,5];

q_lims{end+1} = [...
    0, 30;...    % Prismatic
    0, pi/2;...   % Revolute
    0, 2*pi];   % Revolute
Ls{end+1} = [10,5];

%% Create videos (PRR)
for i = 1:numel(q_lims)
    q_lim = q_lims{i};
    L = Ls{i};
    WorkspaceExample_PRR;
end

%% Define test criteria (RRP)
clear q_lims Ls
q_lims{1} = [...
    0, pi;...   % Revolute
    0, 2*pi;... % Revolute
    0, 5];      % Prismatic
Ls{1} = [5,3];

q_lims{end+1} = [...
    0, pi;...   % Revolute
    0, 2*pi;... % Revolute
    0, 5];      % Prismatic
Ls{end+1} = [10,5];

q_lims{end+1} = [...
    0, pi/2;...   % Revolute
    0, 2*pi;... % Revolute
    0, 5];      % Prismatic
Ls{end+1} = [5,3];

q_lims{end+1} = [...
    0, pi/2;...   % Revolute
    0, 2*pi;... % Revolute
    0, 5];      % Prismatic
Ls{end+1} = [10,5];

q_lims{end+1} = [...
    0, 2*pi;...   % Revolute
    0, 2*pi;... % Revolute
    0, 5];      % Prismatic
Ls{end+1} = [5,3];

q_lims{end+1} = [...
    0, 2*pi;...   % Revolute
    0, 2*pi;... % Revolute
    0, 5];      % Prismatic
Ls{end+1} = [10,5];

%% Create videos (RRP)
for i = 1:numel(q_lims)
    q_lim = q_lims{i};
    L = Ls{i};
    WorkspaceExample_RRP;
end

%% Define test criteria (RRR)
clear q_lims Ls
q_lims{1} = [...
    0, pi;...   % Revolute
    0, 2*pi;... % Revolute
    0, 2*pi];      % Revolute
Ls{1} = [10,5,3];

q_lims{end+1} = [...
    0, pi;...   % Revolute
    0, 2*pi;... % Revolute
    0, 2*pi];  
Ls{end+1} = [5,5,2];

q_lims{end+1} = [...
    0, pi/2;...   % Revolute
    0, 2*pi;... % Revolute
    0, 2*pi];  
Ls{end+1} = [10,5,3];

q_lims{end+1} = [...
    0, pi/2;...   % Revolute
    0, 2*pi;... % Revolute
    0, 2*pi]; 
Ls{end+1} = [5,5,2];

q_lims{end+1} = [...
    0, 2*pi;...   % Revolute
    0, 2*pi;... % Revolute
    0, 2*pi]; 
Ls{end+1} = [10,5,3];

q_lims{end+1} = [...
    0, 2*pi;...   % Revolute
    0, 2*pi;... % Revolute
    0, 2*pi];
Ls{end+1} = [5,5,2];

q_lims{1} = [...
    0, pi;...   % Revolute
    0, pi;... % Revolute
    0, 2*pi];      % Revolute
Ls{1} = [10,5,3];

q_lims{end+1} = [...
    0, pi;...   % Revolute
    0, pi;... % Revolute
    0, 2*pi];  
Ls{end+1} = [5,5,2];

%% Create videos (RRR)
for i = 1:numel(q_lims)
    q_lim = q_lims{i};
    L = Ls{i};
    WorkspaceExample_RRR;
end