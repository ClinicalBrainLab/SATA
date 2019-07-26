function table_out = SATA_CBL_Call_Talairach(mat_in)
%CBL_call_talairach(mat_in)
%
%   Purpose: integrates the talairach client with MATLAB
%
%   Inputs:
%       mat_in      -     table of coordinates to be fed into the talairach
%                         client
%
%   Outputs:
%       table_out   -     talairach client's output in the form of a MATLAB
%                         table
%
%   Processess:
%       -The function opens up the talairach client
%       -The user has to choose the input file as 
%        Choose this input file.txt
%       -The setting to be choosen is the nearest gray matter
%       -The user must click the search button and close the talairach
%        client
%
%   if you have any queries please contact clinicalbrainlab@gmail.com

str = computer('arch');

% entering talairach client's directory
mydir  = pwd;
idcs   = strfind(mydir,filesep);
newdir = mydir(1:idcs(end));
if str == "glnxa64"
tal_dir = string(newdir)+"Utilities"+filesep+"talairach"+filesep;
else
tal_dir = string(newdir)+filesep+"Utilities"+filesep+"talairach"+filesep;
end
% writing the matrix into a text file to be read using the talairach client
cd ..
cd Utilities
cd Talairach
dlmwrite('Choose this input file.txt',mat_in,'delimiter','\t');
cd ..
cd ..
cd Final_Modularised_Code
% starting the talairach client
%creates dialog box as a GUI
mydlg = warndlg('Close Talairach, and then close this to continue execution');
switch str
    case 'win64'
        system(char(tal_dir+"talairach.jar"));
    case 'maci64'
        system(char("open "+tal_dir+"talairach.jar"));
    case 'glnxa64'
        cd ..
        system(char("java -jar Utilities/Talairach/talairach.jar"));
        cd Final_Modularised_Code
end
if str ~= "win64"
    waitfor(mydlg);

    
% reading in the output of the talairach client
cd ..
table_out = readtable("Utilities/Talairach/Choose this input file.td.txt","Delimiter","\t");

% deleting the files created during the usage of this function
system(char('rm Utilities/Talairach/"Choose this input file.txt"'));
system(char('rm Utilities/Talairach/"Choose this input file.td.txt"'));
cd Final_Modularised_Code

else
    
waitfor(mydlg);

% reading in the output of the talairach client
table_out = readtable(tal_dir+"Choose this input file.td.txt","Delimiter","\t");

% deleting the files created during the usage of this function
system(char('del '+tal_dir+'"Choose this input file.txt"'));
system(char('del '+tal_dir+'"Choose this input file.td.txt"'));

end
end