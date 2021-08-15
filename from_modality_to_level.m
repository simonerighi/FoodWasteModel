function Level=from_modality_to_level(modality,maxval)
% Transforms a Modality in a reply into a (random) quantitative level
% between the minimum and the maximum value of the modality.
% Between these two values the distribution is assumed random.

minval=[0 maxval(1:end-1)];
Level=minval(modality)+rand*(maxval(modality)-minval(modality));