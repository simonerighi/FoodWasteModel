function [A,B]=Individual_selection(Adj,N)
% select one individual A and then another one B connected to him.

A=ceil(rand*N); % selected A

while isempty(find(Adj(A,:)>0))
    A=ceil(rand*N); % selected A
end
poss_B=find(Adj(A,:)>0); % list of possible Bs

B=poss_B(ceil(rand*length(poss_B))); % selected B
