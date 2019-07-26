function [coords_out,CD_array] = SATA_CBL_Coords_Above_Threshold(CD_array,Coordinates,relative_threshold)
%SATA_CBL_Coords_Above_Threshold(CD_array,Coordinates,relative_threshold)
%   
%   Purpose: Find coordinates corresponding to Current density values above
%   1-relative_threshold times max value of current density
%
%   Inputs:
%       CD_array            - Current Density matrix
%       Coordinates         - Coordinates of intrest
%       relative_threshold  - value of the threshold, relative to max value 
%                             of current density 
%
%   Outputs:
%       coords_out          - Coordinates with current density values above
%                             the threshold
%
%   Note: if threshold is 0.1, only coordinates with CD values above 
%   0.9*max value of current density will be considered
%
%   Example of Use:
%
%   For any queries please contact clinicalbrainlab@gmail.com

relative_threshold = 1 - relative_threshold;

% finding max value of CD_array
maxi = max(CD_array);

% generating a binary vector
bin_vector = CD_array>=relative_threshold*maxi;

% indexing the coordinates using the binary vector
coords_out = Coordinates(bin_vector,:);

% indexing the CD_array using the binary vector
CD_array = CD_array(bin_vector,:);

end

