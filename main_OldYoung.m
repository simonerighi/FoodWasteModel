% Runs the simulations for the Young vs Old Setup 
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
type_sim='othe'; %zelo for zealots (zel2 distribution is uniform in 01 while zelo are triangular)
% type_sim:
% 'othe'  when you don't want to redefine the waste inside the runtime for committed agents (all types of simulations except committed vs non-committed)
% 'zelo' %run the zealot simulation with triangular distributed committed agents
% 'zel2' run the zealot simulation with unifrorm distributed committed agents

%------KEY PARAMETERS------------------------
% the first value is for young, the second for adults (this applies to all
% variables of this type).
dcd=[0.05 0.15]; % difference between Oi and Ai that triggers the cognitive dissonance mechanisms
lambda=[0.10 0.10]; % probability of each tie to exist in a E-R random network
share_pop=[0.4185 1-0.4185]; % share of population in group 1young and group 2adults
mean_init_w=[0.67 0.33]; % mean of initial waste of groups
std_init_w=[0.33 0.33]; % std of initial waste of groups
%---------------------------------------------


%----- EXPLORATION PARAMETERS---------
NSim=100; % on how many simulations do i want to compute the density?
disassort=0:0.05:1;  % level of mixing
ap_ment=0.01:0.05:0.16; % openness of mind of committed
%---------------------------------------------

% Matrix and indexes initialization
len_ap_ment=length(ap_ment); 
len_disassort=length(disassort); 
convinced=zeros(len_ap_ment,len_disassort,NSim);
less_than_zealot=zeros(len_ap_ment,len_disassort,NSim);
less_than_zealot2=zeros(len_ap_ment,len_disassort,NSim);
less_than_point5=zeros(len_ap_ment,len_disassort,NSim);
lessthanmedia_low=zeros(len_ap_ment,len_disassort,NSim);
lessthanmedian_high=zeros(len_ap_ment,len_disassort,NSim);
Calldddaverage_waste_final=zeros(len_ap_ment,len_disassort,NSim);
std_waste_final=zeros(len_ap_ment,len_disassort,NSim);
average_waste_final=zeros(len_ap_ment,len_disassort,NSim);
convinced1=zeros(len_ap_ment,len_disassort,NSim);
convinced2=zeros(len_ap_ment,len_disassort,NSim);
less_than_zealot1=zeros(len_ap_ment,len_disassort,NSim);
A_keep=zeros(len_ap_ment,len_disassort,NSim,N);
O_keep=zeros(len_ap_ment,len_disassort,NSim,N);


% this script generates population based on available data (see paper for calibration details).
generate_populations 

% Compute the threshold values for initial waste to generate the figures
Q1_high = mean(quantile(A(types==1),0.25)); % Quartile 25 for young
Q3_low = mean(quantile(A(types==2),0.75)); % Quantile 75 for adults
median_all = mean(median(A)); % Median Waste of all <-- NOTE: THIS USED TO BE ONLY FOR TYPES 1 (ERROR)
median_low= mean(median(A(types==2))); % Median Waste of adults
median_high = mean(median(A(types==1))); % Median Waste of young


% Iteration procedure that scans:
for j=1:len_ap_ment % different values of d_int of the young.
    for z=1:len_disassort % different levels of disassortativity in the network linking two groups
        d_s=[ap_ment(j) 0.06]; %interaction thresholds for young and adults (strong ties)
        d_w=[ap_ment(j) 0.06]; %interaction thresholds for young and adults (weak ties)
        mixing=disassort(z); % for this simulation this keeps the level of disassortativity
        for i=1:NSim % repeat for statistics
            disp(['i= ' num2str(i) ' j= ' num2str(j) ' z= ' num2str(z)]);
            
            % calls the script containing the simulators
  
     [A_final,O_final,average_waste_final(j,z,i),std_waste_final(j,z,i),size_cluster,groupsize,dominated_by,A_init,O_init,types(:,i)]=fct_populations(N,tmax,alpha,dact,prob_unknown_connection,mu,type_ntw,diff_waste_in_pop,...
            type_waste_dist,d_s,d_w,dcd,lambda,share_pop,mean_init_w,std_init_w,type_sim,mixing,CD(:,i),O(:,i),A(:,i),types(:,i));
            
            % save the final values of Waste (A) and of Opinion (O)
            A_keep(j,z,i,:)=A_final;
            O_keep(j,z,i,:)=O_final;
            
            % compute the proportion of agents that exceed some threshold
            % with respect to initial waste levels.
            [convinced1(j,z,i),convinced2(j,z,i),less_than_zealot1(j,z,i),less_than_zealot2(j,z,i),less_than_point5(j,z,i),lessthanmedia_low(j,z,i),lessthanmedian_high(j,z,i)]=num_convinced(size_cluster,dominated_by,groupsize,A_final,Q1_high,Q3_low,median_all,median_low,median_high);
            
        end
        save('Exploration_YoungAdults.mat') 
    end
end
