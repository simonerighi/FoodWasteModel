function [Oi,Oj,suci,sucj]=opinion_dynamics(Oi,Oj,strengthij,strengthji,mu)
% If the the other agent is closer than the interaction threshold (given
% the strength of the connection) then he converges. Otherwise he remains
% of the same opinion. Given different threshold this dynamics can be
% asymmetric.

Old_Oi=Oi; % i keep track of the old Opinions to refer to them
Old_Oj=Oj;

suci=0;
sucj=0;

if abs(Old_Oi-Old_Oj)<strengthij % if the difference of opinions is below the ij treshold
    % evolve Oi
    Oi=Old_Oi+mu*(Old_Oj-Old_Oi);
    suci=1;
end
if abs(Old_Oi-Old_Oj)<strengthji % if the difference of opinions is below the ji treshold
    % evolve Oj
    Oj=Old_Oj+mu*(Old_Oi-Old_Oj);
    sucj=1;
end
