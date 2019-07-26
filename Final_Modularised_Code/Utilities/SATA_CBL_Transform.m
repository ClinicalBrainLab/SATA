function transformed_coords = SATA_CBL_Transform(Vertices, transformation_matrix)
%SATA_CBL_Transform(Vertices, transformation_matrix)
%   
%   Purpose: Transform the coordinates from a given system to the talairach
%   system
%
%   Inputs:
%       Vertices             - Coordinates to be transformed
%       tranformation_matrix - the tansformation matrix obtained from
%                              fieltrip
%
%   Outputs:
%       transformed_coords   - Coordinates after tranformation
%
%   Example of Use:
%
%   if you have any queries please contact clinicalbrainlab@gmail.com

% finding the current directory
mydir  = pwd;
idcs   = strfind(mydir,filesep);

% finding the directory above the current directory
new_dir = mydir(1:idcs(end)-1);


% adding spm12 to path (required for CBL_cor2mni and CBL_mni2tal)
addpath(char(new_dir+string(filesep)+"Utilities"+string(filesep)+"spm12"));

% tranforming the coordinates
mni = SATA_CBL_cor2mni(Vertices, transformation_matrix);
mni = fix(mni);
MNI_Vert_1_Fix= fix(mni);

% output of transformation
transformed_coords = SATA_CBL_mni2tal(MNI_Vert_1_Fix);

end

