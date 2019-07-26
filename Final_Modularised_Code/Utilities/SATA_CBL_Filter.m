function matrix_out = SATA_CBL_Filter(table_in,output_column,filter_in)
%SATA_CBL_Filter(table_in,output_column,filter_in)
%
%   Purpose: apply multiple filters to a table and output a matrix
%
%   Inputs:
%       table_in            - table to be read in
%       output_column       - column desired as output or array of columns 
%                             desired as output
%       filter_in           - multiple filters, placed in a cell array.
%
%   Output:
%       matrix_out          - a vector or a matrix
%
%   Note:
%       1)Each filter must be of the form:
%               filter = {column_to_be_filtered,filter_value}
%       2)All filterss must finally be placed in a cell array
%               Eg {filter1,filter2,...}
%                  Where
%                   filter1 = {column_to_be_filtered_1,filter_value_1}
%                   filter2 = {column_to_be_filtered_2,filter_value_2}
%       3)To prevent an error being thrown if the output matrix is empty,
%       please comment lines 71 - 77
%
%   if you have any queries please contact clinicalbrainlab@gmail.com

    % checking to see if filters have been inputted
    if nargin<=2
        error("No filters applied");
    end
    
    % seperating column to be filtered into active_filter
    active_filter = {};
    active_filter{length(filter_in)}="";
    
    % seperating filter values into filter_val
    filter_val = {};
    filter_val{length(filter_in)}="";

    for x = 1:(length(filter_in))
        temp = filter_in{x};
        active_filter{x} = char(temp{1});
        filter_val{x} = char(temp{2});
    end

    % make a copy of the columns to be filtered
    % active_filter = string(active_filter);
    table_temp = table_in(:,active_filter);
    
    % primary here is initialised as a logical array of 1s
    primary = ones(1,height(table_in)).';

    % each value of the column to be filtered is checked against the 
    % corresponding filter value to return a secondary logical array
    
    % bitwise AND is carried out for primary and secondary to see which
    % rows are relevant
    for x = 1:length(filter_in)
        a = filter_val{x};
        b = string(table2array(table_temp(:,active_filter{x})));
        secondary = a==b;
        primary = primary&secondary;
    end
    
    % outputting the relevent rows after filtering with the columns desired
    % by the user
    matrix_out = table2array(table_in(primary,output_column));
    
    % checking whether the set of filters being used is valid
    if isempty(matrix_out)
        disp("Your choice filters returned an empty table")
        for y=1:length(filter_in)
            disp(filter_in{y})
        end
        error('Invalid choice of filters')
    end
     
end



