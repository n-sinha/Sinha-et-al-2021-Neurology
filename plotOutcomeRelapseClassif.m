function allStats= plotOutcomeRelapseClassif(perf,metaData)
%% Plot ROC
labels = metaData.ILAE_1(metaData.ILAE_1~=2);
labels(labels>2) = -1;
score = perf(metaData.ILAE_1~=2);
[fpr,tpr,thres,auc,OPTROCPT]=perfcurve(labels,score,-1,'Prior','uniform');
figure;
plot(fpr,tpr,'k','LineWidth', 2,'Color',[0.4 0.4 0.4]);
hold on
plot([0,1],[0 1],'r', 'LineWidth', 1)
plot(OPTROCPT(1),OPTROCPT(2),'ko')
set(gca,'FontSize',12);
xlabel('False positive rate')
ylabel('True positive rate')
title(['Figure 5B: AUC = ' num2str(round(auc,2))]);
hold off

prediction = ones(size(score,1),1);
prediction(score>=thres(fpr==OPTROCPT(1) & tpr==OPTROCPT(2))) = -1;
figure;
title('Model caliberated at optimal point')
confusionchart(labels,prediction,'FontSize',12);
title('Figure 5B: confusion matrix');

%% Classification scores
perfMin = min(perf);
perfMax = max(perf);
perfScore = (perf - perfMin)./(perfMax-perfMin);
%% Plot mean difference based on the combined clinical scores
figure,
data = padcat(perfScore(metaData.ILAE_1==1),...
    perfScore(metaData.ILAE_1==2),...
    perfScore(metaData.ILAE_1>=3));

labels = {'ILAE1','ILAE2','ILAE3+'};
Colors = [112 191 65; 112 191 65; 236 93 87]./255;
UnivarScatter(data,'Label',labels,'MarkerFaceColor',Colors,...
    'SEMColor',Colors,'StdColor',Colors/1.2);
ylabel('Predicted likelihood of seizure relapse');
pbaspect([12,10,1])
p23 = ranksum(perfScore(metaData.ILAE_1>=3),perfScore(metaData.ILAE_1==2),'method','exact','tail','right');
d23 = computeCohen_d(perfScore(metaData.ILAE_1>=3),perfScore(metaData.ILAE_1==2));

data = padcat(perfScore(metaData.ILAE_1>=3),perfScore(metaData.ILAE_1==2));
[CI.dVal,CI.dscore,CI.data1Median,CI.data1MedianR,CI.data2Median,...
    CI.data2MedianR]=confidenceInterval_Bootstrap(data(:,1),data(:,2),10000);

title({'Figure 5C: Classification scores', ...
    ['ILAE2 vs ILAE3+: p = ' num2str(p23) ', d = ' num2str(round(d23,2))]});
set(gca,'FontSize',12);

allStats.severity.p23 = p23;
allStats.severity.d23 = d23;
%% Plot correation between combined clinical scores and ILAE group
figure,
[r,p]=corr(metaData.ILAE_1(metaData.ILAE_1>1),...
    perfScore(metaData.ILAE_1>1),...
    'type', 'spearman','Tail','right');

scatter(metaData.ILAE_1(metaData.ILAE_1>1),...
    perfScore(metaData.ILAE_1>1),...
    'x','MarkerEdgeColor',hex2rgb('999933'));

ylabel('Predicted likelihood of seizure relapse');
title(['Figure 5C: p = ' num2str(round(p,4)) '; r = ' num2str(round(r,2))]);
set(gca,'FontSize',12);
xlim([1.5 5.5])
set(gca,'XTick',2:1:5);
set(gca,'XTickLabel',{'ILAE2', 'ILAE3', 'ILAE4', 'ILAE5'});
set(gca, 'YColor',hex2rgb('999933'));
set(gca, 'XColor',hex2rgb('999933'));
h(1).MarkerSize = 20;

allStats.severity.r = r;
allStats.severity.p = p;

