function plotOutcomeRelapse(nodeAbnorCount,auc_ILAE1vs3to5,metaData)
%% Surgically naive networks
abrNodeCount = nodeAbnorCount.surgNaive;
perfMetric = auc_ILAE1vs3to5.surgInformed;

[id_nAbrDef,id_zRange] = find(perfMetric==max(max(perfMetric)));

%% Year 1 outcome surgically naive
dataILAE1 = squeeze(abrNodeCount(id_nAbrDef,id_zRange,metaData.ILAE_1==1));
dataILAE2 = squeeze(abrNodeCount(id_nAbrDef,id_zRange,metaData.ILAE_1==2));
dataILAE3 = squeeze(abrNodeCount(id_nAbrDef,id_zRange,metaData.ILAE_1>2));
data = padcat(dataILAE1,dataILAE2,dataILAE3);
 
figure;
labels = {'ILAE1','ILAE2','ILAE3+'};
Colors = [112 191 65; 112 191 65; 236 93 87]./255;
UnivarScatter(data,'Label',labels,'MarkerFaceColor',Colors,...
     'SEMColor',Colors,'StdColor',Colors/1.2);
pbaspect([12,10,1])

[naiveCI.d13,naiveCI.d13R,naiveCI.data1Median,naiveCI.data1MedianR,naiveCI.data3Median,...
    naiveCI.data3MedianR] = confidenceInterval_Bootstrap(data(:,1),data(:,3),10000);
[naiveCI.d12,naiveCI.d12R,~,~,naiveCI.data2Median,...
    naiveCI.data2MedianR] = confidenceInterval_Bootstrap(data(:,1),data(:,2),10000);
[naiveCI.d23,naiveCI.d23R] = confidenceInterval_Bootstrap(data(:,2),data(:,3),10000);

p13 = round(ranksum(data(:,1),data(:,3)),3);
p23 = round(ranksum(data(:,2),data(:,3)),3);

d13 = round(computeCohen_d(data(:,3),data(:,1)),2);
d23 = round(computeCohen_d(data(:,3),data(:,2)),2);


title({'Figure S2b Pre-surgery', ...
    ['ILAE1 vs ILAE3+: p = ' num2str(p13) ', d = ' num2str(d13) ],...
    ['ILAE2 vs ILAE3+: p = ' num2str(p23) ', d = ' num2str(d23)]});

set(gca,'FontSize',12);
ylabel('Number of abnormal nodes');
ylim([-5 45])
set(gca,'yTick',0:5:45);

%% Surgically informed networks
abrNodeCount = nodeAbnorCount.surgInformed;
perfMetric = auc_ILAE1vs3to5.surgInformed;

[id_nAbrDef,id_zRange] = find(perfMetric==max(max(perfMetric)));

%% Year 1 outcome surgically informed
dataILAE1 = squeeze(abrNodeCount(id_nAbrDef,id_zRange,metaData.ILAE_1==1));
dataILAE2 = squeeze(abrNodeCount(id_nAbrDef,id_zRange,metaData.ILAE_1==2));
dataILAE3 = squeeze(abrNodeCount(id_nAbrDef,id_zRange,metaData.ILAE_1>2));
data = padcat(dataILAE1,dataILAE2,dataILAE3);

figure;
labels = {'ILAE1','ILAE2','ILAE3+'};
Colors = [112 191 65; 112 191 65; 236 93 87]./255;
UnivarScatter(data,'Label',labels,'MarkerFaceColor',Colors,...
     'SEMColor',Colors,'StdColor',Colors/1.2);
pbaspect([12,10,1])

[informedCI.d13,informedCI.d13R,informedCI.data1Median,informedCI.data1MedianR,informedCI.data3Median,...
    informedCI.data3MedianR] = confidenceInterval_Bootstrap(data(:,1),data(:,3),10000);
[informedCI.d12,informedCI.d12R,~,~,informedCI.data2Median,...
    informedCI.data2MedianR] = confidenceInterval_Bootstrap(data(:,1),data(:,2),10000);
[informedCI.d23,informedCI.d23R] = confidenceInterval_Bootstrap(data(:,2),data(:,3),10000);

p13 = round(ranksum(data(:,1),data(:,3)),3);
p23 = round(ranksum(data(:,2),data(:,3)),3);

d13 = round(computeCohen_d(data(:,3),data(:,1)),2);
d23 = round(computeCohen_d(data(:,3),data(:,2)),2);
title({'Figure 1E Surgically-spared', ...
    ['ILAE1 vs ILAE3+: p = ' num2str(p13) ', d = ' num2str(d13) ],...
    ['ILAE2 vs ILAE3+: p = ' num2str(p23) ', d = ' num2str(d23)]});

set(gca,'FontSize',12);
ylabel('Number of abnormal nodes');
ylim([-5 45])
set(gca,'yTick',0:5:45);

%% Relapse anytime in 5 years based on available data surgically informed

SFNoRel = (metaData.replased5Yrs<=2 & metaData.ILAE_1<=2);
SFRel = (metaData.replased5Yrs>=3 & metaData.ILAE_1<=2);

dataNoRel = squeeze(abrNodeCount(id_nAbrDef,id_zRange,SFNoRel));
dataRel = squeeze(abrNodeCount(id_nAbrDef,id_zRange,SFRel));
data = padcat(dataNoRel,dataRel);

figure;
labels = {'No Relapse','Relapse'};
Colors = [0.39 0.47 0.64;0.58 0.39 0.39];
UnivarScatter(data,'Label',labels,'MarkerFaceColor',Colors,...
     'SEMColor',Colors/0.8,'StdColor',Colors);
pbaspect([12,10,1])

[relapseCI.d12,relapseCI.d12R,relapseCI.data1Median,...
    relapseCI.data1MedianR,relapseCI.data2Median,...
    relapseCI.data2MedianR]=confidenceInterval_Bootstrap(data(:,1),data(:,2),10000);

box off
set(gca,'FontSize',12);
p = ranksum(data(:,1),data(:,2),'method','exact','tail','left');
d = computeCohen_d(data(:,1),data(:,2));
title(['Figure 1G, p = ' num2str(round(p,3)) ', d = ' num2str(round(d,2))]);
ylabel('Number of abnormal nodes');

ILAE1NoRelapse = sum(metaData.replased5Yrs<=2 & metaData.ILAE_1==1);
ILAE1Relapse = sum(metaData.replased5Yrs>2 & metaData.ILAE_1==1);
ILAE2NoRelapse = sum(metaData.replased5Yrs<=2 & metaData.ILAE_1==2);
ILAE2Relapse = sum(metaData.replased5Yrs>2 & metaData.ILAE_1==2);

left_labels = {'ILAE1', 'ILAE2'};
right_labels = {'No Seizure Relapse', 'Seizure Relapse'};
data = [ ILAE1NoRelapse  ILAE1Relapse;
         ILAE2NoRelapse  ILAE2Relapse];

figure;
alluvialflow(data, left_labels, right_labels, '');
title('Figure 1F');
set(gca,'FontSize',12);

end
