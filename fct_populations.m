function [A_final,O_final,average_waste_final,std_waste_final,...
   size_cluster,groupsize,dominated_by,A_init,O_init,...
    types]...
=fct_populations(N,tmax,alpha,dact,prob_unknown_connection,mu,type_ntw,~,...
    ~,d_s,d_w,dcd,lambda,share_pop,mean_init_w,std_init_w,type_sim,PASS,CD,O,A,types)

% Redefine opinion and waste levels of Committed agents if the simulation
% is about their role.
if strcmp(type_sim,'zelo')==1 || strcmp(type_sim,'zel2')==1
    Change_zealots;
end

% Network initialization (generate a weighted E-R network with density
% lambda. Various options are available concerning how to assign the
% strong/weak ties (main script for details).
Adj=fct_create_rnd_populations(N,types,type_ntw,alpha,d_s,d_w,lambda,PASS);

% Initialize a few indicators for each agent.
ngoodinteractions=zeros(N,1); % number of interactions with convergence.
ninteractions=zeros(N,1); % number of times that individual has been selected.
counttimes=1;


A_init=A';
O_init=O';


% RUNTIME (each iteration two agents are selected for interaction)
for t=1:tmax
    % select two individuals
    [i,j]=Individual_selection(Adj,N);
   
    % run the opinion dynamics mechanism
    [O(i),O(j),suci,sucj]=opinion_dynamics(O(i),O(j),Adj(i,j),Adj(j,i),mu);
    
    % check A-O and evolve network if necessary
    [Adj]=network_evolution(O(i),O(j),A(i),A(j),i,j,Adj,d_s,d_w,dact,prob_unknown_connection,types);

     A=Compute_Waste(O,A,CD,ninteractions,ngoodinteractions); 
    
     
    % update the number of interactions involving i and j (all and the
    % successful ones). NOT SURE IT SERVES ANY PURPOSE ANYMORE
    ninteractions(i)=ninteractions(i)+1;
    ninteractions(j)=ninteractions(j)+1;
    if suci==1; ngoodinteractions(i)=ngoodinteractions(i)+1; end
    if sucj==1; ngoodinteractions(j)=ngoodinteractions(j)+1; end
end

% Save the final values of A and O.
A_final(:,counttimes)=A;

O_final(:,counttimes)=O;

average_waste_final=sum(A)/N;
std_waste_final=std(A);


% Calculate the clusters formed at the end of the simulation and how many
% agents of each type there are
[NClu,C,size_cluster,groupsize,Number_assigned_cluster]=fct_improvement_computation_cluster(A,O,N,dcd,types);

[dominated_by,min_clu_1,max_clu_1,min_clu_2,max_clu_2,size1,size2,W_avg_pos_dom]=fct_test_significance(NClu,types,share_pop,size_cluster,groupsize,Number_assigned_cluster,A,C);




