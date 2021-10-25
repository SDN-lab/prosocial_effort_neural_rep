clear all

file_name = 'all_data_fmri_wo_110_125_132_May21'; % specify data **
load([file_name, '.mat']); % .mat file saved from the behavioural script that contains all participants data in 's'

clearvars -except data numsubs sub_files keep

s.PM.group = 'all_data_fmri_wo_110_125_132_May21';

for k = 1:numsubs
    
    clear subj
    
    s.PM.ID{1, k}.ID{1,1} = sub_files{k};
    
    subj.agent = data.agent(:,k);
    subj.choice = data.chosen(:,k);
    subj.reward = data.reward(:,k);
    subj.effort = data.effort(:,k);
    subj.RT = data.RT(:,k);
    subj.success = data.success(:,k);
    subj.force = data.force(:,k);
    
    s.PM.beh{1, k} = subj;
    
end

save('all_data_fmri_wo_110_125_132', 's')