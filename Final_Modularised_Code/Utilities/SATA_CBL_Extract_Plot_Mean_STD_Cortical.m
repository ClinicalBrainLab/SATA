function Mean_Std_of_Lobes = SATA_CBL_Extract_Plot_Mean_STD_Cortical(CD_array,tal_in,brain_region)
%SATA_CBL_Extract_Plot_Mean_STD_Cortical(CD_array,tal_in,brain_region)
%
%   Purpose:  extract the mean, standard deviation of CD and plot them for 
%             all cortical lobes.
%
%   Inputs:
%       tal_in          -     table of coordinates outputted from the 
%                             talairach client
%       CD_array        -     input array of current density values
%       brain_region    -     Region of the brain to be checked
%
%   Outputs:
%       Mean_Std_of_Lobes  -  table containg the means and standard
%                             deviations for various lobes.
%                         
%   if you have any queries please contact clinicalbrainlab@gmail.com

% extracting unique values of the different GYRI
if contains(brain_region,"Cerebrum")
lev2_values = ["Sub-lobar","Parietal Lobe","Occipital Lobe","Frontal Lobe","Limbic Lobe","Temporal Lobe"]; %frontal,parietal,temporal,occipital,sublobar,lymbic
elseif contains(brain_region,"Brainstem")
lev2_values = ["Midbrain"];
else
lev2_values = ["Posterior Lobe","Anterior Lobe"];
end

% number of possible cortical lobes
l = length(lev2_values);


if contains(brain_region,"Left") || contains(brain_region,"Right")
    brain_parts=1;

    % initialising the cortical column
    cortical=zeros(l,1);
    cortical=string(cortical);

    % initialising the mean column
    avg=zeros(l,1);

    % initialising the standard deviation column
    std_dev=zeros(l,1);

    % counter counting the number of columns that have been deleted
    deled=0;

    for x=1:l
        count = 0;
        records1=[];
        records2=[];

        % checking if the filters are valid for left hemisphere. if so return 
        % the corresponding recordnumbers, else return empty array

        if contains(brain_region,"Left")
            try
                evalc(char("records1 = SATA_CBL_Filter(tal_in,'RecordNumber',{{'Level1',brain_region},{'Level2',lev2_values(x)}}).';"));
            catch
                count= count+1;
            end
        end

        % checking if the filters are valid for right hemisphere. if so return 
        % the corresponding recordnumbers, else return empty array

        if contains(brain_region,"Right")
            try
                evalc(char("records2 = SATA_CBL_Filter(tal_in,'RecordNumber',{{'Level1',brain_region},{'Level2',lev2_values(x)}}).';"));
            catch
                count=count+1;
            end
        end

        % if both sets of record numbers are empty, delete the corresponding
        % column
        if count==1
            cortical(x-deled)=[];
            avg(x-deled)=[];
            std_dev(x-deled)=[];
            deled=deled+1;
            continue
        end
        
        % if atleast one column is not empty make an approprite addition to the
        % arrays
        records = union(records1,records2);
        temp = CD_array(records);
        cortical(x-deled)=lev2_values(x);
        avg(x-deled)=mean(temp);
        std_dev(x-deled)=std(temp);
    end
    
else
    brain_parts=2;
    
    % initialising the cortical column
    cortical=zeros(2*l,1);
    cortical=string(cortical);

    % initialising the mean column
    avg=zeros(2*l,1);

    % initialising the standard deviation column
    std_dev=zeros(2*l,1);

    % counter counting the number of columns that have been deleted
    deled=0;

    for x=1:l
        count = 0;
        records1=[];
        records2=[];

        % both

        if brain_parts==2
            try
                evalc(char("records1 = SATA_CBL_Filter(tal_in,'RecordNumber',{{'Level1','Left "+brain_region+"'},{'Level2',lev2_values(x)}}).';"));
            catch
                count= count+1;
            end
            try
                evalc(char("records2 = SATA_CBL_Filter(tal_in,'RecordNumber',{{'Level1','Right "+brain_region+"'},{'Level2',lev2_values(x)}}).';"));
            catch
                count=count+1;
            end
        end

        % if both sets of record numbers are empty, delete the corresponding
        % column
        if count==2
            cortical(2*x-deled)=[];
            avg(2*x-deled)=[];
            std_dev(2*x-deled)=[];
            
            cortical(2*x-deled-1)=[];
            avg(2*x-deled-1)=[];
            std_dev(2*x-deled-1)=[];
            deled=deled+2;
            continue
        end
        % if atleast one column is not empty make an approprite addition to the
        % arrays
        temp1 = CD_array(records1);
        cortical(2*x-deled)="Left "+lev2_values(x);
        avg(2*x-deled)=mean(temp1);
        std_dev(2*x-deled)=std(temp1);
        
        temp2 = CD_array(records2);
        cortical(2*x-deled-1)="Right "+lev2_values(x);
        avg(2*x-deled-1)=mean(temp2);
        std_dev(2*x-deled-1)=std(temp2);
    end
    
end

% return -1 if no coordinates are found
if isempty(cortical)
    Mean_Std_of_Lobes = -1;
    return
end

% form the table
Mean_Std_of_Lobes = table(cortical,avg,std_dev);
cortical =categorical(cortical);
l = length(cortical);

% figure
figure('Name','figure1','Position',[400 150 810 480]);
hold on

% getting desired rgb values
col = [0 0 0
    0 0 1
    1 0 0
    0 1 0
    1 1 0
    0 1 1
    1 0 1
    1 1 0.5
    0 0 0.5
    0 0.5 0
    0.5 0 0
    0.5 0 0.5
    0.5 0.5 0
    0 0 0.5];

% initialising the legend
leg = cell(1,l);

%plotting bar graph
for k = 1:l
    h = bar(cortical(k),avg(k));
    leg{k} = char(cortical(k));
    set(h,'FaceColor',col(k,:));
end
set(gca,'FontSize',14)
%leg{l+1} = "Average of Mean Current Density";

ylabel("Average Current Density",'FontSize',14);

er = errorbar(cortical,avg,std_dev,'HandleVisibility','off');   
er.LineStyle='none';
avg_avg = mean(avg);
%yline(avg_avg,':','LabelHorizontalAlignment','center','LineWidth',3); %,'HandleVisibility','off'
a = legend(leg,'Location',"EastOutside",'FontSize',12);

hold off
end