
%% Here data from 2 Efield for 6 masks 
% is collected in a .csv table
% Targets main: V1 and Retina 
% Other targets: (1) Optic tract, (2) nerve, (3) LGN, (4) Chiasm 

% field : 0.3mm in retina 
% Configuration 1: F9 and F10
% Configuration 2: Oz and Cz (v2 - rotated)

clear 

%% 
load_path = ['efields_masked\']; 

dir_path = dir([load_path, '*.mat']);

struct_priority = [2,2,2,2,2,2,2,2,1,1,1,1]; % 1 - more significant 
config_type = [1,2,1,2,1,2,1,2,1,2,1,2]; % 1 - F9, 2 - Oz 
mask_type = [1,1,2,2,3,3,4,4,5,5,6,6]; % see above 

table_collect_long = [];
k_table = 1; 

for i_file = 1:size(dir_path, 1) 
    
    %s_name = struct_names{i_file};
    f_name = [load_path dir_path(i_file).name];
    
    f1 = load(f_name);
    f1 = f1.data; 
    f1 = transpose(reshape(f1, 3, length(f1)/3)); 

    f1 = (sqrt(f1(:,1).^2 + f1(:,2).^2 + f1(:,3).^2));
    
    for i_f = 1:size(f1,1)
        
        table_collect_long(k_table,1) = mask_type(i_file);
        table_collect_long(k_table,2) = config_type(i_file);
        table_collect_long(k_table,3) = struct_priority(i_file);
        table_collect_long(k_table,4) = f1(i_f);        
        
        k_table = k_table + 1; 
    end
    
    
end 

%% 

col_names = {'Mask', 'Config', 'Priority', 'Efield'}; 
T = array2table(table_collect_long, 'VariableNames', col_names); 

writetable(T, [savepath, 'Data_6masks.csv']);
