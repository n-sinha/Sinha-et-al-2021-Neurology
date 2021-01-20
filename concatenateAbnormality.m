function [nodeAbnor,nodeAbnorCount,theshold]=concatenateAbnormality(metaData,results)

for sub = 1:size(metaData,1)
    
    load([results 'nodeAbnormality_' num2str(metaData.IDP(sub)) '.mat'],...
        'nodeAbnormality')
    
    nodeAbnor.surgNaive(:,:,sub) = nodeAbnormality.surgicallyNaive;
    nodeAbnor.surgInformed(:,:,sub) = nodeAbnormality.surgicallyInformed;
    
    nodeAbnorCount.surgNaive(:,:,sub) = nodeAbnormality.surgicallyNaiveCount;    
    nodeAbnorCount.surgInformed(:,:,sub) = nodeAbnormality.surgicallyInformedCount;
    nodeAbnorCount.deltaSurg(:,:,sub) = nodeAbnorCount.surgNaive(:,:,sub) - ...
        nodeAbnorCount.surgInformed(:,:,sub);
    
end

theshold.percentAbr = transpose(round(nodeAbnormality.abrThreshold*100,3));
theshold.zScore = round(nodeAbnormality.zThreshold,3);

end