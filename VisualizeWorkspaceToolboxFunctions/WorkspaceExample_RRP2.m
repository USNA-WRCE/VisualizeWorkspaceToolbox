%% WorkspaceExample_RRP
% Draw the reachable and dexterous workspace for a planar RRP arm
%
%   M. Kutzer, 23Sep2025, USNA

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
    makeVideo = true;
end

%% Define arm parameters
% Arm kinematics
% H_e2o = Rz(q(1))Tx(L(1))Rz(pi/2)Rz(-q(2))Tx(L(2))Rz(-pi/2)Tx(q(3));

if ~batchProcess
    % --- Define joint limits ---

    % -> Example 1
    q_lim = [...
        0, pi;...   % Revolute
        0, 2*pi;... % Revolute
        0.2, 0.4];      % Prismatic

    % --- Rigid link lengths ---
    
    % -> Example A
    L = [0.2,0.4];

end
% Initial pose
q_init = [pi/6; pi/6; 0.2];

%% Define video filename for workspace
%kinematics = sprintf('Rz[%d,%d]Tx%dRz(pi/2)Rz[-%d,-%d]Tx%dRz(-pi/2)Tx[%d,%d]',...
%    rad2deg(q_lim(1,:)),...
%    L(1),...
%    rad2deg(q_lim(2,:)),...
%    L(2),...
%    q_lim(3,:));
kinematics = 'RRP2';
jointConfig = sprintf('RRP');

% Define video filename for reachable workspace
filename = sprintf('Wrkspc_%s_%s',jointConfig,kinematics);

%% Visualize robot
% Create figure & axes
posVid = [0.25,0.65,12.67,5.40];
posImg = [0.25,0.65, 4.42,5.40];
fig = figure('Color',[1 1 1],'Name','WorkspaceExample_RRP');
set(fig,'Units','Inches','Position',posVid);
axs = axes('Parent',fig);
hold(axs,'on');
daspect(axs,[1 1 1]);
xlabel(axs,'x (m)');
ylabel(axs,'y (m)');
grid(axs,'on');
xlim(axs,[-1,1]);%[-(sum(L)+q_lim(3,2)),(sum(L)+q_lim(3,2))]+[-1,1]);
ylim(axs,[-0.7,1]);%[-(L(2)+q_lim(3,2)),(sum(L)+q_lim(3,2))]+[-1,1]);

% Define transforms
H(1) = triad('Parent',axs,'Scale',0.1);  % H_1to0
H(2) = triad('Parent',H(1),'Scale',0.1); % H_2to1
H(3) = triad('Parent',H(2),'Scale',0.1); % H_3to2
H(4) = triad('Parent',H(3),'Scale',0.1); % H_4to3
%hideTriad(H);

% Draw links
q = q_init;
w = 0.03;
p_B    = draw2dBase(axs,0.2,w,-0.007);
p_L(1) = draw2dLink(H(1),L(1),w,-0.006);
p_L(2) = draw2dLink(H(2),L(2),w,-0.004);
p_L(3) = draw2dLink(H(3),q(3),w,-0.002);

% Draw joints
p_J{1} = draw2dRevoluteJoint( H(1),2*w,-0.005);
p_J{2} = draw2dRevoluteJoint( H(2),2*w,-0.003);
p_J{3} = draw2dPrismaticJoint(H(3),2*w,-0.001);

% Update kinematics
q = q_init;
H_e2o = fkin(q,L,H,p_L);

%% Draw Reachable Workspace
title(axs,'Drawing Reachable Workspace');

dw = 0.01;
X_0 = [];
plt = plot(axs,0,0,'b','LineWidth',2);

% Define number of still images to save
nImages = 5;

n = 50;
iImages = round(linspace(1,n,nImages));
i = 0;
for q3 = linspace(q_lim(3,1),q_lim(3,2),n)
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

    % Save individual image
    i = i+1;
    tf = (i==iImages);
    if any(tf)
        set(fig,'Position',posImg);
        set(axs,'Visible','off')
        drawnow
        imageName = sprintf('R%s_q3_%d.png',get(fig,'Name'),find(tf));
        saveas(axs,imageName,'png');
        set(fig,'Position',posVid);
        set(axs,'Visible','on')
    end
end
% Create polyshape (distal joint is P, use linearPoints2pRect)
p_0 = linearPoints2pRect(X_0,2*dw);
% Reference polyshape to end-effector
p_E = transformPolyshape(p_0,invSE(H_Eto0));
w_0 = p_0;
% Plot polyshape
pW_0 = plot(w_0,'LineStyle','none','FaceColor','b','FaceAlpha',0.5);
delete(plt);

n = 300;
iImages = round(linspace(1,n,nImages));
i = 0;
for q2 = linspace(q_lim(2,1),q_lim(2,2),n)
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

    % Save individual image
    i = i+1;
    tf = (i==iImages);
    if any(tf)
        set(fig,'Position',posImg);
        set(axs,'Visible','off')
        drawnow
        imageName = sprintf('R%s_q2_%d.png',get(fig,'Name'),find(tf));
        saveas(axs,imageName,'png');
        set(fig,'Position',posVid);
        set(axs,'Visible','on')
    end
