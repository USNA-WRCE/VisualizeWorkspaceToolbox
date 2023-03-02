function p = draw2dLink(axs,L,w,z)
% DRAW2DLINK renders a rigid 2D link assuming the link extends in the
% x-direction.
%   p = draw2dLink(axs,L,w)
%   p = draw2dLink(axs,L,w,z)
%
%   Input(s)
%       axs - axes handle
%       L   - link length
%       w   - link width
%       z   - move patch to foreground or background using small offset
%             values. Default value z = 0. 
%
%   Output(s)
%       p - patch object
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
    0, -w/2, z;...
    0,  w/2, z;...
    L,  w/2, z;...
    L, -w/2, z];

%% Render
p = patch('Vertices',x,'Faces',1:size(x,1),...
        'FaceColor',[127,127,127]./255,'EdgeColor','k','LineWidth',2,...
        'Parent',axs);
