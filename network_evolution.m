function [Adj]=network_evolution(Oi,Oj,Ai,Aj,i,j,Adj,d_s,d_w,dact,prob_unknown_connection,types)
% This function allows for the evolution of the network as a consequence of
% the interaction that just happened.
% if the abs difference between my Action (hidden) and opinion of the other
% (the new one) is above a given treshold (dact) then the network tie is
% demoted (if strong) or rewired. Rewiring happens with 

netevo=zeros(2,1);
if abs(Ai-Oj)>dact % if the abs difference between my Action (hidden) and opinion of the other (the new one) is above a given treshold
    % demote link
    if Adj(i,j)==d_s(types(i)) % if this side of the tie was strong
        Adj(i,j)=d_w(types(i));
    else % otherwise is weak tie
        netevo(1)=1;
    end
end
if abs(Aj-Oi)>dact % if the difference between my Action (hidden) and opinion of the other (the new one) is above a given treshold
    % demote link
    if Adj(j,i)==d_s(types(j)) % if this side of the tie was strong
        Adj(j,i)=d_w(types(j));
    else % otherwise is weak tie
        netevo(2)=1;
    end
end

% if some link has been eliminated, then a new one is created (or
% reinforced).
if sum(netevo)>1
    if netevo(1)==1 && netevo(2)==1
        Adj=rewire(Adj,i,j,ceil(rand*2),prob_unknown_connection,d_w,d_s,types); % choose randomly the one that rewires
        return;
    end
    if netevo(1)==1 && netevo(2)==0 % i rewires
        Adj=rewire(Adj,i,j,1,prob_unknown_connection,d_w,d_s,types);
        return;
    end
    if netevo(1)==0 && netevo(1)==1 % j rewires
        Adj=rewire(Adj,i,j,2,prob_unknown_connection,d_w,d_s,types);
        return;
    end
end
    
end
