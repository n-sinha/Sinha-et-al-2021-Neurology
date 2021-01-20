function [statSF,statNSF] = plotAbrLobes(befSurgLobes,aftSurgLobes,metaData)

lobeName = {'Temporal';'SubCortical';'Parietal';'Occipital';'Frontal';'Cingulate'};

%% Compute statistics
for lobe = 1:size(befSurgLobes,1)
   
    [~,statSF.p(lobe,:),CI,stats] = ttest(befSurgLobes(lobe,metaData.ILAE_1==1)',aftSurgLobes(lobe,metaData.ILAE_1==1)');
    statSF.meanDiff(lobe,:) = round(mean(befSurgLobes(lobe,metaData.ILAE_1==1))- mean(aftSurgLobes(lobe,metaData.ILAE_1==1)),2);
    statSF.CIL(lobe,:) = round(CI(1),2);
    statSF.CIU(lobe,:) = round(CI(2),2);
    statSF.tstat(lobe,:) = round(stats.tstat,2);
    statSF.DF(lobe,:) = stats.df;
    
    
    [~,statNSF.p(lobe,:),CI,stats] = ttest(befSurgLobes(lobe,metaData.ILAE_1>2)',aftSurgLobes(lobe,metaData.ILAE_1>2)');
    statNSF.meanDiff(lobe,:) = round(mean(befSurgLobes(lobe,metaData.ILAE_1>2))- mean(aftSurgLobes(lobe,metaData.ILAE_1>2)),2);
    statNSF.CIL(lobe,:) = round(CI(1),2);
    statNSF.CIU(lobe,:) = round(CI(2),2);
    statNSF.tstat(lobe,:) = round(stats.tstat,2);
    statNSF.DF(lobe,:) = stats.df;
   
end

statSF = struct2table(statSF);
statNSF = struct2table(statNSF);

%% Compute mean
befSurgAbsSF = mean(befSurgLobes(:,metaData.ILAE_1==1),2);
befSurgAbsNSF = mean(befSurgLobes(:,metaData.ILAE_1>2),2);

aftSurgAbsSF = mean(aftSurgLobes(:,metaData.ILAE_1==1),2);
aftSurgAbsNSF = mean(aftSurgLobes(:,metaData.ILAE_1>2),2);

%% Compute sde
befSurgAbsSFsd = std(befSurgLobes(:,metaData.ILAE_1==1),[],2)./numel(metaData.ILAE_1==1);
befSurgAbsNSFsd = std(befSurgLobes(:,metaData.ILAE_1>2),[],2)./numel(metaData.ILAE_1>2);

aftSurgAbsSFsd = std(aftSurgLobes(:,metaData.ILAE_1==1),[],2)./numel(metaData.ILAE_1==1);
aftSurgAbsNSFsd = std(aftSurgLobes(:,metaData.ILAE_1>2),[],2)./numel(metaData.ILAE_1>2);

%% Concatenate sde and mean ILAE 1
meanValSF = [befSurgAbsSF,aftSurgAbsSF]; %befSurgAbsILAE2,befSurgAbsNSF,aftSurgAbsILAE2,aftSurgAbsNSF]; % mean values
sdeValSF = [befSurgAbsSFsd,aftSurgAbsSFsd];%befSurgAbsILAE2sd,befSurgAbsNSFsd,aftSurgAbsSFsd,aftSurgAbsILAE2sd,aftSurgAbsNSFsd]; % standard error

meanValSF_Ipsi = meanValSF(1:6,:);
meanValSF_Contra = meanValSF(7:12,:);

sdeValSF_Ipsi = sdeValSF(1:6,:);
sdeValSF_Contra = sdeValSF(7:12,:);

% Plot Ipsilateral for SF patients
figure
hold on
hb = bar(1:6,meanValSF_Ipsi);
hb(1).FaceColor = hex2rgb('DB984D');
hb(2).FaceColor = hex2rgb('75A5ED');
% For each set of bars, find the centers of the bars, and write error bars
pause(0.1); %pause allows the figure to be created

for ib = 1:numel(hb)
    %XData property is the tick labels/group centers; XOffset is the offset
    %of each distinct group
    xData = hb(ib).XData+hb(ib).XOffset;
    errorbar(xData,meanValSF_Ipsi(:,ib),sdeValSF_Ipsi(:,ib),'k.')
