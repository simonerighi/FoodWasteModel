function [dominated_by,min_clu_1,max_clu_1,min_clu_2,max_clu_2,size1,size2,W_avg_pos_dom]=fct_test_significance(NClu,types,share_pop,size_cluster,groupsize,Number_assigned_cluster,A,C)
% Tests whenever the number of individuals of a given type in a given group
% is surprisingly large.
% dominated_by indicates whether a given cluster is dominated by agents of
% type 1 or two (this is the case if in the group there is less than
% expected_avg-two_std_dev agents of the opposite type.
% For each clusteer also the basin of attraction is computed for each type
% (min_clu_1,max_clu_1,min_clu_2,max_clu_2), and its size (size1, size2).
% Finally the  average position of clusters dominated by type x
% (W_avg_pos_dom) is computed.


% this can be generalized to test the expectations wrt to any population

% valid for each cluster i 
dominated_by=zeros(NClu,1);
min_clu_1=zeros(NClu,1);
max_clu_1=zeros(NClu,1);
min_clu_2=zeros(NClu,1);
max_clu_2=zeros(NClu,1);
size1=zeros(NClu,1);
size2=zeros(NClu,1);

for i=1:NClu
    expected_avg(i)=share_pop(1)*size_cluster(i);
    two_std_dev(i)=2*sqrt(size_cluster(i)*share_pop(1)*(1-share_pop(1))); % sqrt(n*p*(1-p))*2
    min_normal=expected_avg(i)-two_std_dev(i);
    max_normal=expected_avg(i)+two_std_dev(i);
    
    if groupsize(i,1)<min_normal % if there are very few of the agents of type 1
        dominated_by(i)=2; %the group is dominated by 2
    end
    if groupsize(i,1)>max_normal % if there are very few of the agents of type 2
        dominated_by(i)=1; %the group is dominated by 1
    end
    

    % size of the basin of acctraction
    if sum((Number_assigned_cluster==i) & (types==1))>0
        min_clu_1(i,1)=min(A(((Number_assigned_cluster==i) & (types==1))));
        max_clu_1(i,1)=max(A(((Number_assigned_cluster==i) & (types==1)))); 
        size1(i,1)=max_clu_1(i,1)-min_clu_1(i,1);
    else
        min_clu_1(i,1)=NaN;
        max_clu_1(i,1)=NaN;
        size1(i,1)=NaN;
    end
    if sum((Number_assigned_cluster==i) & (types==2))>0
        min_clu_2(i,1)=min(A(((Number_assigned_cluster==i) & (types==2))));
        max_clu_2(i,1)=max(A(((Number_assigned_cluster==i) & (types==2)))); 
        size2(i,1)=max_clu_2(i,1)-min_clu_2(i,1);

    else
        min_clu_2(i,1)=NaN;
        min_clu_2(i,1)=NaN;
        size2(i,1)=NaN;
    end 
end

% average position of clusters dominated by type x
W_avg_pos_dom=zeros(2,1);

for i=1:2
    W_avg_pos_dom(i)=sum(size_cluster(dominated_by==i)'.*C(dominated_by==i))/sum(size_cluster(dominated_by==i));
end
