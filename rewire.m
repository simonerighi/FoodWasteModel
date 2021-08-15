function [Adj]=rewire(Adj,i,j,val,prob_unknown_connection,d_w,d_s,types)
% This function rewires a connection that has been sewered due to the tension created by an interaction. 
% For each edge eliminated, one new edge is created (to avoid ties inflation).   
% links are created with friends of friends (triadic closure) except with
% prob_unknown_connection where a link is created at random.
% If a weak link between two nodes already exists then it becomes strong.

Adj(i,j)=0; % set to zero the old links
Adj(j,i)=0;

if val==1; rew=i; no_rew=j; else rew=j; no_rew=i; end % decide who is going to create the next link (1 dead link=1 new link)


friends_of_rew=find(Adj(rew,:)>0); 
friends_of_rew_weak=find(Adj(rew,:)==d_w(types(i)));
if ~isempty(friends_of_rew)
    Connvct=[];
    for x=1:length(friends_of_rew)
       % define the second order social neigbourhood of
       % the frustrated agent
       Conn2=find(Adj(friends_of_rew(x),:));
       Connvct=[Connvct Conn2];
    end
    Connvct=[Connvct friends_of_rew_weak];

    Connvct(Connvct==rew)=[];  % eliminate link with rew
    Connvct=unique(Connvct); % each element just once
    Connvct(Connvct==no_rew)=[];
    

    if ~isempty(Connvct) % if second order social neighbour exists 
        % extract a partner in the 2nd neigbourhood
        randextr=ceil(rand*length(Connvct));
        randextr=Connvct(randextr);
        % a possibility of jump
        if rand<prob_unknown_connection
            randextr = random_relink(Adj, rew,no_rew,d_w(types(i)));
        end
    else % if social neigbour does not exists relink with a previously unknown random agent
         randextr=random_relink (Adj, rew,no_rew,d_w(types(i)));
    end 
    % Create the connection
    if Adj(rew,randextr)==0 % if the link did not exist i create it weak and reciprocal. 
        Adj(rew,randextr)=d_w(types(i));
        Adj(randextr,rew)=d_w(types(i));
    else % if there was a (weak) link: then the  link becomes strong. 
        Adj(rew,randextr)=d_s(types(ceil(rand*2)));
    end
else % if the present guy has no more first order friends
    % One agent is selected randomly for the connection
    randextr = random_relink(Adj, rew,no_rew,d_w(types(i)));
    if Adj(rew,randextr)==0 % if the link did not exist i create it weak and reciprocal. 
        Adj(rew,randextr)=d_w(types(i));
        Adj(randextr,rew)=d_w(types(i));
    else % if there was a (weak) link: then the  link becomes strong. 
        Adj(rew,randextr)=d_s(types(ceil(rand*2)));
    end
        

end