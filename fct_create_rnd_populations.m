function Adj=fct_create_rnd_populations(N,types,type_ntw,alpha,d_s,d_w,lambda,PASS)
% This function create a random network linking the agents in the
% population.
% N: is the population size.
% types: is the vector that contains the type of each agent
% type_ntw: 
%        'bern_fix_alpha' where strong and weak ties are assigned with probability alpha independent of agents degree.
%        'bern_pro_alpha' where more connected nodes are less likely to get strong connections 
%alpha: is the probability of a link to be strong (if network is of the  type 'bern_fix_alpha').
% d_s and d_w are the interaction thresholds for strong and weak ties
% respectively.
% labmda: is the network density (the probability of having a connection betwee two nodes in
% the bernoulli random network) 
% PASS: is the assortativity between the two groups (the probability that a
% given link of an individual is with an agent of the same type).




% This creates the adjacency matrix of a random network with density
% lambda, where two groups of agents are linked with assortativity PASS.
pc=lambda; % probability of having a connections
Adj=zeros(N,N);
remaining_stubs=zeros(N,1);
for i=1:N % create the number of connections for each individual
    remaining_stubs(i)=sum(rand(N,1)<pc(types(i)));
end
while sum(remaining_stubs)>1 && length(find(remaining_stubs>0))>1
    agents_still=remaining_stubs>0; % search individuals with still free stubs
    wherei=ceil(rand*sum(agents_still)); %choose position of agent in the vector of those with still free stubs
    find_free=find(agents_still);
    choosei=find_free(wherei);  %choose an agent;
    agents_still(choosei)=0; % can't be choosen twice
    
    Type1FreeStubs=((agents_still==1) & (types==1));
    Type2FreeStubs=((agents_still==1) & (types==2));
    
    if sum(Type1FreeStubs)>0 && sum(Type2FreeStubs)>0 % if there are still agents of the two types
        if rand<PASS % if PASS<rand then i link to one of MY type
            if types(choosei)==1 % if the agent is of type1, select an agent of type 1
                wherej=ceil(rand*sum(Type1FreeStubs)); %choose position of agent in the vector of those with still free stubs
                find_free1=find(Type1FreeStubs);
                choosej=find_free1(wherej); %choose another agent
            else % if the agent is of type2, select an agent of type 2
                wherej=ceil(rand*sum(Type2FreeStubs)); %choose position of agent in the vector of those with still free stubs
                find_free2=find(Type2FreeStubs);
                choosej=find_free2(wherej); %choose another agent
            end
        else % otherwise i link to an agent of the other type
            if types(choosei)==1 % if the agent is of type1, select an agent of type 2
                wherej=ceil(rand*sum(Type2FreeStubs)); %choose position of agent in the vector of those with still free stubs
                find_free2=find(Type2FreeStubs);
                choosej=find_free2(wherej); %choose another agent
            else % if the agent is of type2,  select an agent of type 1
                wherej=ceil(rand*sum(Type1FreeStubs)); %choose position of agent in the vector of those with still free stubs
                find_free1=find(Type1FreeStubs);
                choosej=find_free1(wherej); %choose another agent
            end
        end
    else
        wherej=ceil(rand*sum(agents_still)); %choose position of agent in the vector of those with still free stubs
        find_free1=find(agents_still);
        choosej=find_free1(wherej); %choose another agent
    end
    Adj(choosei,choosej)=1; 
    Adj(choosej,choosei)=1; % update the matrix

    remaining_stubs(choosei)=remaining_stubs(choosei)-1; % decrease one the remaining stubs of both
    remaining_stubs(choosej)=remaining_stubs(choosej)-1;
end

% This assigns weak and strong ties according to the rules described at the
% beginning of this function.
switch type_ntw
    case 'bern_fix_alpha' % bernoulli random network with randomly assigned alpha
        for i=1:length(Adj)
            for j=1:length(Adj)
                if i>j && Adj(i,j)==1 % check only the upper half of the Adj matrix
                    Adj(i,j)=d_w; Adj(j,i)=d_w; % as a baseline they are weak
                    if rand<alpha % with probability alpha the link is actually strong (for Adj(i,j))
                        Adj(i,j)=d_s;
                    end
                    if rand<alpha % with probability alpha the link is actually strong (for Adj(j,i))
                        Adj(j,i)=d_s;
                    end
                end
            end
        end
    case 'bern_pro_alpha'
    % NOTE: this assumes linearity of the relationship between alpha
    % and degree. Individuals with min(degree) have probability 1 to
    % have strong tie, those with max degree have prob=0 of having
    % strong ties.        
        deg=sum(Adj==1,1); %compute the degree of every node
        mindeg=min(deg);
        maxdeg=max(deg);
        diffdeg=maxdeg-mindeg;
        
        for i=1:length(Adj)
            alphai=-deg(i)/diffdeg + maxdeg/diffdeg; % compute the alpha_i for this agent
            for j=1:length(Adj)
                if Adj(i,j)==1
                    if rand<alphai % with probability alpha_i the link is actually strong (for Adj(i,j))
                        Adj(i,j)=d_s(types(i));
                    else
                        Adj(i,j)=d_w(types(i)); %othewise is weak
                        % NOTE: THERE IS NO NEED TO CALL ADJ(J,I) HERE AS IT IS
                        % TREATED WHEN COMES THE TIME OF I=J
                    end
                end
            end
        end
end

    

