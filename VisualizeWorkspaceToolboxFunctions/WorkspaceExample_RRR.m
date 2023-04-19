%% WorkspaceExample_RRR
% Draw the reachable and dexterous workspace for a planar RRR arm
%
%   M. Kutzer, 22Sep2021, USNA

%% Initialize parameters for batch processing videos
if ~exist('batchProcess','var')
    batchProcess = false;
end

warning off
if ~batchProcess
    clearvars -except batchProcess
end
close all
clc

if ~batchProcess
    makeVideo = false;
end

%% Define arm parameters
% Arm kinematics
% H_e2o = Rz(q(1))Tx(L(1)Rz(q(2))Tx(L(2))Rz(q(3))Tx(L(3));

if ~batchProcess
    % --- Define joint limits ---

    % -> Example 1
    q_lim = [...
        0, pi;...   % Revolute
        0, 2*pi;... % Revolute
        0, 2*pi];   % Revolute

    % --- Rigid link lengths ---
    
    % -> Example A
    L = [10,5,3];

end
% Initial pose
q_init = [pi/6; pi/6; pi/6];

%% Define video filename for workspace
kinematics = sprintf('Rz[%d,%d]Tx%dRz[%d,%d]Tx%dRz[%d,%d]Tx%d',...
    rad2deg(q_lim(1,:)),...
    L(1),...
    rad2deg(q_lim(2,:)),...
    L(2),...
    rad2deg(q_lim(3,:)),...
    L(3));
jointConfig = sprintf('RRR');

% Define video filename for reachable workspace
filename = sprintf('Workspace_%s_%s',jointConfig,kinematics);

%% Visualize robot
% Create figure & axes
fig = figure('Color',[1 1 1],'Name','WorkspaceExample_RRR');
set(fig,'Units','Inches','Position',[0.25,0.65,12.67,5.40]);
axs = axes('Parent',fig);
hold(axs,'on');
daspect(axs,[1 1 1]);
xlabel(axs,'x (cm)');
ylabel(axs,'y (cm)');
grid(axs,'on');
xlim(axs,[-(sum(L)),(sum(L))]+[-1,1]);
ylim(axs,[-(sum(L)),(sum(L))]+[-1,1]);

% Define transforms
H(1) = triad('Parent',axs);  % H_1to0
H(2) = triad('Parent',H(1)); % H_2to1
H(3) = triad('Parent',H(2)); % H_3to2
H(4) = triad('Parent',H(3)); % H_4to3
%hideTriad(H);

% Draw links
q = q_init;
w = 0.3;
p_B    = draw2dBase(axs,2,w,-0.07);
p_L(1) = draw2dLink(H(1),L(1),w,-0.06);
p_L(2) = draw2dLink(H(2),L(2),w,-0.04);
p_L(3) = draw2dLink(H(3),L(3),w,-0.02);

% Draw joints
p_J{1} = draw2dRevoluteJoint( H(1),2*w,-0.05);
p_J{2} = draw2dRevoluteJoint( H(2),2*w,-0.03);
p_J{3} = draw2dRevoluteJoint(H(3),2*w,-0.01);

% Update kinematics
q = q_init;
H_e2o = fkin(q,L,H,p_L);

%% Draw Reachable Workspace
title(axs,'Drawing Reachable Workspace');

dw = 0.1;
X_0 = [];
plt = plot(axs,0,0,'b','LineWidth',2);
for q3 = linspace(q_lim(3,1),q_lim(3,2),50)
    q2 = q_lim(2,1);
    q1 = q_lim(1,1);
    % Define joint configuration
    q = [q1; q2; q3];
    % Calculate forward kinematics
    H_Eto0 = fkin(q,L,H,p_L);
    % Recover end-effector position
    X_0(:,end+1) = H_Eto0(1:2,4);

    % Visualize end-effector position
    set(plt,'XData',X_0(1,:),'YData',X_0(2,:));
    drawVideo(fig,filename,makeVideo);
end
% Create polyshape (distal joint is R, use circularPoints2pCirc)
p_0 = circularPoints2pCirc(X_0,2*dw);
% Reference polyshape to end-effector
p_E = transformPolyshape(p_0,invSE(H_Eto0));
w_0 = p_0;
% Plot polyshape
pW_0 = plot(w_0,'LineStyle','none','FaceColor','b','FaceAlpha',0.5);
delete(plt);

for q2 = linspace(q_lim(2,1),q_lim(2,2),300)
    q1 = q_lim(1,1);
    % Define joint configuration
    q = [q1; q2; q3];
    % Calculate forward kinematics
    H_Eto0 = fkin(q,L,H,p_L);

    % Transform original polyshape
    p_0 = transformPolyshape(p_E,H_Eto0);

    % Update workspace
    w_0 = union(p_0,w_0);

    % Update workspace plot
    set(pW_0,'Shape',w_0);
    drawVideo(fig,filename,makeVideo);
end
% Reference polyshape to end-effector
p_E = transformPolyshape(w_0,invSE(H_Eto0));

for q1 = linspace(q_lim(1,1),q_lim(1,2),300)
    % Define joint configuration
    q = [q1; q2; q3];
    % Calculate forward kinematics
    H_Eto0 = fkin(q,L,H,p_L);

    % Transform original polyshape
    p_0 = transformPolyshape(p_E,H_Eto0);

    % Update workspace
    w_0 = union(p_0,w_0);

    % Update workspace plot
    set(pW_0,'Shape',w_0);
    drawVideo(fig,filename,makeVideo);
end

title(axs,'Reachable Workspace');
% Show all spaces
for i = 1:60
    drawVideo(fig,filename,makeVideo);
end
% End video
endVideo(makeVideo)

%% Hide reachable workspace
set(pW_0,'Visible','off');

%% Dexterous workspace
title(axs,'Drawing Dexterous Workspace');

% Define video filename for dexterous workspace
filename = sprintf('DexWrkspc_%s_%s',jointConfig,kinematics);

% Define most distal revolute joint test configurations
q3s = [0,pi/2,pi,3*pi/2];

colors = 'rgby';
for j = 1:numel(q3s)
    q3 = q3s(j);
    X_0 = [];
    plt = plot(axs,0,0,colors(j),'LineWidth',2);
    for q2 = linspace(q_lim(2,1),q_lim(2,2),50)
        q1 = q_lim(1,1);
        % Define joint configuration
        q = [q1; q2; q3];
        % Calculate forward kinematics
        H_Eto0 = fkin(q,L,H,p_L);
        % Recover end-effector position
        X_0(:,end+1) = H_Eto0(1:2,4);

        % Visualize end-effector position
        set(plt,'XData',X_0(1,:),'YData',X_0(2,:));
        drawVideo(fig,filename,makeVideo);
    end
    % Create polyshape
    p_0 = circularPoints2pCirc(X_0,2*dw);
    % Reference polyshape to end-effector
    p_E = transformPolyshape(p_0,invSE(H_Eto0));
    w_0(j) = p_0;
    % Plot polyshape
    pW_0(j) = plot(w_0(j),...
        'LineWidth',2,'EdgeColor',colors(j),...
        'FaceColor',colors(j),'FaceAlpha',0.5);
    delete(plt);

    for q1 = linspace(q_lim(1,1),q_lim(1,2),300)
        % Define joint configuration
        q = [q1; q2; q3];
        % Calculate forward kinematics
        H_Eto0 = fkin(q,L,H,p_L);

        % Transform original polyshape
        p_0 = transformPolyshape(p_E,H_Eto0);

        % Update workspace
        w_0(j) = union(p_0,w_0(j));

        % Update workspace plot
        set(pW_0(j),'Shape',w_0(j));
        drawVideo(fig,filename,makeVideo);
    end
end

% Find combine workspaces to define dexterous workspace
dw_0 = intersect(w_0(1),w_0(2));
for i = 3:numel(w_0)
    dw_0 = intersect(dw_0,w_0(i));
end

% Visualize dexterous workspace
if isempty(dw_0.Vertices)
    title(axs,'No Dexterous Workspace');
else
    title(axs,'Dexterous Workspace');
    pDW_0 = plot(dw_0,'LineWidth',2,...
        'EdgeColor','m','FaceColor','m','FaceAlpha',0.5);
end

% Show all spaces
for i = 1:60
    drawVideo(fig,filename,makeVideo);
end

% Show just dexterous workspace
set(pW_0,'Visible','off');
for i = 1:60
    drawVideo(fig,filename,makeVideo);
end
% End video
endVideo(makeVideo)

warning on

%% Internal function(s)
function [H_Eto0,H_1to0,H_2to1,H_3to2,H_4to3] = fkin(q,L,H,p_L)
% H_e2o = Rz( q(1) )*Tx( L(1) )*Rz( q(2) )*Tx( L(2) )*Rz( q(3) )*Tx( L(3) );
H_1to0 = Rz( q(1) );
H_2to1 = Tx( L(1) )*Rz( q(2) );
H_3to2 = Tx( L(2) )*Rz( q(3) );
H_4to3 = Tx( L(3) );
H_Eto0 = H_1to0*H_2to1*H_3to2*H_4to3;

set(H(1),'Matrix',H_1to0);
set(H(2),'Matrix',H_2to1);
set(H(3),'Matrix',H_3to2);
set(H(4),'Matrix',H_4to3);

end

function drawVideo(fig,filename,makeVideo)
global vidObj
drawnow
if makeVideo
    if isempty(vidObj)
        vidObj = VideoWriter([filename,'.mp4'],'MPEG-4');
        open(vidObj);
    end
    % Grab a frame for the video
    frame = getframe(fig);
    % Write the frame to the video
    writeVideo(vidObj,frame);
end
end

function endVideo(makeVideo)
global vidObj
if makeVideo
    close(vidObj);
    vidObj = [];
end
end