% Once the simulation has been run and the file with data save this script
% generates the figures of the paper concerning the Committed vs
% Non-committed agents.

close all
clear all
clc

load Exploration_Zealots.mat
numfig=1;


figure(numfig);
imagesc(varzel,ap_ment,mean(convinced1./(N*share_pop(1)),3))
set(gca,'YDir','normal')
ylabel('d_{int}^C','FontSize',14);
xlabel('\sigma_W^C','FontSize',14)
title({'Proportion of non-committed agents';'in bundles dominated by committed agents'},'FontSize',14)
colormap('gray')
colorbar
saveas(numfig,'convinced_uniform','jpg')
saveas(numfig,'convinced_uniform','fig')
numfig=numfig+1;


%figure(numfig);
%imagesc(varzel,ap_ment,mean(convinced2./(N*share_pop(2)),3))
%set(gca,'YDir','normal')
%ylabel('d_{int}^C','FontSize',18);
%xlabel('\sigma_W^C','FontSize',18)
%title({'Proportion of committed agents';'in bundles dominated by non-committed agents'},'FontSize',18)
%colormap('gray')
%colorbar
%saveas(numfig,'convinced2','jpg')
%saveas(numfig,'convinced2','fig')
%numfig=numfig+1;

figure(numfig);
imagesc(varzel,ap_ment,mean(less_than_zealot1./N,3))
set(gca,'YDir','normal')
ylabel('d_{int}^C','FontSize',14);
xlabel('\sigma_W^C','FontSize',14)
title({'Proportion of agents with final waste below Q1'; 'of the initial waste of ordinary agents (W_{end}<Q1(W_0^{NC}))'},'FontSize',14)
colormap('gray')
colorbar
saveas(numfig,'less_than_Q1_normal','jpg')
saveas(numfig,'less_than_Q1_normal','fig')
numfig=numfig+1;


figure(numfig);
imagesc(varzel,ap_ment,mean(less_than_zealot2./N,3))
set(gca,'YDir','normal')
ylabel('d_{int}^C','FontSize',14);
xlabel('\sigma_W^C','FontSize',14)
title({'Proportion of agents with final waste above the maximum'; 'initial waste of committed agents (W_{end}>max(W_0^{C})'},'FontSize',14)
colormap('gray')
colorbar
saveas(numfig,'more_than_max_zealots','jpg')
saveas(numfig,'more_than_max_zealots','fig')
numfig=numfig+1;


figure(numfig);
imagesc(varzel,ap_ment,mean(less_than_point5(:,1:30,:)./N,3))
set(gca,'YDir','normal')
ylabel('d_{int}^C','FontSize',14);
xlabel('\sigma_W^C','FontSize',14)
title({'Proportion of agents with final waste below'; 'the median of initial waste (W_{end}<Q2(W_0))'},'FontSize',14)
colormap('gray')
colorbar
saveas(numfig,'less_than_point5','jpg')
saveas(numfig,'less_than_point5','fig')