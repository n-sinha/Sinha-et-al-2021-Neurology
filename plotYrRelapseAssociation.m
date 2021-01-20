function plotYrRelapseAssociation(perf,metaData)
%% Classification scores
perfMin = min(perf);
perfMax = max(perf);
perfScore = (perf - perfMin)./(perfMax-perfMin);
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

title(['Figure 6: Year 2, d = ' num2str(d) ', p = ' num2str(p)]);
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

title(['Figure 6: Year 3, d = ' num2str(d) ', p = ' num2str(p)]);
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

title(['Figure 6: Year 4, d = ' num2str(d) ', p = ' num2str(p)]);
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

title(['Figure 6: Year 5, d = ' num2str(d) ', p = ' num2str(p)]);
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
title('Figure 6');
set(gca,'FontSize',12);

yticks(0:0.2:1);
ylim([-0.02 1]);
xlim([0.5 10.5]);
box on
grid on

end