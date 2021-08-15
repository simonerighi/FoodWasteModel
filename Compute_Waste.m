function [A_vct,O_vct]=Compute_Waste(O,A,CD,ninteractions,ngoodinteractions) 
% If the difference between an agent Opinion and Action exceed the threshold 
%for cognitive dissonance, the dissonance reduction process is triggered
%(action moves toward opinion or vice-versa).
% the  more agents were willing to move in the past the more
% probable is the fact that their opinion will move to the action. And
% viceversa.

A_vct=A;
O_vct=O;
 
a=1;
above_dcd_treshold=(abs(O-A)>CD);

Agents_cd=find(above_dcd_treshold==1); % list of those that are above the dcd of this type and are of type a
if ~isempty(Agents_cd)
    for i=1:length(Agents_cd)
        if ninteractions(Agents_cd(i))>0 % if there were previous interactions
            threshold=ngoodinteractions(Agents_cd(i))/ninteractions(Agents_cd(i)); % this is probability of Oi-->Ai
        else
            threshold=0.5;  % if there were no previous interactions the theshold 0.5 implying equal opportunity
        end
        if rand>threshold
            A_vct(Agents_cd(i))=(1-threshold)*O(Agents_cd(i))+threshold*A(Agents_cd(i));
        else
            O_vct(Agents_cd(i))=(1-threshold)*O(Agents_cd(i))+threshold*A(Agents_cd(i));
        end
    end
end


