function l1O = getBestThresholdPair(theshold,labels,IDP,IDPtoAdd,...
    surgNaive,surgNaivetoAdd,surgInformed,surgInformedtoAdd)

percentAbr = theshold.percentAbr(1:25);
zScore = theshold.zScore;
surgNaive = surgNaive(1:25,:,:);
surgInformed = surgInformed(1:25,:,:);
perfTable = table();

for nPercentAbr = 1:numel(percentAbr)
    for nZscore = 1:numel(zScore)
        
        features = nan(numel(labels),2);
        
        features(:,1) = squeeze(surgNaive(nPercentAbr,nZscore,:));
        features(:,2) = squeeze(surgInformed(nPercentAbr,nZscore,:));
        
        cvPart = cvpartition(numel(labels),'LeaveOut');
        
        CVMdl = fitclinear(features',labels,'ObservationsIn','columns',...
            'CVPartition',cvPart,'Prior','uniform','Learner','logistic');
        
        [CVlabels,CVscores] = kfoldPredict(CVMdl);
        
        [~,~,~,auc]=perfcurve(labels,CVscores(:,1),-1,'Prior','uniform');
        acc = mean(double(CVlabels == labels))*100;
        
        perfTable = [perfTable; table(percentAbr(nPercentAbr),zScore(nZscore),auc,acc)];
    end
end

perfTable.Properties.VariableNames{1} = 'percentAbr';
perfTable.Properties.VariableNames{2} = 'zScore';
perfTable.Properties.VariableNames{3} = 'AUC';
perfTable.Properties.VariableNames{4} = 'Accuracy';

perfTable = sortrows(perfTable,{'AUC','Accuracy'},{'descend','descend'});

surgNaiveAbr = squeeze(surgNaive(percentAbr == perfTable.percentAbr(1),zScore==perfTable.zScore(1),:));
surgInformedAbr = squeeze(surgInformed(percentAbr == perfTable.percentAbr(1),zScore==perfTable.zScore(1),:));

l1O.features = table(IDP,surgNaiveAbr,surgInformedAbr);
l1O.threshold = perfTable(1,:);

%% Sample the values at threshold for the left out subject and add data

surgNaivetoAddAbr = squeeze(surgNaivetoAdd(percentAbr == perfTable.percentAbr(1),zScore==perfTable.zScore(1),:));
surgInformedtoAddAbr = squeeze(surgInformedtoAdd(percentAbr == perfTable.percentAbr(1),zScore==perfTable.zScore(1),:));

l1O.features{end+1:end+numel(IDPtoAdd),:} = [IDPtoAdd, surgNaivetoAddAbr, surgInformedtoAddAbr];
l1O.features = sortrows(l1O.features,'IDP','ascend');

end