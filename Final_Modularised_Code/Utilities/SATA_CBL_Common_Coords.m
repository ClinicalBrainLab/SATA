function [n,common_coordinates] = SATA_CBL_Common_Coords(Vertices1,Vertices2)
%SATA_CBL_Common_Coords(Vertices1,Vertices2)
%
%   Purpose: Find common coordinates between two sets of coordinates
%
%   Inputs:
%       Vertices1           - the first set of coordinates
%       Vertices2           - the second set of coordinates
%
%   Outputs:
%       n                   - number of common_coordinates
%       common_coordinates  - the array containing the common 
%                             coordinates
%
%   Note:
%       1)  The input arrays must have each row containing a set of 
%           coordinates.
%           Eg: [ 0 0 0
%                 1 0 1
%                 0 1 0
%                 1 1 1 ] for a 3d coordinate system.
%       2)  Currently, no error is returned if there is no match 
%           between the coordinates.
%           To throw an error uncomment the lines 52-54
%
%   Example of Use:
%
%   If you find bugs in the code, or if you have any queries please contact clinicalbrainlab@gmail.com

% finding the dimensions of the input coordinates
[~,v1] = size(Vertices1);
[~,v2] = size(Vertices2);

%   If the input coordinates have different dimensions, throw an error
if v1~=v2
    error('Input coordinates have different dimensions')
end

%   Converting the coordinates to tables to compute common coordinates using intersect
Vertices1 = array2table(Vertices1);

Vertices2 = array2table(Vertices2,'VariableNames',Vertices1.Properties.VariableNames);
common_coordinates = intersect(Vertices1,Vertices2);

%   Returning number of common coordinates
n = height(common_coordinates);

%   Converting the resulting coordinates back to an array
common_coordinates = table2array(common_coordinates);

% Uncomment these lines to throw an error if no common coordinates

%if n==0
%    error("No common coordinates found.")
%end

end

% temp fn for using arrayfun to generalise to N dimensions
function temp_a = temp(n)
    temp_a = string(char(n+65));
end
