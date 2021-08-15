function [convinced1,convinced2,less_than_zealot1,less_than_zealot2,less_than_point5,lessthanmedian_low,lessthanmedian_high]=num_convinced(size_cluster,dominated_by,groupsize,A_final,Q1_high,Q3_low,median_all,median_low,median_high)
% compute several measures of how many people were convinced or moved their
% waste level above or below certain limits

% number of agents of the first type that end up in groups dominated by the second type.
convinced1=0;
for a=1:length(size_cluster)
    if dominated_by(a)==2
        convinced1=convinced1+groupsize(a,1);
    end
end

% vice-versa
convinced2=0;
for a=1:length(size_cluster)
    if dominated_by(a)==1
        convinced2=convinced2+groupsize(a,2);
    end
end

% extreme values: number below the initial minimum of the first group and
% above the maximum of the second.
less_than_zealot1=length(find(A_final<Q1_high));
less_than_zealot2=length(find(A_final>Q3_low));


% proportion of agents above 0.5 at end of the simulatiom (for all, and ofr
% the group with low and with high initial average waste.
less_than_point5=length(find(A_final<median_all));

lessthanmedian_low=length(find(A_final>median_low));
lessthanmedian_high=length(find(A_final<median_high));