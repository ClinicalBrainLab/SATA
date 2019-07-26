function weighted_table = SATA_CBL_Extract_Plot_WCD_Gyri(Vertices1,CD_array,tal_in,brain_region)
%SATA_CBL_Extract_Plot_Mean_Std_Gyri(CD_array,tal_in,brain_region)
%
%   Purpose:  extract the Weighted current density and plot them for
%             all gyri. Also plot the gyri on a scatter plot
%
%   Inputs:
%       tal_in          -     table of coordinates outputted from the
%                             talairach client
%       CD_array        -     input array of current density values
%       brain_region    -     Region of the brain to be
%       Vertices1       -     The overall coordinates after conversion to
%                             talairach's format
%
%   Outputs:
%       mean_std_table  -     table containg the weigthed current density
%                             of different gyri
%
%   if you have any queries please contact clinicalbrainlab@gmail.com

if contains(brain_region,"Left") || contains(brain_region,"Right")
    brain_parts=1;
else
    brain_parts=2;
end

% extracting unique values of the different GYRI
lev3_values = unique(table2array(tal_in(:,'Level3')));
lev3_values(ismember(lev3_values,'*')) = [];
lev3_values(ismember(lev3_values,'')) = [];

if brain_parts == 1
    
    % number of unique gyri
    l = length(lev3_values);
    
    % initialising the Gyrus column
    Gyrus=cell(l,1);
    
    % initialising the weighted mean column
    weighted = zeros(l,1);
    
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
                evalc('records1 = SATA_CBL_Filter(tal_in,''RecordNumber'',{{''Level1'',brain_region},{''Level3'',lev3_values(x)}}).'';');
            catch
                count= count+1;
            end
        end
        
        % checking if the filters are valid for right hemisphere. if so return
        % the corresponding recordnumbers, else return empty array
        
        if contains(brain_region,"Right")
            try
                evalc('records2 = SATA_CBL_Filter(tal_in,''RecordNumber'',{{''Level1'',brain_region},{''Level3'',lev3_values(x)}}).'';');
            catch
                count=count+1;
            end
        end
        
        
        % if both sets of record numbers are empty, delete the corresponding
        % column
        if count==brain_parts
            Gyrus(x-deled)=[];
            weighted(x-deled)=[];
            deled=deled+1;
            continue
        end
        
        % if atleast one column is not empty make an approprite addition to the
        % arrays
        records = union(records1,records2);
        temp = CD_array(records);
        Gyrus{x-deled}=char(lev3_values(x));
        weighted(x-deled)=length(temp)*mean(temp);
        
    end
else
    % number of unique gyri
    l = length(lev3_values);
    
    % initialising the Gyrus column
    Gyrus=cell(2*l,1);

    
    % initialising the weighted mean column
    weighted = zeros(2*l,1);
    
    
    % counter counting the number of columns that have been deleted
    deled=0;
    
    for x=1:l
        records1=[];
        records2=[];
        
        % checking if the filters are valid for left hemisphere. if so return
        % the corresponding recordnumbers, else return empty array
        
        try
            evalc('records1 = SATA_CBL_Filter(tal_in,''RecordNumber'',{{''Level1'',"Left "+brain_region},{''Level3'',lev3_values(x)}}).'';');
        catch
        end
        
        
        % checking if the filters are valid for right hemisphere. if so return
        % the corresponding recordnumbers, else return empty array
        
        try
            evalc('records2 = SATA_CBL_Filter(tal_in,''RecordNumber'',{{''Level1'',"Right "+brain_region},{''Level3'',lev3_values(x)}}).'';');
        catch
        end

        
        % if a set of record numbers is empty, delete the corresponding
        % column
        if isempty(records1)
            Gyrus(2*x-deled-1)=[];
            weighted(2*x-deled-1)=[];
            deled = deled +1;
        else
            temp1 = CD_array(records1);
            Gyrus{2*x-deled-1}=char("Left "+lev3_values(x));
            weighted(2*x-deled-1)=length(temp1)*mean(temp1);
        end
        
        % if a set of record numbers is empty, delete the corresponding
        % column
        if isempty(records2)
            Gyrus(2*x-deled)=[];
            weighted(2*x-deled)=[];
            deled=deled+1;
        else
            temp2 = CD_array(records2);
            Gyrus{2*x-deled}=char("Right "+lev3_values(x));
            weighted(2*x-deled)=length(temp2)*mean(temp2);
        end
        
    end
end

% return -1 if there are no coordinates
if isempty(Gyrus)
    weighted_table = -1;
    return
end

% form the table
weighted_table = table(Gyrus,weighted);

% sorting accoring to descending
[~, weighted_order] = sort(weighted);
weighted_order = flip(weighted_order);
l = length(Gyrus);

