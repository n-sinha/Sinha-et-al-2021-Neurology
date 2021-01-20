function paramC = getBestC(trainData,trainLabel,svmC)

cv = cvpartition(trainLabel,'LeaveOut');

parfor c = 1:numel(svmC)
    
    cVal = svmC(c);
    mdl = fitcsvm(trainData,trainLabel,...
        'Prior','uniform','BoxConstraint',cVal,'CVPartition',cv);
    [~,scr] = kfoldPredict(mdl);
    score(:,c)= scr(:,1);
    
end

for c = 1:numel(svmC)
    [~,~,~,auc(c,:)]=perfcurve(trainLabel,score(:,c),-1,'Prior','uniform');
    [~,~,~,aucPR(c,:)]=perfcurve(trainLabel,score(:,c),-1,'Prior','uniform',...
        'xCrit', 'reca', 'yCrit', 'prec');
end

T = table(svmC',auc,'VariableNames',{'C','auc'});
T = sortrows(T,{'auc'},{'descend'});

paramC = T.C(1);

end