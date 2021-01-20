function [d_ILAE1vs3to5,auc_ILAE1vs3to5]=computeDiscrimination(nodeAbnorCount,metaData)

surgNaive = nodeAbnorCount.surgNaive;
surgInformed = nodeAbnorCount.surgInformed;
deltaSurg = nodeAbnorCount.deltaSurg;

for i = 1:size(surgNaive,1)
    for j = 1:size(surgNaive,2)
        %% TLE SF vs NSF
        naive = squeeze(surgNaive(i,j,:));
        informed = squeeze(surgInformed(i,j,:));
        delta = squeeze(deltaSurg(i,j,:));
        
        d_ILAE1vs3to5.surgNaive(i,j) = computeCohen_d(naive(metaData.ILAE_1>=3),...
            naive(metaData.ILAE_1==1));
        
        d_ILAE1vs3to5.surgInformed(i,j) = computeCohen_d(informed(metaData.ILAE_1>=3),...
            informed(metaData.ILAE_1==1));
        
        d_ILAE1vs3to5.deltaSurg(i,j) = computeCohen_d(delta(metaData.ILAE_1>=3),...
            delta(metaData.ILAE_1==1));
        
        actual = [zeros(sum(metaData.ILAE_1>=3),1);ones(sum(metaData.ILAE_1==1),1)];
        
        scoresNaive = [naive(metaData.ILAE_1>=3);naive(metaData.ILAE_1==1)];        
        [~,~,~,auc_ILAE1vs3to5.surgNaive(i,j)]=perfcurve(actual,scoresNaive,0,'Prior','uniform');
        
        scoresInformed = [informed(metaData.ILAE_1>=3);informed(metaData.ILAE_1==1)];        
        [~,~,~,auc_ILAE1vs3to5.surgInformed(i,j)]=perfcurve(actual,scoresInformed,0,'Prior','uniform');
       
        scoresDelta = [delta(metaData.ILAE_1>=3);delta(metaData.ILAE_1==1)];        
        [~,~,~,auc_ILAE1vs3to5.deltaSurg(i,j)]=perfcurve(actual,scoresDelta,0,'Prior','uniform'); 

    end
end

d_ILAE1vs3to5.surgNaive(isnan(d_ILAE1vs3to5.surgNaive)) = 0;
d_ILAE1vs3to5.surgInformed(isnan(d_ILAE1vs3to5.surgInformed)) = 0;
d_ILAE1vs3to5.deltaSurg(isnan(d_ILAE1vs3to5.deltaSurg)) = 0;

end
