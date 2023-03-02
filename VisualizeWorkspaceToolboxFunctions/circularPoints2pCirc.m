function p = circularPoints2pCirc(x,w)
% CIRCULARPOINTS2PCIRC returns a polyshape circle of "thickness" w
% associated with a set of points defining a circle.
%   p = CIRCULARPOINTS2PCIRC(x,w)
%
%   Input(s)
%       x - 2xN set of points
%       w - desired width of polyshape rectangle
%
%   Output(s)
%       p - circular polyshape of width w
%
%   M. Kutzer, 23Sep2021, USNA

%% Set default(s)

%% Check input(s)
% TODO - Check inputs

% Fit circle
x(3,:) = 0; % Append zero z-value
afit = fitArc(x);

% Define outer and inner circles
afit_out = afit;
afit_in  = afit;
afit_out.Radius = afit.Radius + w/2;
afit_in.Radius = afit.Radius - w/2;

% Interpolate points around circles
x_out = interpArc(afit_out);
x_in  = interpArc(afit_in);
x_out(3,:) = [];    % Remove z-value
x_in(3,:) = [];     % Remove z-value

% Define polyshape
x_all = [x_out(1,:),fliplr(x_in(1,:)); x_out(2,:),fliplr(x_in(2,:))];
p = polyshape(x_all(1,:),x_all(2,:));