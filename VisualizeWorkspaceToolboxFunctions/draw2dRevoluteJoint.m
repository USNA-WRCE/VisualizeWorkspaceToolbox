function p = draw2dRevoluteJoint(axs,d,z)
% DRAW2DREVOLUTEJOINT renders a 2D revolute joint centered at the origin.
%   p = draw2dRevoluteJoint(axs,d)
%
%   Input(s)
%       axs - axes handle
%       d   - diameter of revolute joint
%       z   - move patch to foreground or background using small offset
%             values. Default value z = 0. 
%
%   Output(s)
%       p - patch object
%
%   M. Kutzer, 22Sep2021, USNA

%% Set default(s)
if nargin < 3
    z = 0;
end

%% Check input(s)
% TODO - Check inputs

%% Define vertices
phi = linspace(0,2*pi,101); phi(end) = [];
x = [...
    d/2*cos(phi);...  % x
    d/2*sin(phi);...  % y
    z*ones(1,100)].'; % z (offset to put joint in foreground/background)

%% Render
p = patch('Vertices',x,'Faces',1:size(x,1),...
    'FaceColor',[127,127,127]./255,'EdgeColor','k','LineWidth',2,...
    'Parent',axs);