%% Plot correation between combined clinical scores and ILAE group
% [r,p]=corr(metaData.ILAE_1,perfScore,'type', 'spearman','Tail','right');
% 
% scatter(metaData.ILAE_1,perfScore,'x','MarkerEdgeColor',hex2rgb('999933'));%hex2rgb('DC984D'));
% 
% %ylabel('Classification scores');
% title(['p = ' num2str(p) '; r = ' num2str(r)]);
% set(gca,'FontSize',8);
% xlim([0.5 5.5])
% set(gca,'XTick',1:1:5);
% set(gca,'XTickLabel',{'ILAE1', 'ILAE2', 'ILAE3', 'ILAE4', 'ILAE5'});
% set(gca, 'YColor',hex2rgb('999933'));%hex2rgb('DC984D'));
% set(gca, 'XColor',hex2rgb('999933'));%hex2rgb('DC984D'));
% h(1).MarkerSize = 8;
% 
% fillPage(gcf, 'margins', [0 0 0 0], 'papersize', [12 6]);
% print(gcf, '-dpdf', '-r300', ['Figures/ana_severityCor_' fileOutputName '2.pdf'])
% 
% allStats.severity.r2 = r;
% allStats.severity.p2 = p;

%% Relapse at year 2

SFNoRelYr2 = (metaData.RelILAE_2<=2 & metaData.ILAE_1<=2);
SFRelYr2 = (metaData.RelILAE_2>=3 & metaData.ILAE_1<=2);

dataNoRelYr2 = perfScore(SFNoRelYr2);
dataRelYr2 = perfScore(SFRelYr2);
data = padcat(dataNoRelYr2,dataRelYr2);

figure;
subplot(2,2,1);
labels = {'No Relapse','Relapse'};
Colors = [0.39 0.47 0.64;0.58 0.39 0.39];
UnivarScatter(data,'Label',labels,'MarkerFaceColor',Colors,...
    'SEMColor',Colors/0.8,'StdColor',Colors);
pbaspect([16,10,1])

[relapseYr2CI.d12,relapseYr2CI.d12R,relapseYr2CI.data1Median,...
    relapseYr2CI.data1MedianR,relapseYr2CI.data2Median,...
    relapseYr2CI.data2MedianR]=confidenceInterval_Bootstrap(data(:,1),data(:,2),10000);

p = ranksum(data(:,1),data(:,2),'tail','left','method','exact');
d = computeCohen_d(data(:,1),data(:,2));

p = round(p,2);
d = round(d,2);

title(['Figure S7: Year 2, d = ' num2str(d) ', p = ' num2str(p)]);
ylabel('Class Score');
box  off

allStats.relapse.pyr2 = p;
allStats.relapse.dyr2 = d;
%% Relapse at year 3

SFNoRelYr3 = (metaData.RelILAE_3<=2 & metaData.ILAE_1<=2);
SFRelYr3 = (metaData.RelILAE_3>=3 & metaData.ILAE_1<=2);

dataNoRelYr3 = perfScore(SFNoRelYr3);
dataRelYr3 = perfScore(SFRelYr3);
data = padcat(dataNoRelYr3,dataRelYr3);

subplot(2,2,2)
labels = {'No Relapse','Relapse'};
Colors = [0.39 0.47 0.64;0.58 0.39 0.39];
UnivarScatter(data,'Label',labels,'MarkerFaceColor',Colors,...
    'SEMColor',Colors/0.8,'StdColor',Colors);
pbaspect([16,10,1])

[relapseYr3CI.d12,relapseYr3CI.d12R,relapseYr3CI.data1Median,...
    relapseYr3CI.data1MedianR,relapseYr3CI.data2Median,...
    relapseYr3CI.data2MedianR]=confidenceInterval_Bootstrap(data(:,1),data(:,2),10000);

p = ranksum(data(:,1),data(:,2),'tail','left','method','exact');
d = computeCohen_d(data(:,1),data(:,2));

p = round(p,2);
d = round(d,2);

title(['Figure S7: Year 3, d = ' num2str(d) ', p = ' num2str(p)]);
ylabel('Class Score');
box  off
allStats.relapse.pyr3 = p;
allStats.relapse.dyr3 = d;

%% Relapse at year 4

SFNoRelYr4 = (metaData.RelILAE_4<=2 & metaData.ILAE_1<=2);
SFRelYr4 = (metaData.RelILAE_4>=3 & metaData.ILAE_1<=2);

