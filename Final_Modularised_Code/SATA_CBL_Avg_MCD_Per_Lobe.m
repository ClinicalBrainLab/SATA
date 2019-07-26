function Mean_Std_of_Lobes = SATA_CBL_Avg_MCD_Per_Lobe(Montage,brain_region,roast,pt1,pt2,pt3,method)
%SATA_CBL_avg_MCD_per_Lobe(Montage,brain_region,roast,pt1,pt2,pt3,method)
%
%   Purpose: Plot the average Current density for various cortical lobes
%
%   Input:
%       Montage         -   montage data output from comets/roast
%       brain_region    -   region of the brain to be checked
%       (Optional - used while tranforming the head)
%       roast           -   boolean value to use roast
%       pt1             -   fiducial pt1(ac/NAS)
%       pt2             -   fiducial pt2(pc/LPA)
%       pt3             -   fiducial pt3(mid sagital/RPA)
%       method          -   method used for conversion in fieldtrip
%
%   Ouputs:
%       Mean_Std_of_Lobes - the table containing mean and std deviation of
%                           various cortical lobes
%
%   Example of Use:
%       load (“SATA\examples\CP5_CZ_5_5.mat”);
%       load (“SATA\examples\ROAST\CP5_CZ_50_50.mat”);
%       Comets:
%           SATA_CBL_avg_CD_per_Lobe(CP5_CZ_5_5, "Cerebrum");
%           SATA_CBL_avg_CD_per_Lobe(CP5_CZ_5_5, "Cerebellum");
%       ROAST:
%           SATA_CBL_avg_CD_per_Lobe(CP5_CZ_50_50, "Cerebrum");
%
%
%   For any queries please contact clinicalbrainlab@gmail.com

% add utilities to path
addpath('Utilities');

%getting current directory
mydir  = pwd;
idcs   = strfind(mydir,filesep);
new_dir = mydir(1:idcs(end)-1);

% checking to use fieldtrip and whether to use roast
if nargin==2
    use_ft = false;
    roast = false;
else
    use_ft = true;
end

% fieldtrip function
if use_ft
    
    %add fieldtrip to path
    addpath(char(new_dir+string(filesep)+"Utilities"+string(filesep)+"fieldtrip"+string(filesep)+"utilities"))
    
    if roast && nargin == 3
        pt1= [90.97,112.4,60.3];
        pt2 = [90.5,92.11,59.15];
        pt3 = [90.25,113.5,150.8];
        method = 'spm';
    end
    
    [h6, ~] = ft_headcoordinates(pt1, pt2, pt3, method);
else
    h6 = [0.998500000000000,0.00430000000000000,-0.0537000000000000,0.748000000000000;...
        -0.0202000000000000,0.954000000000000,-0.299300000000000,4.97280000000000;...
        0.0500000000000000,0.299900000000000,0.952700000000000,-43.2186000000000;...
        0,0,0,1];
end

% assigning variables
CD_array = Montage.Target.FaceVertexCData;
Vertices = Montage.Target.Vertices;

% converting the coordinates
MNI_Tal_Conv= SATA_CBL_Transform(Vertices,h6);

% running the coordinates throguh talairach
table_out = SATA_CBL_Call_Talairach(MNI_Tal_Conv);

% to save talairach output as a *.mat file
%save('REPLACE_WITH_SAVE_PATH_AND_FILE_NAME',table_out);

% measuring CD values and plotting for the cortical lobes in a given brain region
if roast
    Mean_Std_of_Lobes = SATA_CBL_Extract_Plot_Mean_STD_Cortical_Roast(CD_array,table_out,brain_region);
else
    Mean_Std_of_Lobes = SATA_CBL_Extract_Plot_Mean_STD_Cortical(CD_array,table_out,brain_region);
end

end

