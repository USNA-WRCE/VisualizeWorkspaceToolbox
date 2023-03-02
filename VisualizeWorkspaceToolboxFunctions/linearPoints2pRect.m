function p = linearPoints2pRect(x,w)
% LINEARPOINTS2PRECT returns a polyshape rectangle of width w associated 
% with a set of points defining a segment.
%   p = LINEARPOINTS2PRECT(x,w)
%
%   Input(s)
%       x - 2xN set of points
%       w - desired width of polyshape rectangle
%
%   Output(s)
%       p - rectangle polyshape of width w
%
%   M. Kutzer, 23Sep2021, USNA

%% Set default(s)

%% Check input(s)
% TODO - Check inputs

%% Fit line to plane
abc = fitPlane(x);

%% Project points to plane
x = proj2plane(abc,x);

%% Define plane orientation
y_hat = abc(1:2).';
x_hat = [y_hat(2); -y_hat(1)];

R_p2o = [x_hat,y_hat];

%% Reference points to "plane frame"
R_o2p = R_p2o.';
x_p = R_o2p * x;

%% Sort points
[~,idx] = sort(x_p(1,:),'ascend');

%% Define rectangle
i0 = idx(1);
i1 = idx(end);
r_p = [...
    x_p(1,i0)    , x_p(1,i1)    , x_p(1,i1)    , x_p(1,i0);...
    x_p(2,i0)-w/2, x_p(2,i0)-w/2, x_p(2,i1)+w/2, x_p(2,i1)+w/2];

%% Reference rectangle to base frame
r_o = R_p2o * r_p;

%% Create polyshape
p = polyshape(r_o(1,:),r_o(2,:));
