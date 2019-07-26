function [coords_out,CD_array] = SATA_CBL_Top_CD_Coords_By_Percentage(CD_array,Coordinates,percentage)
%SATA_CBL_Top_CD_Coords_By_Percentage(CD_array,Coordinates,relative_threshold)
%   
%   Purpose: Find coordinates corresponding to highest n percentage of CD
%            values
%
%   Inputs:
%       CD_array            - Current Density matrix
%       Coordinates         - Coordinates of intrest
%       percentage          - value of the percentage used to select the
%                             top coordinates
%
%   Outputs:
%       coords_out          - Coordinates with current density values above
%                             the threshold
%
%   Note: if percentage is 2, the coordinate with top 2% of CD values are
%   chosen
%
%   if you have any queries please contact clinicalbrainlab@gmail.com

% lower limit
low_thresh = 1;
thresh = floor(percentage*length(CD_array)/100);

%sorting
[CD_array,order]=sort(CD_array);
CD_array = flip(CD_array);
order = flip(order);
%taking highest n percentage
CD_array = CD_array(low_thresh:thresh);
coords_out = Coordinates(order,:);
coords_out = coords_out(low_thresh:thresh,:);

end

