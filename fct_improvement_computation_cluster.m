function [NClu,C,size_cluster,groupsize,Number_assigned_cluster]=fct_improvement_computation_cluster(A,O,N,dcd,types)
% Verifies which groups are formed at the end of the simulation and
% compute the size of each cluster (size_cluster) and the number of agents
% of each type (groupsize).

% First compute the number of active cluster with the procedure of Carletti
% (2006)
[~,NClu]=deridda_index(O,1/N); % divide the Opinion space in segments of max(dcd)

% then cleate NClu Clusters, keep the Assignement of agents to each
% clusters AND the centroid of the cluster
[Number_assigned_cluster,C]=kmeans(O,NClu); % Get a clusterization in NCLU clusters



mindist=0;
while mindist<max(dcd) % while there are clusters whose distance between the centroids is still < than the parameter that stops the convergence
    
    clear dist
    dist=zeros(length(C),length(C));
    % Compute the matrix of distances between centroids 
    for i=1:length(C)
        for j=1:length(C)
            dist(i,j)=abs(C(i)-C(j));
            if i==j; dist(i,j)=1; end % the diagonal is set to a big number so that it does not intefere
        end
    end

    [mindist,I] = min(dist(:)); %I compute the minimum distance between two clusters
    %[I_Row,I_Col]=ind2sub(size(dist),I);
    if mindist<max(dcd) % if the minimum distance between the two is below threshold
        %Number_assigned_cluster(Number_assigned_cluster==j)=i;
        NClu=NClu-1; % then it means that the two clusters are one and the number of clusters is indeed less than NClu
    end
    
    [Number_assigned_cluster,C]=kmeans(O,NClu); % Get a clusterization in NCLU clusters (new NClu)
    
end
% recompute C's on the base of Waste
for i=1:NClu
    C_A(i)=mean(A(Number_assigned_cluster==i));
end

[C_A_sort,IX]=sort(C_A,'ascend');
Number_assigned_cluster2=zeros(length(Number_assigned_cluster),1);
for i=1:NClu
    Number_assigned_cluster2(Number_assigned_cluster==IX(i))=i;
end
clear Number_assigned_cluster C C_A
Number_assigned_cluster=Number_assigned_cluster2;
C=C_A_sort;


size_cluster=zeros(length(C),1);
groupsize=zeros(length(C),2);
% plot the number of clusters
for i=1:NClu% for each cluster
    size_cluster(i)=sum(Number_assigned_cluster==i); % get the total size of this cluster
    for j=1:max(types)
        groupsize(i,j)=sum((Number_assigned_cluster==i)+(types==j)==2);
    end
end

