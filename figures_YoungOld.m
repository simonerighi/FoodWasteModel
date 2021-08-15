% Once the simulation has been run and the file with data save this script
% generates the figures of the paper concerning the young vs
% adults agents.

close all
clear all
clc

load Exploration_YoungAdults.mat 


figure(3)
errorbar(disassort,mean(less_than_zealot1(1,:,:)./N,3),std(less_than_zealot1(1,:,:)./N,0,3),'r')
hold on
errorbar(disassort,mean(less_than_zealot1(2,:,:)./N,3),std(less_than_zealot1(2,:,:)./N,0,3),'b')
hold on
errorbar(disassort,mean(less_than_zealot1(3,:,:)./N,3),std(less_than_zealot1(3,:,:)./N,0,3),'k')
hold on
errorbar(disassort,mean(less_than_zealot1(4,:,:)./N,3),std(less_than_zealot1(4,:,:)./N,0,3),'c')
legend('d_{int}^Y=0.01','d_{int}^Y=0.06','d_{int}^Y=0.11','d_{int}^Y=0.16','Location','best')
title({'Proportion of agents with final waste below Q1'; 'of the initial waste of young agents (W_{end}<Q1(W_0^Y))'},'FontSize',14);
xlabel('P_{intra}','FontSize',14)
ylabel('Proportion of agents','FontSize',14)
%print -depsc YoungOld_BelowMinYoungs.jpg
saveas(3,'YoungOld_BelowQ1Youngs','jpg')


figure(4)
errorbar(disassort,mean(less_than_zealot2(1,:,:)./N,3),std(less_than_zealot2(1,:,:)./N,0,3),'r')
hold on
errorbar(disassort,mean(less_than_zealot2(2,:,:)./N,3),std(less_than_zealot2(2,:,:)./N,0,3),'b')
hold on
errorbar(disassort,mean(less_than_zealot2(3,:,:)./N,3),std(less_than_zealot2(3,:,:)./N,0,3),'k')
hold on
errorbar(disassort,mean(less_than_zealot2(4,:,:)./N,3),std(less_than_zealot2(4,:,:)./N,0,3),'c')
legend('d_{int}^Y=0.01','d_{int}^Y=0.06','d_{int}^Y=0.11','d_{int}^Y=0.16','Location','best')
ylim([0.8 1]);
title({'Proportion of agents with final waste above Q3'; 'of the initial waste of adult agents (W_{end}>Q3(W_0^A))'},'FontSize',14);
xlabel('P_{intra}','FontSize',14)
ylabel('Proportion of agents','FontSize',14)
%print -depsc YoungOld_AboveMaxAdults.jpg
saveas(4,'YoungOld_AboveQ3Adults','jpg')


figure(5)
%numero di agenti tipo 1, quelli che hanno un valore di waste inferiore a 0.5 
errorbar(disassort,mean(less_than_point5(1,:,:)./N,3),std(less_than_point5(1,:,:)./N,0,3),'r')
hold on
errorbar(disassort,mean(less_than_point5(2,:,:)./N,3),std(less_than_point5(2,:,:)./N,0,3),'b')
hold on
errorbar(disassort,mean(less_than_point5(3,:,:)./N,3),std(less_than_point5(3,:,:)./N,0,3),'k')
hold on
errorbar(disassort,mean(less_than_point5(4,:,:)./N,3),std(less_than_point5(4,:,:)./N,0,3),'c')
legend('d_{int}^Y=0.01','d_{int}^Y=0.06','d_{int}^Y=0.11','d_{int}^Y=0.16','Location','best')
ylim([0.025 0.175]);
title({'Proportion of agent with final waste below','the median of initial waste (W_{end}<Q2(W_0))'},'FontSize',14);
xlabel('P_{intra}','FontSize',14)
ylabel('Proportion of agents','FontSize',14)
%print -depsc YoungOld_below05.jpg
saveas(5,'YoungOld_below05','jpg')