% taking top 12
if l>12
    Gyrus = Gyrus(weighted_order<=12);
    l=12;
    weighted = weighted(weighted_order<=12);        
end
disp(Gyrus);
% sorting accoring to descending
[~, weighted_order] = sort(weighted);
weighted_order = flip(weighted_order);

% getting gyri in correct order for plotting
Gyrus_2 =categorical(Gyrus,'Ordinal',false);
Gyrus = reordercats(Gyrus_2,Gyrus(weighted_order,:));

% plotting
figure('Name','figure1','Position',[100 150 720 480]);
hold on

% creating the colors for the plot
k = ceil(l/2);

b1 =zeros(k,1);
g1 =((1:k)./k).';
r1 = (ones(1,k)-(1:k)./k).';

g2 = (ones(1,l-k)-(1:l-k)./(l-k)).';
r2 = zeros(l-k,1);
b2 = ((1:l-k)./(l-k)).';

r= [r1;r2];
g= [g1;g2];
b=[b1;b2];

col = [r g b];

% plotting the bar graph
Gyrus_temp = Gyrus(weighted_order);

weighted_temp = weighted(weighted_order);

for k =1:l
    h = bar(Gyrus_temp(k),weighted_temp(k));
    set(h,'FaceColor',col(k,:));
end

ylabel('Weighted Current Density');
hold off

%% plotting the coordinates

figure('Name','figure2','Position',[900 150 540 384]);

coordinates= Vertices1;
scatter3(coordinates(:,1),coordinates(:,2), coordinates(:,3),30,...
    'MarkerEdgeColor',[.4 .4 .4],...
    'MarkerFaceColor',[0.8 0.8 0.8],'MarkerFaceAlpha',.2, 'MarkerEdgeAlpha',1);
hold on;

% assuming discrete brain region i.e. left/right is being used

Vertices2 = [];
cd = [];
store= cell(l,2);
count=0;
for k =1:l
    
    Gyrus_temp = string(Gyrus_temp);
    if brain_parts == 2
        brain_side = strsplit(Gyrus_temp(k)," ");
        gyrus_tempmain = brain_side(2);
        if length(brain_side)>2
            for t = 3:length(brain_side)
                gyrus_tempmain =gyrus_tempmain +" "+brain_side(t);
            end
        end
        brain_side = brain_side(1);
        evalc('coords = SATA_CBL_Filter(tal_in,{''RecordNumber'',''XCoor'',''YCoor'',''ZCoor''},{{''Level1'',brain_side+" "+brain_region},{''Level3'',gyrus_tempmain}});');
        records = coords(:,1);
        [~,w] =size(coords);
        coords = coords(:,2:w);
    else
        evalc('coords = SATA_CBL_Filter(tal_in,{''RecordNumber'',''XCoor'',''YCoor'',''ZCoor''},{{''Level1'',brain_region},{''Level3'',Gyrus_temp(k)}});');
        records = coords(:,1);
        [~,w] =size(coords);
        coords = coords(:,2:w);
    end
    %count = count+length(coords);
    store(k,1)={coords};
    [le,~]=size(coords);
    store(k,2)={le};
    Vertices2 = [Vertices2;coords];
    cd = [cd; CD_array(records,:)];
%     scatter3(coords(:,1),coords(:,2),...
%         coords(:,3),'MarkerEdgeColor', col(k,:),'MarkerFaceColor',col(k,:));
    
    hold on;
end

% %% detecting outliers
% coords = Vertices2;
% x = coords(:,1);
% z = coords(:,3);
% y = coords(:,2);
% 
% xp = mean(x);
% yp = mean(y);
% zp = mean(z);
% 
% distances = ((x-xp).^2 + (y-yp).^2+ (z-zp).^2)./cd; 
% 
% binary_vector = isoutlier(distances,"mean");
% for k =1:l
%     sep = cell2mat(store(k,2));
%     cur_bin_vec = binary_vector(1:sep);
%     binary_vector = binary_vector(sep:end);
%     coords = cell2mat(store(k,1));
%     coords = coords(~cur_bin_vec,:);
%     scatter3(coords(:,1),coords(:,2),...
%         coords(:,3),'MarkerEdgeColor', col(k,:),'MarkerFaceColor',col(k,:));
%     hold on;
% end


for k =1:l
    coords = cell2mat(store(k,1));
    scatter3(coords(:,1),coords(:,2),...
        coords(:,3),'MarkerEdgeColor', col(k,:),'MarkerFaceColor',col(k,:));
    hold on;
end

%% final display
view ([-90 0 0])
colormap(col)
for k =1:length(weighted_temp)
    weighted_temp(k) = round(weighted_temp(k),2);
end

c = colorbar();
c.Ticks = (1:l)/l;
c.TickLabels = string(weighted_temp);
set( c, 'YDir', 'reverse' );

hold off;