end
% Reference polyshape to end-effector
p_E = transformPolyshape(w_0,invSE(H_Eto0));

n = 300;
iImages = round(linspace(1,n,nImages));
i = 0;
for q1 = linspace(q_lim(1,1),q_lim(1,2),n)
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

    % Save individual image
    i = i+1;
    tf = (i==iImages);
    if any(tf)
        set(fig,'Position',posImg);
        set(axs,'Visible','off')
        drawnow
        imageName = sprintf('R%s_q1_%d.png',get(fig,'Name'),find(tf));
        saveas(axs,imageName,'png');
        set(fig,'Position',posVid);
        set(axs,'Visible','on')
    end
end

title(axs,'Reachable Workspace');
% Show all spaces
for i = 1:60
    drawVideo(fig,filename,makeVideo);
end
saveas(fig,'Workspace_RRP2.png','png');

% End video
endVideo(makeVideo)

%{
%% Hide reachable workspace
set(pW_0,'Visible','off');

%% Dexterous workspace
title(axs,'Drawing Dexterous Workspace');

% Define video filename for dexterous workspace
filename = sprintf('DexWrkspc_%s_%s',jointConfig,kinematics);

% Define most distal revolute joint test configurations
q2s = [0,pi/2,pi,3*pi/2];

colors = 'rgby';
for j = 1:numel(q2s)
    q2 = q2s(j);
    X_0 = [];
    plt = plot(axs,0,0,colors(j),'LineWidth',2);

    n = 50;
    iImages = round(linspace(1,n,nImages));
    i = 0;
    for q3 = linspace(q_lim(3,1),q_lim(3,2),n)
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

        % Save individual image
        i = i+1;
        tf = (i==iImages);
        if any(tf)
            set(fig,'Position',posImg);
            set(axs,'Visible','off')
            drawnow
            imageName = sprintf('D%s_q3_%d.%d.png',get(fig,'Name'),j,find(tf));
            saveas(axs,imageName,'png');
            set(fig,'Position',posVid);
            set(axs,'Visible','on')
        end
    end
    % Create polyshape
    p_0 = linearPoints2pRect(X_0,2*dw);
    % Reference polyshape to end-effector
    p_E = transformPolyshape(p_0,invSE(H_Eto0));
    w_0(j) = p_0;
    % Plot polyshape
    pW_0(j) = plot(w_0(j),...
        'LineWidth',2,'EdgeColor',colors(j),...
        'FaceColor',colors(j),'FaceAlpha',0.5);
    delete(plt);

    n = 300;
    iImages = round(linspace(1,n,nImages));
    i = 0;
    for q1 = linspace(q_lim(1,1),q_lim(1,2),n)
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

        % Save individual image
        i = i+1;
        tf = (i==iImages);
        if any(tf)
            set(fig,'Position',posImg);
            set(axs,'Visible','off')
            drawnow
            imageName = sprintf('D%s_q1_%d.%d.png',get(fig,'Name'),j,find(tf));
            saveas(axs,imageName,'png');
            set(fig,'Position',posVid);
            set(axs,'Visible','on')
        end
    end

    % Hide other workspaces
    set(pW_0(j),'Visible','off');
end

% Show workspaces other workspaces
set(fig,'Position',posImg);
set(axs,'Visible','off')
set(pW_0,'Visible','on');
drawnow
imageName = sprintf('D%s_All.png',get(fig,'Name'));
saveas(axs,imageName,'png');
set(fig,'Position',posVid);
set(axs,'Visible','on')

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

% Show workspaces other workspaces
set(fig,'Position',posImg);
set(axs,'Visible','off')
drawnow
imageName = sprintf('D%s.png',get(fig,'Name'));
saveas(axs,imageName,'png');
set(fig,'Position',posVid);
set(axs,'Visible','on')
%}
warning on

%% Internal function(s)
function [H_Eto0,H_1to0,H_2to1,H_3to2,H_4to3] = fkin(q,L,H,p_L)
% H_e2o = Rz( q(1) )*Tx( L(1) )*Rz( pi/2 )*Rz( -q(2) )*Tx( L(2) )*Rz( -pi/2 )*Tx( q(3) );
H_1to0 = Rz( q(1) );
H_2to1 = Tx( L(1) )*Rz( pi/2 )*Rz( -q(2) );
H_3to2 = Tx( L(2) )*Rz( -pi/2 );
H_4to3 = Tx( q(3) );
H_Eto0 = H_1to0*H_2to1*H_3to2*H_4to3;

set(H(1),'Matrix',H_1to0);
set(H(2),'Matrix',H_2to1);
set(H(3),'Matrix',H_3to2);
set(H(4),'Matrix',H_4to3);

update2dLink(p_L(3),q(3));
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