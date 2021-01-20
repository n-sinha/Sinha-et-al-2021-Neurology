function nodeAbnormality = countAbnormalNode(nodeAbnormality,abrThreshold)

for abrDef = 1:numel(abrThreshold)
    
    surgicallyNaive = nodeAbnormality.surgicallyNaive;
    surgicallyNaive(surgicallyNaive<=abrThreshold(abrDef))=0;
    surgicallyNaive(surgicallyNaive>0) = 1;
    nodeAbnormality.surgicallyNaiveCount(abrDef,:)=sum(surgicallyNaive);
    
    surgicallyInformed = nodeAbnormality.surgicallyInformed;
    surgicallyInformed(surgicallyInformed<=abrThreshold(abrDef))=0;
    surgicallyInformed(surgicallyInformed>0) = 1;
    nodeAbnormality.surgicallyInformedCount(abrDef,:)=sum(surgicallyInformed);
    
end

nodeAbnormality.abrThreshold = abrThreshold';

end
