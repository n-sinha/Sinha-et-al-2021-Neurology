function nodeAbnormality = computeNodeAbr(gFA,zThreshold)

nodeDegree = transpose(degrees_und(gFA.surgicallyNaiveZ));

if sum(nodeDegree==0)~=0
    error('Disconnected node found.')
end

for z = 1:numel(zThreshold)
        
        % Surgically Naive
        surgicallyNaive = gFA.surgicallyNaiveZ;
        surgicallyNaive(surgicallyNaive<zThreshold(z)) = 0;
        surgicallyNaive(surgicallyNaive>0)=1;
        nodeAbnormality.surgicallyNaive(:,z) = sum(surgicallyNaive,2)./nodeDegree;
        
        % Surgically Informed
        surgicallyInformed = gFA.surgicallyInformedZ;
        surgicallyInformed(surgicallyInformed<zThreshold(z)) = 0;
        surgicallyInformed(surgicallyInformed>0)=1;
        nodeAbnormality.surgicallyInformed(:,z) = sum(surgicallyInformed,2)./nodeDegree;

end

nodeAbnormality.zThreshold = zThreshold;

end