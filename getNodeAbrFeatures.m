function  [leaveOneout,leaveILAE2out] = getNodeAbrFeatures(nodeAbnorCount,theshold,metaData)
%% Best disciminatory threshold by applying leave-one-out ILAE1 vs. 3+
IDP = metaData.IDP(metaData.ILAE_1~=2,:);
label = metaData.ILAE_1(metaData.ILAE_1~=2,:);
label(label>2) = -1;
surgNaive = nodeAbnorCount.surgNaive(:,:,metaData.ILAE_1~=2);
surgInformed = nodeAbnorCount.surgInformed(:,:,metaData.ILAE_1~=2);
leaveOneout = {};

parfor nSub = 1:numel(IDP)
    tic
    
    IDPtoUse = IDP;
    IDPtoUse(nSub) = [];
    IDPtoAdd = IDP(nSub);
    
    labeltoUse = label;
    labeltoUse(nSub) = [];
    
    surgNaivetoUse = surgNaive;
    surgNaivetoUse(:,:,nSub) = [];
    surgNaivetoAdd = surgNaive(:,:,nSub);
    
    surgInformedtoUse = surgInformed;
    surgInformedtoUse(:,:,nSub) = [];
    surgInformedtoAdd = surgInformed(:,:,nSub);
    
    
    l1o = getBestThresholdPair(theshold,labeltoUse,IDPtoUse,IDPtoAdd,...
        surgNaivetoUse,surgNaivetoAdd,surgInformedtoUse,surgInformedtoAdd);
    
    leaveOneout = [leaveOneout;{IDPtoAdd,l1o}];
    
    disp(nSub)
    toc
end

save('Results/leaveOneout.mat','leaveOneout');

%% Best disciminatory threshold by applying leave-ILAE2-out
clearvars -except leaveOneout nodeAbnorCount theshold metaData

IDPtoUse = metaData.IDP(metaData.ILAE_1~=2,:);
IDPtoAdd = metaData.IDP(metaData.ILAE_1==2,:);

labeltoUse = metaData.ILAE_1(metaData.ILAE_1~=2,:);
labeltoUse(labeltoUse>2) = -1;

surgNaivetoUse = nodeAbnorCount.surgNaive(:,:,metaData.ILAE_1~=2);
surgNaivetoAdd = nodeAbnorCount.surgNaive(:,:,metaData.ILAE_1==2);

surgInformedtoUse = nodeAbnorCount.surgInformed(:,:,metaData.ILAE_1~=2);
surgInformedtoAdd = nodeAbnorCount.surgInformed(:,:,metaData.ILAE_1==2);

leaveILAE2out{:,1} = IDPtoAdd;
leaveILAE2out{:,2} = getBestThresholdPair(theshold,labeltoUse,IDPtoUse,IDPtoAdd,...
    surgNaivetoUse,surgNaivetoAdd,surgInformedtoUse,surgInformedtoAdd);

save('Results/leaveILAE2out.mat','leaveILAE2out');

end