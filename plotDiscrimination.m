function plotDiscrimination(d_ILAE1vs3to5,auc_ILAE1vs3to5,theshold)

zRange = theshold.zScore;
nAbrDef = theshold.percentAbr(1:25);

%% Effect size of pre vs post

figure; 
imagesc(nAbrDef,zRange,transpose(d_ILAE1vs3to5.surgNaive(1:25,:)));
set(gca,'YDir','normal')
colormap('jet');
caxis([0 1.3]);
colorbar off;
yticks(2.1:0.3:4.5);
xticks(1:3:25)
set(gca,'FontSize',20);
ylabel('z-score')
xlabel('Node abnormality (%)')
title('Figure S1(a) Pre-surgery')

figure;
imagesc(nAbrDef,zRange,transpose(d_ILAE1vs3to5.surgInformed(1:25,:)));
set(gca,'YDir','normal')
colormap('jet');
caxis([0 1.3]);
colorbar off;
yticks(2.1:0.3:4.5);
xticks(1:3:25)
set(gca,'FontSize',20);
ylabel('z-score')
xlabel('Node abnormality (%)')
title('Figure S1(a) Surgically-spared')

%% AUC of pre vs post

figure;
imagesc(nAbrDef,zRange,transpose(auc_ILAE1vs3to5.surgNaive(1:25,:)));
set(gca,'YDir','normal')
colormap('jet');
colorbar;
caxis([0.4 0.9]);
yticks(2.1:0.3:4.5);
xticks(1:3:25)
set(gca,'FontSize',20);
ylabel('z-score')
xlabel('Node abnormality (%)')
title('Figure S1(b) Pre-surgery')

figure;
imagesc(nAbrDef,zRange,transpose(auc_ILAE1vs3to5.surgInformed(1:25,:)));
set(gca,'YDir','normal')
colormap('jet');
colorbar;
caxis([0.4 0.9]);
yticks(2.1:0.3:4.5);
xticks(1:3:25)
set(gca,'FontSize',20);
ylabel('z-score')
xlabel('Node abnormality (%)')
title('Figure S1(b) Surgically-spared')

%% Sample 100 highest post AUC from post effect size network
aucPost = auc_ILAE1vs3to5.surgInformed(1:25,:);
dPre = d_ILAE1vs3to5.surgNaive(1:25,:);
dPost = d_ILAE1vs3to5.surgInformed(1:25,:);

postT = table(aucPost(:),dPre(:),dPost(:));
postT.Properties.VariableNames = {'aucPost','dPre','dPost'};
postT = sortrows(postT,'aucPost','descend');

figure; 
h1 = histfit(postT.dPre(1:100));
hold on;
h2 = histfit(postT.dPost(1:100));

h1(1).FaceColor = hex2rgb('DB984D');
%h1(1).FaceAlpha = 0.8;
h1(2).Color = [0.97,0.68,0.00];

h2(1).FaceColor = hex2rgb('75A5ED');
h2(1).FaceAlpha = 0.8;
h2(2).Color = [0.00,0.45,0.74];

set(gca, 'FontSize', 20)
%xlim([0.3 1])
%xticks(0.3:0.1:1);
box off;
title('Figure S1(d)')

%% Sample 100 highest pre AUC from pre effect size network
aucPre = auc_ILAE1vs3to5.surgNaive(1:25,:);
dPre = d_ILAE1vs3to5.surgNaive(1:25,:);
dPost = d_ILAE1vs3to5.surgInformed(1:25,:);

preT = table(aucPre(:),dPre(:),dPost(:));
preT.Properties.VariableNames = {'aucPre','dPre','dPost'};
preT = sortrows(preT,'aucPre','descend');

% figure; 
% h1 = histfit(preT.dPre(1:100));
% hold on;
% h2 = histfit(preT.dPost(1:100));
% 
% h1(1).FaceColor = hex2rgb('DB984D');
% %h1(1).FaceAlpha = 0.8;
% h1(2).Color = [0.97,0.68,0.00];
% 
% h2(1).FaceColor = hex2rgb('75A5ED');
% h2(1).FaceAlpha = 0.8;
% h2(2).Color = [0.00,0.45,0.74];
% 
% set(gca, 'FontSize', 20)
% %xlim([0.3 1])
% %xticks(0.3:0.1:1);
% box off;

%% Plot top 100 AUC sorted from pre and post surgery
figure;
plot(preT.aucPre(1:100),'LineWidth',4, 'Color', hex2rgb('DB984D'));
hold on;
plot(postT.aucPost(1:100),'LineWidth',4, 'Color', hex2rgb('75A5ED'));
set(gca, 'FontSize', 20)
box off;
set(gca, 'FontSize', 20)
xticks(0:10:100);
%yticks(0.68:0.02:0.82);
title('Figure S1(c)')
end