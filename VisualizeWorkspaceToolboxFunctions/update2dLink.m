function update2dLink(p,L)
% UPDATE2DLINK changes the length of a rendered 2D link that extends in the
% x-direction.
%   update2dLink(p,L)
%
%   Input(s)
%       p - linkpatch object
%       L - link length
%
%   M. Kutzer, 22Sep2021, USNA

%% Set default(s)

%% Check input(s)
% TODO - Check inputs

%% Recover vertices
x = get(p,'Vertices');

%% Update vertices
x(:,1) = [0; 0; L; L];

set(p,'Vertices',x);