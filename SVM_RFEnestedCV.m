function overallPerf = SVM_RFEnestedCV(metaData,infoClinical,leaveOneout,leaveILAE2out)

attributes = zeros(size(metaData,1),numel(infoClinical));
for i = 1:numel(infoClinical)
    attributes(:,i) = metaData.(infoClinical{i});
end

attributes = zscore(attributes);

%% Implement leave-one-out here
metaDataExcludeILAE2 = metaData(metaData.ILAE_1~=2,:);
labels = metaDataExcludeILAE2.ILAE_1;
labels(labels>2)=-1;

attributesExcludeILAE2 = attributes(metaData.ILAE_1~=2,:);

svmC = logspace(0,1,100);
infoInterest = [{'Naive','Informed'},infoClinical];
feat2Include = true(numel(infoInterest),1);

order = 1:numel(infoInterest);
scoreT = table(metaDataExcludeILAE2.IDP,'VariableNames',{'IDP'});

for nFeature = 1:numel(infoInterest)
    tic
    for nSub = 1:size(metaDataExcludeILAE2,1)
        
        testIDP = metaDataExcludeILAE2.IDP(nSub,:);
        indx = ismember(cell2mat(leaveOneout(:,1)),testIDP);
        data = leaveOneout{indx,2}.features;
        networkFeatures = data{:,[2,3]};
        networkFeatures = zscore(networkFeatures);
        clinicalFeatures = attributesExcludeILAE2;
        
        features = [networkFeatures, clinicalFeatures];
        
        
        features = features(:,feat2Include);
        
        testData = features(indx,:);
        
        trainData = features(~indx,:);
        trainLabel = labels(~indx,:);
        
        paramC = getBestC(trainData,trainLabel,svmC);
        mdl = fitcsvm(trainData,trainLabel,...
            'Prior','uniform','BoxConstraint',paramC);
        [~,scr] = predict(mdl,testData);
        score(nSub,:) = scr(:,1);
        betaCoef(:,nSub) = mdl.Beta;
        cVal(:,nSub) = paramC;
        
    end
    display(['Feature_ittr' num2str(nFeature) ' = ' num2str(toc)])
    
    [X,Y,thres,auc,OPTROCPT]=perfcurve(labels,score,-1,'Prior','uniform');
    [~,~,~,aucPR]=perfcurve(labels,score,-1,'Prior','uniform',...
        'xCrit', 'reca', 'yCrit', 'prec');
    pred = ones(size(score,1),1);
    pred(score>=thres(X==OPTROCPT(1) & Y==OPTROCPT(2)))=-1;
    
    acc = mean(double(pred == labels));
    sens = mean(double(pred(labels == 1) == ...
        labels(labels == 1)));
    spec = mean(double(pred(labels == -1) == ...
        labels(labels == -1)));
    
    metric.auc(nFeature,:) = auc;
    metric.aucPR(nFeature,:) = aucPR;
    metric.acc(nFeature,:) = acc;
    metric.sens(nFeature,:) = sens;
    metric.spec(nFeature,:) = spec;
    allSVMc(nFeature,:) = cVal;
    optimalSVMc(nFeature,:) = median(cVal);
    scoreT = [scoreT, table(score)];
    scoreT.Properties.VariableNames{nFeature+1} = ['ittr' num2str(nFeature)];
    impF = abs(mean(betaCoef,2));
    stdF = abs(std(betaCoef,[],2));
    rankF = table(order(feat2Include)', infoInterest(feat2Include)',impF,stdF,'VariableNames',{'Sno','Name','W','stdW'});
    rankF = sortrows(rankF,'W','descend');
    feat2Include = (feat2Include & transpose(~ismember(infoInterest,rankF.Name(end))));
    rfe.(['ittr' num2str(nFeature)]) = rankF;
    clear score betaCoef impF rankF auc aucPR acc sens spec
end

overallPerf.metric = struct2table(metric);
overallPerf.SVMrfe = rfe;
overallPerf.optimalSVMc = optimalSVMc;
overallPerf.allSVMc = allSVMc;

%% For every feature get the scores for ILAE2 from the best model
metaDataExcludeILAE2 = metaData(metaData.ILAE_1~=2,:);
labels = metaDataExcludeILAE2.ILAE_1;
labels(labels>2)=-1;

dataILAE2 = leaveILAE2out{1,2}.features;
indx = ismember(dataILAE2.IDP,leaveILAE2out{1,1});
networkFeatures = [dataILAE2.surgNaiveAbr,dataILAE2.surgInformedAbr];

% Do normalisation here is needed
networkFeatures = zscore(networkFeatures);

networkFeaturesTrain = networkFeatures(~indx,:);
networkFeaturesTest = networkFeatures(indx,:);

clinicalFeaturesTrain = attributesExcludeILAE2;
clinicalFeaturesTest =  attributes(metaData.ILAE_1==2,:);

featuresTrain = [networkFeaturesTrain,clinicalFeaturesTrain];
featuresTest = [networkFeaturesTest,clinicalFeaturesTest];

feat2Include = true(numel(infoInterest),1);

for nFeature = 1:numel(infoInterest)
    
    trainData = featuresTrain(:,feat2Include);
    testData = featuresTest(:,feat2Include);
    
    paramC = getBestC(trainData,labels,svmC);
    %     mdl = fitcsvm(trainData,labels,...
    %          'Prior','uniform','BoxConstraint',paramC);
    
    mdl = fitcsvm(trainData,labels,'PredictorNames',rfe.(['ittr' num2str(nFeature)]).Name,...
        'Prior','uniform','BoxConstraint',paramC);
    
    save(['TrainedSVM/trainedSVMx' num2str(nFeature) '.mat'],'mdl');
    
    [~,scr] = predict(mdl,testData);
    scoreILAE2(:,nFeature) = scr(:,1);
    
    if nFeature ~= numel(infoInterest)
        feat2Include = ismember(infoInterest,rfe.(['ittr' num2str(nFeature+1)]).Name);
    end
    
end

tblILAE2 = [leaveILAE2out{1,1},scoreILAE2];
tblILAE2 = array2table(tblILAE2);
tblILAE2.Properties.VariableNames = scoreT.Properties.VariableNames;
scoreT = [scoreT;tblILAE2];
scoreT = sortrows(scoreT,'IDP','ascend');
overallPerf.scoreT = scoreT;

for nFeature = 1:numel(infoInterest)
    severity = metaData.ILAE_1(metaData.ILAE_1>1);
    scrRFE = scoreT{metaData.ILAE_1>1,nFeature+1};
    
    [r,p]=corr(severity,scrRFE,'type', 'spearman','Tail','right');
    
    rSeverity(nFeature,:) = r;
    pSeverity(nFeature,:) = p;
    
end
overallPerf.metric.rSeverity = rSeverity;
overallPerf.metric.pSeverity = pSeverity;
overallPerf = confIntAUCr(metaData,overallPerf); % Adding Confidence Intervals
end