end

set(gca,'xTickLabel',lobeName);
set(gca,'xTick',1:6);

ylabel('Proportion abnormal nodes')
set(gca,'FontSize',12);
set(gca,'XTickLabelRotation',45);
legend({'Before Surgery'; 'After Surgery'})
ylim([0 0.3])
legend off
title('Figure 4B: ILAE 1 Ipsilateral')

% Plot Contralateral for SF patients
figure
hold on
hb = bar(1:6,meanValSF_Contra);
hb(1).FaceColor = hex2rgb('DB984D');
hb(2).FaceColor = hex2rgb('75A5ED');
% For each set of bars, find the centers of the bars, and write error bars
pause(0.1); %pause allows the figure to be created

for ib = 1:numel(hb)
    %XData property is the tick labels/group centers; XOffset is the offset
    %of each distinct group
    xData = hb(ib).XData+hb(ib).XOffset;
    errorbar(xData,meanValSF_Contra(:,ib),sdeValSF_Contra(:,ib),'k.')
end

set(gca,'xTickLabel',lobeName);
set(gca,'xTick',1:6);

ylabel('Proportion abnormal nodes')
set(gca,'FontSize',12);
set(gca,'XTickLabelRotation',45);
legend({'Before Surgery'; 'After Surgery'})
ylim([0 0.3])
legend off
title('Figure 4B: ILAE 1 Contralateral')

%% Concatenate sde and mean ILAE 3+
meanValNSF = [befSurgAbsNSF,aftSurgAbsNSF]; %befSurgAbsILAE2,befSurgAbsNSF,aftSurgAbsILAE2,aftSurgAbsNSF]; % mean values
sdeValNSF = [befSurgAbsNSFsd,aftSurgAbsNSFsd];%befSurgAbsILAE2sd,befSurgAbsNSFsd,aftSurgAbsSFsd,aftSurgAbsILAE2sd,aftSurgAbsNSFsd]; % standard error

meanValNSF_Ipsi = meanValNSF(1:6,:);
meanValNSF_Contra = meanValNSF(7:12,:);

sdeValNSF_Ipsi = sdeValNSF(1:6,:);
sdeValNSF_Contra = sdeValNSF(7:12,:);

% Plot Ipsilateral for NSF patients
figure
hold on
hb = bar(1:6,meanValNSF_Ipsi);
hb(1).FaceColor = hex2rgb('DB984D');
hb(2).FaceColor = hex2rgb('75A5ED');
% For each set of bars, find the centers of the bars, and write error bars
pause(0.1); %pause allows the figure to be created

for ib = 1:numel(hb)
    %XData property is the tick labels/group centers; XOffset is the offset
    %of each distinct group
    xData = hb(ib).XData+hb(ib).XOffset;
    errorbar(xData,meanValNSF_Ipsi(:,ib),sdeValNSF_Ipsi(:,ib),'k.')
end

set(gca,'xTickLabel',lobeName);
set(gca,'xTick',1:6);

ylabel('Proportion abnormal nodes')
set(gca,'FontSize',12);
set(gca,'XTickLabelRotation',45);
legend({'Before Surgery'; 'After Surgery'})
ylim([0 0.3])
legend off
title('Figure 4D: ILAE 3+ Ipsilateral')

% Plot Contralateral for NSF patients
figure
hold on
hb = bar(1:6,meanValNSF_Contra);
hb(1).FaceColor = hex2rgb('DB984D');
hb(2).FaceColor = hex2rgb('75A5ED');
% For each set of bars, find the centers of the bars, and write error bars
pause(0.1); %pause allows the figure to be created

for ib = 1:numel(hb)
    %XData property is the tick labels/group centers; XOffset is the offset
    %of each distinct group
    xData = hb(ib).XData+hb(ib).XOffset;
    errorbar(xData,meanValNSF_Contra(:,ib),sdeValNSF_Contra(:,ib),'k.')
end

set(gca,'xTickLabel',lobeName);
set(gca,'xTick',1:6);

ylabel('Proportion abnormal nodes')
set(gca,'FontSize',12);
set(gca,'XTickLabelRotation',45);
legend({'Before Surgery'; 'After Surgery'})
ylim([0 0.3])
legend off
title('Figure 4D: ILAE 3+ Contralateral')

end