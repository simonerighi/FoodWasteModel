% Runs the simulations for the Committed vs Non-committed Setup 
% Requires Tables_for_calibration.xlsx in the same folder
% Please open the script to set parameter values.

% PARAMETERS
N=1000; % Number of agents in the network
tmax=400000; % maximum number of steps
resolution=10000; % every how many iterations i take a snapshot.
alpha=0.5; % Probability that a tie is strong
dact=0.1; % threshold of distance between Ai and Oj for which i initiate demotion or rewiring.
prob_unknown_connection=0.01; % probability that a rewire is done randomly and not with FOF.
%noise_sd=0; % random noise applied to O when trasformed into A.
mu=0.5; % opinion dynamics convergence parameter;
type_ntw='bern_pro_alpha'; % 'bern_fix_alpha': bernoulli random network with randomly assigned alpha
                           % 'bern_pro_alpha': bernoulli random network but with alpha assigned linearly according to alpha_i=degree_i/(max(degree)-min(degree))+max(degree)/(max(degree)-min(degree))
                           % 'patt_fix_alpha' % preferential attachment with fixed alpha
                           % 'patt_pro_alpha' % preferential attachment with linearly proportional alpha
diff_waste_in_pop=1; % says whether the distribution of wastes differs in different populations 
type_waste_dist='tria'; % norm % triangular or normal distributions
type_sim='zel2'; 
% type_sim:
% 'othe'  when you don't want to redefine the waste inside the runtime for committed agents (all types of simulations except committed vs non-committed)
% 'zelo' %run the zealot simulation with triangular distributed committed agents
% 'zel2' run the zealot simulation with unifrorm distributed committed agents

%------KEY PARAMETERS------------------------
dcd=[0.05 0.05]; % difference between Oi and Ai that triggers the cognitive dissonance mechanisms (first number correspond to first group)
lambda=[0.10 0.10]; % probability of each tie to exist in a E-R random network (first number correspond to first group)
share_pop=[1-0.0536 0.0536]; % share of population in group 1 and group 2 (first number correspond to first group)
mean_init_w=[0.5 0.2]; % mean of initial waste of groups 
std_init_w=[0.2 0.1]; % std of initial waste of groups
%---------------------------------------------


%----- EXPLORATION PARAMETERS---------
NSim=100; % on  how many simulations do i want to compute the density?
ap_ment=0:0.0025:0.05;  % openness of mind of zealots (committed agents)
% the range for variance of waste and opinion of committed agents is setted
% automatically to the maximum possible value.
pass=0.5;
%--------------------------------------


len_ap_ment=length(ap_ment);
% this script generates population based on available data.
% Note that the initial distribution of Waste and Opinion for committed
% agents is re-defined inside the code. Because committed are the subject
% of this numerical exploration  (see paper for calibration details).
generate_populations_zealots


% This sets the exploration of the variance of committed agents so that it
% does not exceed the minimum betweek the value defined (for opinion or
% waste) in the 
avg_zealots_actions=zeros(NSim,1);
avg_zealots_opinions=zeros(NSim,1);
for iii=1:NSim
    zealots=find(squeeze(types(:,iii)==2));
    avg_zealots_actions(iii)=mean(squeeze(A(zealots,iii)));
    avg_zealots_opinions(iii)=mean(squeeze(O(zealots,iii)));
end
maxvar=min(min([avg_zealots_actions avg_zealots_opinions]));
clear maxvar_zealots
varzel=[0:0.0025:maxvar]; % exploration range for variance in committed agents (zealots).
len_var=length(varzel);
meanavg_zealots=mean(avg_zealots_actions);

% Matrix and indexes initialization
convinced=zeros(len_ap_ment,len_var,NSim);
less_than_zealot=zeros(len_ap_ment,len_var,NSim);
less_than_zealot2=zeros(len_ap_ment,len_var,NSim);
less_than_point5=zeros(len_ap_ment,len_var,NSim);
lessthanmedia_low=zeros(len_ap_ment,len_var,NSim);
lessthanmedian_high=zeros(len_ap_ment,len_var,NSim);
Calldddaverage_waste_final=zeros(len_ap_ment,len_var,NSim);
std_waste_final=zeros(len_ap_ment,len_var,NSim);
average_waste_final=zeros(len_ap_ment,len_var,NSim);
convinced1=zeros(len_ap_ment,len_var,NSim);
convinced2=zeros(len_ap_ment,len_var,NSim);
less_than_zealot1=zeros(len_ap_ment,len_var,NSim);
A_keep=zeros(len_ap_ment,len_var,NSim,N);
O_keep=zeros(len_ap_ment,len_var,NSim,N);

% Compute the threshold values for initial waste to generate the figures
Q1_high = zeros(NSim,1);
Q3_low = zeros(NSim,1);
median_all = zeros(NSim,1);
median_low = zeros(NSim,1);
median_high = zeros(NSim,1);
for i=1:NSim
    Q1_high(i) = quantile(A(types(:,i)==1,i),0.25); % only for young
    Q3_low(i) = quantile(A(types(:,i)==2,i),0.75); % only for adults
    median_all(i) = median(A(types(:,i)==1,i));
    median_low(i) = median(A(types(:,i)==2,i));
    median_high(i) = median(A(types(:,i)==1,i));
end

% Iteration procedure that scans:
for j=1:len_ap_ment  % different values of interaction threshold for the committed
    for z=1:len_var % different variances in initial Waste and Opinion of the committed
        d_s=[0.10 ap_ment(j)]; %interaction thresholds for non-commited and committed (strong ties) for this simulation
        d_w=[0.10 ap_ment(j)]; %interaction thresholds for non-commited and committed (weak ties) for this simulation
        std_init_w=[0.2 varzel(z)]; % std of initial waste of groups for this simulation
        for i=1:NSim
            disp(['i= ' num2str(i) ' j= ' num2str(j) ' z= ' num2str(z)]);
            
            
            % calls the script containing the simulators
            [A_final,O_final,average_waste_final(j,z,i),std_waste_final(j,z,i),size_cluster,groupsize,dominated_by,A_init,O_init,types(:,i)]=fct_populations(N,tmax,alpha,dact,prob_unknown_connection,mu,type_ntw,diff_waste_in_pop,...
            type_waste_dist,d_s,d_w,dcd,lambda,share_pop,mean_init_w,std_init_w,type_sim,mixing,CD(:,i),O(:,i),A(:,i),types(:,i));
                   
            A_keep(j,z,i,:)=A_final; % save the final values of Waste (A)
            O_keep(j,z,i,:)=O_final; % save the final values of Opinions (O)
            
            % i compute the proportion of agents that exceed some threshold
            % with respect to initial waste levels.
            [convinced1(j,z,i),convinced2(j,z,i),less_than_zealot1(j,z,i),less_than_zealot2(j,z,i),less_than_point5(j,z,i),...
                lessthanmedia_low(j,z,i),lessthanmedian_high(j,z,i)]=num_convinced(size_cluster,dominated_by,groupsize,A_final,...
                Q1_high(i),Q3_low(i),median_all(i),median_low(i),median_high(i));

        end
        save('Exploration_Zealots.mat') 
    end
end