dataNoRelYr4 = perfScore(SFNoRelYr4);
dataRelYr4 = perfScore(SFRelYr4);
data = padcat(dataNoRelYr4,dataRelYr4);


subplot(2,2,3)
labels = {'No Relapse','Relapse'};
Colors = [0.39 0.47 0.64;0.58 0.39 0.39];
UnivarScatter(data,'Label',labels,'MarkerFaceColor',Colors,...
    'SEMColor',Colors/0.8,'StdColor',Colors);
pbaspect([16,10,1])

[relapseYr4CI.d12,relapseYr4CI.d12R,relapseYr4CI.data1Median,...
    relapseYr4CI.data1MedianR,relapseYr4CI.data2Median,...
    relapseYr4CI.data2MedianR]=confidenceInterval_Bootstrap(data(:,1),data(:,2),10000);

p = ranksum(data(:,1),data(:,2),'tail','left','method','exact');
d = computeCohen_d(data(:,1),data(:,2));

p = round(p,2);
d = round(d,2);

title(['Figure S7: Year 4, d = ' num2str(d) ', p = ' num2str(p)]);
ylabel('Class Score');
box  off

allStats.relapse.pyr4 = p;
allStats.relapse.dyr4 = d;
%% Relapse at year 5

SFNoRelYr5 = (metaData.RelILAE_5<=2 & metaData.ILAE_1<=2);
SFRelYr5 = (metaData.RelILAE_5>=3 & metaData.ILAE_1<=2);

dataNoRelYr5 = perfScore(SFNoRelYr5);
dataRelYr5 = perfScore(SFRelYr5);
data = padcat(dataNoRelYr5,dataRelYr5);


subplot(2,2,4)
labels = {'No Relapse','Relapse'};
Colors = [0.39 0.47 0.64;0.58 0.39 0.39];
UnivarScatter(data,'Label',labels,'MarkerFaceColor',Colors,...
    'SEMColor',Colors/0.8,'StdColor',Colors);
pbaspect([16,10,1])

[relapseYr5CI.d12,relapseYr5CI.d12R,relapseYr5CI.data1Median,...
    relapseYr5CI.data1MedianR,relapseYr5CI.data2Median,...
    relapseYr5CI.data2MedianR]=confidenceInterval_Bootstrap(data(:,1),data(:,2),10000);

p = ranksum(data(:,1),data(:,2),'tail','left','method','exact');
d = computeCohen_d(data(:,1),data(:,2));

p = round(p,2);
d = round(d,2);

title(['Figure S7: Year 5, d = ' num2str(d) ', p = ' num2str(p)]);
ylabel('Class Score');
box  off

allStats.relapse.pyr5 = p;
allStats.relapse.dyr5 = d;

%%

data = padcat(dataNoRelYr2,dataRelYr2,...
    dataNoRelYr3,dataRelYr3,...
    dataNoRelYr4,dataRelYr4,...
    dataNoRelYr5,dataRelYr5);

Colors = [0.39 0.47 0.64;0.58 0.39 0.39];
Colors = repmat(Colors,4,1);
labels = {'NR','R'};
labels = repmat(labels,1,4);

figure;
UnivarScatter(data,'Label',labels,'MarkerFaceColor',Colors,...
'SEMColor',Colors/0.8,'StdColor',Colors,'PointSize',15,'MarkerEdgeColor',[0.1 0.1 0.1]);
pbaspect([12,6,1])

hold on
neverSF = [nan(9,9),perfScore(metaData.ILAE_1>2)];
Colors = [0.44 0.75 0.25; 0.93 0.36 0.34];
Colors = repmat(Colors,5,1);
UnivarScatter(neverSF,'MarkerFaceColor',Colors,...
 'SEMColor',Colors,'StdColor',Colors/1.2,'PointSize',15,'MarkerEdgeColor',[0.1 0.1 0.1]);


axis tight
xticklabels({'nSRYr2', 'SRYr2','nSRYr3', 'SRYr3','nSRYr4', 'SRYr4','nSRYr5', 'SRYr5', '', 'Never seizure-free'});

ylabel('Predicted likelihood of seizure relapse');
title('Figure S7');
set(gca,'FontSize',12);

yticks(0:0.2:1);
ylim([-0.02 1]);
xlim([0.5 10.5]);
box on
grid on

end