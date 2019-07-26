function SATA_CBL_Overlapping_Coords(Montage1,Montage2,threshold1,threshold2,roast,pt1,pt2,pt3,method)
%SATA_CBL_Overlapping_Coords(Montage1,Montage2)
%
%   Purpose: Display the common coordinates in both montages with Current
%   density values above a certain threshold of the maximum current density
%
%   Input:
%       Montage1    -   montage data output from comets/roast
%       Montage2    -   montage data output from comets/roast
%       threshold1  -   threshold to be applied to current density array
%                       from Montage1
%       threshold2  -   threshold to be applied to current density array
%                       from Montage2
%       (Optional - used while tranforming the head)
%       roast           -   boolean value to use roast
%       pt1         -   fiducial pt1(ac/NAS)
%       pt2         -   fiducial pt2(pc/LPA)
%       pt3         -   fiducial pt3(mid sagital/RPA)
%       method      -   method used for conversion in fieldtrip
%
%   Note: For Comets: if threshold1 is 0.1, only coordinates with CD values
%         above 0.9*max value of current density will be considered
%
%         For Roast: if threshold1 is 2, the coordinate with top 2% of
%         CD values are chosen
%
%   Example of Use:
%       load (“SATA\examples\CP5_CZ_5_5.mat”);
%       load (“SATA\examples\TP7_CZ_5_5.mat”);
%       load (“SATA\examples\ROAST\CP5_CZ_50_50.mat”);
%       load (“SATA\examples\ROAST\TP7_CZ_50_50.mat”);
%       Comets:
%           SATA_CBL_avg_CD_per_Lobe(CP5_CZ_5_5, TP7_CZ_5_5,0.5, 0.5);
%       ROAST:
%           SATA_CBL_avg_CD_per_Lobe(CP5_CZ_50_50,TP7_CZ_50_50,5,5,true);
%
%   For queries please contact clinicalbrainlab@gmail.com


if nargin == 4
    roast = false;
end

addpath('Utilities');
Vertices1 = Montage1.Target.Vertices;
Vertices2 = Montage2.Target.Vertices;
CD_array1 = Montage1.Target.FaceVertexCData;
CD_array2 = Montage2.Target.FaceVertexCData;

mydir  = pwd;
idcs   = strfind(mydir,filesep);
new_dir = mydir(1:idcs(end)-1);

% checking for roast
if roast
    addpath(char(new_dir+string(filesep)+"Utilities"+string(filesep)+"fieldtrip"+string(filesep)+"utilities"))
    if roast && nargin == 5
        pt1= [90.97,112.4,60.3];
        pt2 = [90.5,92.11,59.15];
        pt3 = [90.25,113.5,150.8];
        method = 'spm';
    end
    [h6, ~] = ft_headcoordinates(pt1, pt2, pt3,method);
end

% finding coordinates above threshold1 for montage 1

if roast
    thresholded_coords1 = SATA_CBL_Top_CD_Coords_By_Percentage(CD_array1,Vertices1,threshold1);
else
    thresholded_coords1 = SATA_CBL_Coords_Above_Threshold(CD_array1,Vertices1,threshold1);
end

if roast
    thresholded_coords1 = SATA_CBL_Transform(thresholded_coords1,h6);
end

% finding coordinates above threshold2 for montage 2
if roast
    thresholded_coords2 = SATA_CBL_Top_CD_Coords_By_Percentage(CD_array2,Vertices2,threshold2);
else
    thresholded_coords2 = SATA_CBL_Coords_Above_Threshold(CD_array2,Vertices2,threshold2);
end

if roast
    thresholded_coords2=SATA_CBL_Transform(thresholded_coords2,h6);
end

% finding common coordinates and number of matches(overlaps)
[n,common_coordinates] = SATA_CBL_Common_Coords(thresholded_coords1,thresholded_coords2);

%% plotting
figure ('Name','figure1','Position',[100 150 720 480])
% plotting the overall brain's coordinates
coordinates = Montage1.Target.Vertices;
if roast
    coordinates= SATA_CBL_Transform(coordinates,h6);
    coordinates(:,1) = -coordinates(:,1);
    thresholded_coords1(:,1) = -thresholded_coords1(:,1);
    thresholded_coords2(:,1) = -thresholded_coords2(:,1);
    common_coordinates(:,1) = -common_coordinates(:,1);
end
scatter3(coordinates(:,1),coordinates(:,2), coordinates(:,3),'MarkerEdgeColor',[.4 .4 .4],...
    'MarkerFaceColor','w','MarkerFaceAlpha',.2, 'MarkerEdgeAlpha',1,'HandleVisibility','off');
view ([90 0 0])
hold on;

% plotting Montage 1's thresholded coordinates
scatter3(thresholded_coords1(:,1),thresholded_coords1(:,2),...
    thresholded_coords1(:,3),'MarkerEdgeColor', [1 1 0],'MarkerFaceColor',[1 1 0]);
hold on;

% plotting Montage 2's thresholded coordinates
scatter3(thresholded_coords2(:,1),thresholded_coords2(:,2),...
    thresholded_coords2(:,3),'MarkerEdgeColor', 'c','MarkerFaceColor','c');
view ([90 0 0])
hold on;

% displaying number of matches between the two montages on the plot
str = {'Number of Overlaps:',string(n)};
annotation('textbox',[0.65 0.825 0.1 0.1],'String',str,'FitBoxToText','on','BackgroundColor','white');


% plotting the common coordinates between montage 1 and 2
scatter3(common_coordinates(:,1),common_coordinates(:,2),...
    common_coordinates(:,3),'MarkerEdgeColor','r','MarkerFaceColor','r');
view ([-90 0 0])
leg = cell(1,3);
leg{1} = char(inputname(1));
leg{2} = char(inputname(2));
leg{3} = 'Overlap';
legend(leg,'Location',"EastOutside","Interpreter","None")
end

