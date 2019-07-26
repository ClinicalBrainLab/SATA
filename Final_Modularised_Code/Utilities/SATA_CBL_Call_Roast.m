function SATA_CBL_Call_Roast(electrode_loc1,electrode_loc2,anode_current,cathode_current,electrode_size,electrode_type,cap_type, head_model)
%SATA_CBL_Call_Roast(electrode_loc1,electrode_loc2,electrode_size,electrode_type
%               ,cap_type, head_model)
%
%   Purpose: Call roast and save the results in a new folder under the data
%   directory
%
%   Input:
%       electrode_loc1  - location of anode
%       electrode_loc2  - location of cathode
%       anode_current   - current in at anode (+ve)
%       cathode_current - current out at cathode (-ve)
%       electrode_size  - array of electrode size. eg: [10 10 3]
%       electrode_type  - char array of electrode type
%       cap_type        - char array of EEG cap type
%       head_model      - path of head model
%
%   Output:
%       The resulting files from roast are+ saved under a new folder in the
%       data>roast directory eith the naming convension:
% 
% (electrode_loc1)_(electrode_loc2)_(electrode_size(1))_(electrode_size(2))
%
%   Notes:
%       -Run from the Final_Modularised_Code directory
%
%   Example of Use: 
%        SATA_CBL_Call_Roast('TP7','F3',2,-2,[50 50 3])
%
%   if you have any queries please contact clinicalbrainlab@gmail.com

% move to the roast directory
cd ..
cd roast

% assign default head model
if nargin<=7
    head_model = "example"+string(filesep)+"MNI152_T1_1mm.nii";
end
head_model = char(head_model);

% assign default cap type
if nargin<=6
    cap_type = '1005';
end

% assign default electrode type
if nargin<=5
    electrode_type='pad';
end

% assign folder name to be created
folder = electrode_loc1+"_"+electrode_loc2+"_"+string(electrode_size(1))+"_"+string(electrode_size(2));

% find current working directory
mydir  = pwd;
idcs   = strfind(mydir,filesep);
newdir = mydir(1:idcs(end));
working_dir = mydir +string(filesep)+ "example";


% create a temporary copy of names of files in the current working
% directory
copy_of_files = dir(char(working_dir));
l = length(copy_of_files);
names = {copy_of_files(1:l).name};

save_dir = newdir + "Data" +string(filesep)+ "Roast"+string(filesep)+"Roast_Raw";
name_check = dir(char(save_dir));
name_check = {name_check(1:end).name};

if any(ismember(name_check,folder))
    errordlg('Montage with same name exists in Roast_Raw folder');
    return
end
% call the roast function
roast(head_model,{electrode_loc1,anode_current,electrode_loc2,cathode_current},'electype',electrode_type...
    ,'elecsize',electrode_size, 'captype',cap_type);

% check the new files in the working directory
new_copy = dir(char(working_dir));
l = length(new_copy);

% find directory to be saved under
mkdir(char(save_dir),char(folder));
save_dir = save_dir + string(filesep) + folder;


% move the new files to the save directory
for x =1:l
    name_cur = new_copy(x).name;
    if ~any(ismember(names,name_cur))
        movefile(char(working_dir+string(filesep)+name_cur),char(save_dir));
    end
end

% convert to SATA input
SATA_CBL_Retrieve_Coords_Roast(folder);

end

