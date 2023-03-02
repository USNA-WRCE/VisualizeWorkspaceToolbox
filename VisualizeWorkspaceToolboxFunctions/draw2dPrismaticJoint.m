function p = draw2dPrismaticJoint(axs,w,z)
% DRAW2DPRISMATICJOINT renders a 2D revolute joint centered at the origin.
%   p = draw2dPrismaticJoint(axs,w)
%
%   Input(s)
%       axs - axes handle
%       w   - width/length of prismatic joint
%       z   - move patch to foreground or background using small offset
%             values. Default value z = 0. 
%
%   Output(s)
%       p - patch & line objects representing a 2D prismatic joint
%
%   M. Kutzer, 22Sep2021, USNA

%% Set default(s)
if nargin < 3
    z = 0;
end

%% Check input(s)
% TODO - Check inputs

%% Define vertices
x = [...
           -w, -w/2, z;...
           -w,  w/2, z;...
    -(1/10)*w,  w/2, z;...
    -(1/10)*w, -w/2, z];

y = [...
    -(1/10)*w, -w/2, z;...
    -(1/10)*w,  w/2, z;...
            0,  w/2, z;...
            0, -w/2, z];
        
%% Render
p(1) = patch('Vertices',y,'Faces',1:size(y,1),...
    'FaceColor',[250,250,250]./255,'EdgeColor','none','LineWidth',2,...
    'Parent',axs);
p(2) = patch('Vertices',x,'Faces',1:size(x,1),...
    'FaceColor',[127,127,127]./255,'EdgeColor','k','LineWidth',2,...
    'Parent',axs);
p(3) = plot3(axs,[0,0],[-w/2,w/2],[z,z],'-k','LineWidth',2);