function [coordinatesYouNeed,Electric_field] = SATA_CBL_Retrieve_Coords_Roast(folder_in)
%SATA_CBL_Retrieve_Coords_Roast(folder_in)
%
%   Purpose: retrieve the brain coordinates and electric field values
%   from a folder containing roast output.
%
%   Input:
%       folder_in   - name of the folder under Data > Roast
%
%   Output:
%       coordinatesYouNeed  - coordinates of the brain
%       Electric_field      - norm values of the coordinates corresponding
%                             to the coordinates of th brain.
%
%   if you have any queries please contact clinicalbrainlab@gmail.com
    
% find current working directory
mydir  = pwd;
idcs   = strfind(mydir,filesep);
newdir = mydir(1:idcs(end));

% find directory to be saved under
save_dir = newdir + "Data" +string(filesep)+ "Roast"+string(filesep)+"Roast_Raw";
working_dir = save_dir+string(filesep)+folder_in+string(filesep);

% finding the appropriate file containing coordinates
a = dir(char(working_dir+"*.mat"));
for x = 1:length(a)
if a(x).name(end-10)=="T" && ~isnan(str2double(a(x).name(end-11)))&& ~isnan(str2double(a(x).name(end-9)))
load(working_dir+a(x).name)
end
end

% removing scalp coordinates
ind = elem(elem(:,5)==2,1:4);
ind = unique(ind(:));
coordinatesYouNeed = node(ind,1:3);

% finding the appropriate file containing electric field vectors
a = dir(char(working_dir+'*e.pos'));
f = fopen(char(a.folder+string(filesep)+a.name));
e = textscan(f,'%d %f %f %f');
a = e{1};
a(1)=[];
b = e{2};
b(1)=[];
c = e{3};
c(1)=[];
d = e{4};
d(1)=[];
e = [double(a) b c d];
e = e(ind,:);

% extracting the norm of the vectors 
Electric_field = sqrt(e(:,4).^2 + e(:,2).^2+ e(:,3).^2);
folder = upper(folder_in);
eval(char(folder+".Target.FaceVertexCData=Electric_field;"));
eval(char(folder+".Target.Vertices = coordinatesYouNeed;"));
cd ..
save(char("Data" +string(filesep)+ "Roast"+string(filesep)+"Roast_Sata_mat_files"+string(filesep)+folder),folder);
cd Final_Modularised_Code
end

