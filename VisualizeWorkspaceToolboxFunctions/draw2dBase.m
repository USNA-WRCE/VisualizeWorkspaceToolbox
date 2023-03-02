function p = draw2dBase(axs,h,w,z)
% DRAW2DBASE renders a rigid 2D end-effector base assuming the base
% represents a vertical offset (floor mounted robot)
%   p = draw2dBase(axs,h,w)
%   p = draw2dBase(axs,h,w,z)
%
%   Input(s)
%       axs - axes handle
%       H   - link height
%       w   - link width
%       z   - move patch to foreground or background using small offset
%             values. Default value z = 0. 
%
%   Output(s)
%       p - patch & line objects representing a 2D base
%
%   M. Kutzer, 22Sep2021, USNA

%% Set default(s)
if nargin < 4
    z = 0;
end

%% Check input(s)
% TODO - Check inputs

%% Define vertices
x = [...
    -w/2, -h, z;...
    -w/2,  0, z;...
     w/2,  0, z;...
     w/2, -h, z];
 
%% Render
p(1) = patch('Vertices',x,'Faces',1:size(x,1),...
    'FaceColor',[127,127,127]./255,'EdgeColor','k','LineWidth',2,...
    'Parent',axs);
p(2) = plot3(axs,[-h,h],[-h,-h],[z,z],'-k','LineWidth',4);
     