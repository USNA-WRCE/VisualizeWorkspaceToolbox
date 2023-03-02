function p_b = transformPolyshape(p_a,H_a2b)
% TRANSFORMPOLYSHAPE transforms a polyshape given a homogeneous
% transformation.
%   p_b = TRANSFORMPOLYSHAPE(p_a,H_a2b)
%
%   Input(s)
%       p_a   - polyshape referenced to frame a
%       H_a2b - 3D transformation defining frame a relative to b
%
%   Output(s)
%       p_b - polyshape referenced to frame b
%
%   M. Kutzer, 23Sep2021, USNA

%% Set default(s)

%% Check input(s)
% TODO - Check inputs

%% Recover vertices
v_a = p_a.Vertices.';

%% Make vertices 3D homogeneous
v_a(4,:) = 1;

%% Transform vertices
v_b = H_a2b * v_a;

%% Package output
p_b = p_a;
p_b.Vertices = v_b(1:2,:).';