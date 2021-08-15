% This script redefines the Initial opinions and Waste levels of Zealots
% (committed) agent. The script is only used for simulations of
% type_sim='zelo' or 'zel2'. 
% For 'zelo' the initialization is to a triangular distribution with the average and the std passed in input.
% For 'zel2' the initialization is to a Uniform distribution between
% avg_zealots-std_init and avg_zealots+std_init


zealots=find(types==2);
avg_zealots_actions=mean(A(zealots));
avg_zealots_opinions=mean(O(zealots));

if strcmp(type_sim,'zelo')==1
    if std_init_w(2)>0
        pd1=makedist('Triangular',avg_zealots_actions-std_init_w(2),avg_zealots_actions,avg_zealots_actions+std_init_w(2));
        pd2=makedist('Triangular',avg_zealots_opinions-std_init_w(2),avg_zealots_opinions,avg_zealots_opinions+std_init_w(2));
    end
end
if strcmp(type_sim,'zel2')==1
    if std_init_w(2)>0
        pd1=makedist('Uniform',avg_zealots_actions-std_init_w(2),avg_zealots_actions+std_init_w(2));
        pd2=makedist('Uniform',avg_zealots_opinions-std_init_w(2),avg_zealots_opinions+std_init_w(2));
    end
end

for i=1:length(zealots)
    if std_init_w(2)>0
        A(zealots(i))=random(pd1);
        O(zealots(i))=random(pd2);
    else
        A(zealots(i))=avg_zealots_actions;
        O(zealots(i))=avg_zealots_opinions;
    end
    
    CD(zealots(i))=abs(A(zealots(i))- O(zealots(i)));
end