% figure(6)
% errorbar(disassort,mean(lessthanmedian_high(1,:,:)./N,3),std(lessthanmedian_high(1,:,:)./N,0,3),'r')
% hold on
% errorbar(disassort,mean(lessthanmedian_high(2,:,:)./N,3),std(lessthanmedian_high(2,:,:)./N,0,3),'b')
% hold on
% errorbar(disassort,mean(lessthanmedian_high(3,:,:)./N,3),std(lessthanmedian_high(3,:,:)./N,0,3),'k')
% hold on
% errorbar(disassort,mean(lessthanmedian_high(4,:,:)./N,3),std(lessthanmedian_high(4,:,:)./N,0,3),'c')
% legend('d_{int}^Y=0.01','d_{int}^Y=0.06','d_{int}^Y=0.11','d_{int}^Y=0.16','Location','best')
% title({'Proportion of individuals with final waste'; 'below median(W_0^Y)'},'FontSize',18);
% xlabel('P_{intra}','FontSize',18)
% ylabel('Proportion of agents','FontSize',18)
% %print -depsc YoungOld_BelowMinYoungs.jpg
% saveas(6,'YoungOld_BelowMedianYoungs','jpg')


% figure(7)
% errorbar(disassort,mean(morethanmedia_low(1,:,:)./N,3),std(morethanmedia_low(1,:,:)./N,0,3),'r')
% hold on
% errorbar(disassort,mean(morethanmedia_low(2,:,:)./N,3),std(morethanmedia_low(2,:,:)./N,0,3),'b')
% hold on
% errorbar(disassort,mean(morethanmedia_low(3,:,:)./N,3),std(morethanmedia_low(3,:,:)./N,0,3),'k')
% hold on
% errorbar(disassort,mean(morethanmedia_low(4,:,:)./N,3),std(morethanmedia_low(4,:,:)./N,0,3),'c')
% legend('d_{int}^Y=0.01','d_{int}^Y=0.06','d_{int}^Y=0.11','d_{int}^Y=0.16','Location','best')
% title({'Proportion of individuals with final waste'; 'above median(W_0^A)'},'FontSize',18);
% xlabel('P_{intra}','FontSize',18)
% ylabel('Proportion of agents','FontSize',18)
% %print -depsc YoungOld_AboveMaxAdults.jpg
% saveas(7,'YoungOld_AboveMedianAdults','jpg')

% figure(1)
% %numero di agenti tipo 1, che finiscono in gruppi dominati da agenti del
% %tipo 2;
% errorbar(disassort,mean(convinced1(1,:,:)./(N*share_pop(1)),3),std(convinced1(1,:,:)./(N*share_pop(1)),0,3),'r')
% hold on
% errorbar(disassort,mean(convinced1(2,:,:)./(N*share_pop(1)),3),std(convinced1(2,:,:)./(N*share_pop(1)),0,3),'b')
% hold on
% errorbar(disassort,mean(convinced1(3,:,:)./(N*share_pop(1)),3),std(convinced1(3,:,:)./(N*share_pop(1)),0,3),'k')
% hold on
% errorbar(disassort,mean(convinced1(4,:,:)./(N*share_pop(1)),3),std(convinced1(4,:,:)./(N*share_pop(1)),0,3),'c')
% legend('d_{int}=0.01','d_{int}=0.06','d_{int}=0.11','d_{int}=0.16','Location','best')
% ylim([0 1]);
% title({'Proportion of young agents in bundles dominated by adults'},'FontSize',18);
% xlabel('P_{intra}','FontSize',18)
% ylabel('Proportion of young','FontSize',18)
% saveas(1,'YoungOld_YoungInAdultGroups','jpg')
% %print -depsc YoungOld_YoungInAdultGroups.jpg


figure(2)
%numero di agenti tipo 2, che finiscono in gruppi dominati da agenti del
%tipo 1;
errorbar(disassort,mean(convinced2(1,:,:)./(N*share_pop(2)),3),std(convinced2(1,:,:)./(N*share_pop(2)),0,3),'r')
hold on
errorbar(disassort,mean(convinced2(2,:,:),3)./(N*share_pop(2)),std(convinced2(2,:,:)./(N*share_pop(2)),0,3),'b')
hold on
errorbar(disassort,mean(convinced2(3,:,:),3)./(N*share_pop(2)),std(convinced2(3,:,:)./(N*share_pop(2)),0,3),'k')
hold on
errorbar(disassort,mean(convinced2(4,:,:),3)./(N*share_pop(2)),std(convinced2(4,:,:)./(N*share_pop(2)),0,3),'c')
legend('d_{int}=0.01','d_{int}=0.06','d_{int}=0.11','d_{int}=0.16','Location','best')
ylim([0 1]);
title({'Proportion of adult agents'; 'in bundles dominated by young agents'},'FontSize',14);
xlabel('P_{intra}','FontSize',14)
ylabel('Proportion of adults','FontSize',14)
saveas(2,'YoungOld_AdultInYoungGroups','jpg')
%print -depsc YoungOld_AdultInYoungGroups.jpg
