function weighted_table = SATA_CBL_Coords_With_High_MCD(Montage,brain_region,threshold,fid1,fid2,fid3,method)
%SATA_CBL_coords_with_high_mcd(Montage,brain_region,threshold,fid1,fid2,fid3,method)
%
%   Purpose: Plot the top 12 weighted current densities as a bar plot and 
%   their corresponding coordinates as a scatterplot.
%
%   Input:
%       Montage         -   montage data output from comets/roast
%       brain_region    -   region of the brain to be checked
%       threshold  -   threshold to be applied to current density array
%                       from Montage
%       (Optional - used while tranforming the head)
%       pt1             -   fiducial pt1(ac/NAS)
%       pt2             -   fiducial pt2(pc/LPA)
%       pt3             -   fiducial pt3(mid sagital/RPA)
%       method          -   method used for conversion in fieldtrip
%
%   Example of Use:
%       load (“SATA\examples\CP5_CZ_5_5.mat”);
%       SATA_CBL_avg_CD_per_Lobe(CP5_CZ_5_5, "Cerebrum", 0.5);
%       SATA_CBL_avg_CD_per_Lobe(CP5_CZ_5_5, "Cerebellum", 0.5);
%
%   For any queries please contact clinicalbrainlab@gmail.com

% finding the current directory
mydir  = pwd;
idcs   = strfind(mydir,filesep);

% finding the directory above the current directory
new_dir = mydir(1:idcs(end)-1);

% checking to use fieldtrip
if nargin==3
    use_ft = false;
else
    use_ft = true;
end

% adding utilities to path
addpath('Utilities');

% extracting the Current density values and the vertices
CD_array = Montage.Target.FaceVertexCData;
Vertices = Montage.Target.Vertices;


% thresholding coordinates
[thresholded_coords,CD_array] = SATA_CBL_Coords_Above_Threshold(CD_array,Vertices,threshold);

% feildtrip function
if use_ft
    addpath(char(new_dir+string(filesep)+"Utilities"+string(filesep)+"fieldtrip"+string(filesep)+"utilities"))
    [h6, ~] = ft_headcoordinates(fid1, fid2, fid3,method);
else
    
    h6 = [0.998500000000000,0.00430000000000000,-0.0537000000000000,0.748000000000000;...
        -0.0202000000000000,0.954000000000000,-0.299300000000000,4.97280000000000;...
        0.0500000000000000,0.299900000000000,0.952700000000000,-43.2186000000000;...
        0,0,0,1];
end

% Converting coordinates to the required form
MNI_Tal_Conv = SATA_CBL_Transform(thresholded_coords,h6);

% running the coordinates throguh talairach
table_out = SATA_CBL_Call_Talairach(MNI_Tal_Conv);

% measuring CD values and plotting for all gyri in a given brain region
v = SATA_CBL_Transform(Vertices,h6);
weighted_table = SATA_CBL_Extract_Plot_WCD_Gyri(v,CD_array,table_out,brain_region);

end

