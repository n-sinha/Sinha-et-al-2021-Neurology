function plotAUCr(overallPerf,infoInterest)
%% Plot AUC and severity correlation

figure;
hold on
plot(overallPerf.metric.auc,'-o','color','k',...
    'MarkerEdgeColor','none','MarkerFaceColor',[0.4 0.4 0.4])
set(gca,'ycolor','[0.4 0.4 0.4]')
ylim([0.4 1])
yticks(0.4:0.05:1)
yticklabels({'','','0.5','','0.6','','0.7','','0.8','','0.9','','1'})
h = ciplot(overallPerf.metric.aucL,overallPerf.metric.aucU,1:15,[0.4 0.4 0.4]);
h.FaceAlpha = 0.1;
h.EdgeAlpha = 0.1;
grid on
xlim([1 16])
xticks(1:1:15)
set(gca,'FontSize',12);
title('Figure 5A: AUC yr1 ILAE1 vs ILAE3+');
hold off


figure;
hold on
plot(overallPerf.metric.rSeverity,'-o','color',hex2rgb('999933'),...
    'MarkerEdgeColor','none','MarkerFaceColor',hex2rgb('999933'))
set(gca,'ycolor',hex2rgb('999933'))
ylim([-0.2 1])
yticks(-0.2:0.1:1)
yticklabels({'','','0.0','','0.2','','0.4','','0.6','','0.8','','1'})
h = ciplot(overallPerf.metric.rSeverityL,overallPerf.metric.rSeverityU,1:15,hex2rgb('999933'));
h.FaceAlpha = 0.2;
h.EdgeAlpha = 0.2;
grid on
xlim([1 16])
xticks(1:1:15)
set(gca,'FontSize',12);
title('Figure 5A: Correlation yr1 ILAE class');
hold off

%% Plot feature ranking
for nFeature = 1:numel(infoInterest)
    
    freqFeatures(:,nFeature)=ismember(infoInterest,...
        overallPerf.SVMrfe.(['ittr' num2str(nFeature)]).Name)';
    
end
freqFeatures = sum(freqFeatures,2)/numel(infoInterest);

for nFeature = 1:numel(infoInterest)
    tblW = overallPerf.SVMrfe.(['ittr' num2str(nFeature)]);
    tblW = sortrows(tblW,'Sno','ascend');
    W = tblW.W;
    %W = overallPerf.SVMrfe.(['ittr' num2str(nFeature)]).W;
    Wmin = min(W);
    Wmax = max(W);
    if nFeature ~= 15
        rankW = (W - Wmin)./(Wmax-Wmin);
    else
        rankW = W./Wmax;
    end
    rankSort = [rankW,freqFeatures(ismember(infoInterest,tblW.Name))]; 
    rankSort = sortrows(rankSort,-2);
    rankSort = [rankSort; nan(numel(infoInterest)-(numel(infoInterest)+1-nFeature),2)];
    concatRankFeature(:,nFeature) =  rankSort(:,1);
end
figure;
h1 = imagesc(concatRankFeature);
set(h1,'AlphaData',~isnan(concatRankFeature))
set(gca,'YDir','reverse')
colormap(brewermap(20,'YlOrRd'));

h2 = colorbar;
h2.Ticks = '';
yticks('')
xticks('')
yticklabels('');
xticklabels('');
axis off
set(gca,'FontSize',12);
title('Figure 5A: Normalized feature importance');
hold off

end