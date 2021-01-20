function overallPerf = confIntAUCr(metaData,overallPerf)

%% AUC CI
label = metaData.ILAE_1(metaData.ILAE_1~=2)>1;

for i = 1:15
    score = overallPerf.scoreT.(['ittr' num2str(i)]);   
    %[A(i,:),Aci(i,:)] = auc([label, score(metaData.ILAE_1~=2)],0.05,'boot',10000);
    [A(i,:),Aci(i,:)] = auc([label, score(metaData.ILAE_1~=2)]);
    
end

overallPerf.metric.aucL = Aci(:,1);
overallPerf.metric.aucU = Aci(:,2);

%% Spearman CI
X = metaData.ILAE_1(metaData.ILAE_1~=1);

for i = 1:15
    score = overallPerf.scoreT.(['ittr' num2str(i)]);
    [r(i,:),~,~,~,rCI(i,:)] = Spearman(X, score(metaData.ILAE_1~=1),0);
end

overallPerf.metric.rSeverityL = rCI(:,1);
overallPerf.metric.rSeverityU = rCI(:,2);

end