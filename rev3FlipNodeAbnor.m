function nodeAbnorFlipped = rev3FlipNodeAbnor(nodeAbnor,metaData)

surgNaive = nodeAbnor.surgNaive;
surgInformed = nodeAbnor.surgInformed;

for nSub = 1:size(metaData,1)
    
    % surgNaive: Flip right to left 
     if metaData.isSideLeft(nSub)==0
        net1 = surgNaive(:,:,nSub);
        flip1 = net1([58:114,1:57],:);   
    else
        flip1 = surgNaive(:,:,nSub);
     end
    nodeAbnorFlipped.surgNaive(:,:,nSub) = flip1;
    
    % surgInformed: Flip right to left 
     if metaData.isSideLeft(nSub)==0
        net2 = surgInformed(:,:,nSub);
        flip2 = net2([58:114,1:57],:);   
    else
        flip2 = surgInformed(:,:,nSub);
     end
    nodeAbnorFlipped.surgInformed(:,:,nSub) = flip2;
        
end


end