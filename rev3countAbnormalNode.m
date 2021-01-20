function [nodeAbnormality,surgInfLobe,surgNaiveLobe] = ...
    rev3countAbnormalNode(nodeAbnormality,abrThreshold,atlas,auc_ILAE1vs3to5)

perfMetric = auc_ILAE1vs3to5.surgInformed;
[id_nAbrDef,id_zRange] = find(perfMetric==max(max(perfMetric)));


%% Surgically Informed
for sub = 1:size(nodeAbnormality.surgInformed,3)
    for abrDef = 1:numel(abrThreshold)
        
        network = nodeAbnormality.surgInformed(:,:,sub);
        network(network<=abrThreshold(abrDef))=0;
        network(network>0) = 1;
        nodeAbnormality.surgInformednetworkZCount(abrDef,:,sub)=sum(network);
        
        nodeAbnormality.lobeAbrLoadCount.TemporalI(abrDef,:,sub) = ...
            sum(network((atlas.lobes.temporal_I),:));
        nodeAbnormality.lobeAbrLoadCount.FrontalI(abrDef,:,sub) = ...
            sum(network((atlas.lobes.frontal_I),:));        
        nodeAbnormality.lobeAbrLoadCount.OccipitalI(abrDef,:,sub) = ...
            sum(network((atlas.lobes.occipital_I),:)); 
        nodeAbnormality.lobeAbrLoadCount.ParietalI(abrDef,:,sub) = ...
            sum(network((atlas.lobes.parietal_I),:)); 
        nodeAbnormality.lobeAbrLoadCount.SubcorticalI(abrDef,:,sub) = ...
           sum(network((atlas.lobes.subcortical_I),:)); 
        nodeAbnormality.lobeAbrLoadCount.CingulateI(abrDef,:,sub) = ...
            sum(network((atlas.lobes.cingulate_I),:));
        
        nodeAbnormality.lobeAbrLoadCount.TemporalC(abrDef,:,sub) = ...
            sum(network((atlas.lobes.temporal_C),:));
        nodeAbnormality.lobeAbrLoadCount.FrontalC(abrDef,:,sub) = ...
            sum(network((atlas.lobes.frontal_C),:));        
        nodeAbnormality.lobeAbrLoadCount.OccipitalC(abrDef,:,sub) = ...
            sum(network((atlas.lobes.occipital_C),:)); 
        nodeAbnormality.lobeAbrLoadCount.ParietalC(abrDef,:,sub) = ...
            sum(network((atlas.lobes.parietal_C),:)); 
        nodeAbnormality.lobeAbrLoadCount.SubcorticalC(abrDef,:,sub) = ...
           sum(network((atlas.lobes.subcortical_C),:)); 
        nodeAbnormality.lobeAbrLoadCount.CingulateC(abrDef,:,sub) = ...
            sum(network((atlas.lobes.cingulate_C),:)); 
                
    end
end

surgInfLobe(1,:) = [squeeze(nodeAbnormality.lobeAbrLoadCount.TemporalI(id_nAbrDef,id_zRange,:))/numel(atlas.lobes.temporal_I)];
surgInfLobe(2,:) = [squeeze(nodeAbnormality.lobeAbrLoadCount.SubcorticalI(id_nAbrDef,id_zRange,:))/numel(atlas.lobes.subcortical_I)];
surgInfLobe(3,:) = [squeeze(nodeAbnormality.lobeAbrLoadCount.ParietalI(id_nAbrDef,id_zRange,:))/numel(atlas.lobes.parietal_I)];
surgInfLobe(4,:) = [squeeze(nodeAbnormality.lobeAbrLoadCount.OccipitalI(id_nAbrDef,id_zRange,:))/numel(atlas.lobes.occipital_I)];
surgInfLobe(5,:) = [squeeze(nodeAbnormality.lobeAbrLoadCount.FrontalI(id_nAbrDef,id_zRange,:))/numel(atlas.lobes.frontal_I)];
surgInfLobe(6,:) = [squeeze(nodeAbnormality.lobeAbrLoadCount.CingulateI(id_nAbrDef,id_zRange,:))/numel(atlas.lobes.cingulate_I)];
surgInfLobe(7,:) = [squeeze(nodeAbnormality.lobeAbrLoadCount.TemporalC(id_nAbrDef,id_zRange,:))/numel(atlas.lobes.temporal_C)];
surgInfLobe(8,:) = [squeeze(nodeAbnormality.lobeAbrLoadCount.SubcorticalC(id_nAbrDef,id_zRange,:))/numel(atlas.lobes.subcortical_C)];
surgInfLobe(9,:) = [squeeze(nodeAbnormality.lobeAbrLoadCount.ParietalC(id_nAbrDef,id_zRange,:))/numel(atlas.lobes.parietal_C)];
surgInfLobe(10,:) = [squeeze(nodeAbnormality.lobeAbrLoadCount.OccipitalC(id_nAbrDef,id_zRange,:))/numel(atlas.lobes.occipital_C)];
surgInfLobe(11,:) = [squeeze(nodeAbnormality.lobeAbrLoadCount.FrontalC(id_nAbrDef,id_zRange,:))/numel(atlas.lobes.frontal_C)];
surgInfLobe(12,:) = [squeeze(nodeAbnormality.lobeAbrLoadCount.CingulateC(id_nAbrDef,id_zRange,:))/numel(atlas.lobes.cingulate_C)];

%% Surgically Naive

for sub = 1:size(nodeAbnormality.surgNaive,3)
    for abrDef = 1:numel(abrThreshold)
        
        network = nodeAbnormality.surgNaive(:,:,sub);
        network(network<=abrThreshold(abrDef))=0;
        network(network>0) = 1;
        nodeAbnormality.surgNaivenetworkZCount(abrDef,:,sub)=sum(network);
        
        nodeAbnormality.lobeAbrLoadCount.TemporalI(abrDef,:,sub) = ...
            sum(network((atlas.lobes.temporal_I),:));
        nodeAbnormality.lobeAbrLoadCount.FrontalI(abrDef,:,sub) = ...
            sum(network((atlas.lobes.frontal_I),:));        
        nodeAbnormality.lobeAbrLoadCount.OccipitalI(abrDef,:,sub) = ...
            sum(network((atlas.lobes.occipital_I),:)); 
        nodeAbnormality.lobeAbrLoadCount.ParietalI(abrDef,:,sub) = ...
            sum(network((atlas.lobes.parietal_I),:)); 
        nodeAbnormality.lobeAbrLoadCount.SubcorticalI(abrDef,:,sub) = ...
           sum(network((atlas.lobes.subcortical_I),:)); 
        nodeAbnormality.lobeAbrLoadCount.CingulateI(abrDef,:,sub) = ...
            sum(network((atlas.lobes.cingulate_I),:));
        
        nodeAbnormality.lobeAbrLoadCount.TemporalC(abrDef,:,sub) = ...
            sum(network((atlas.lobes.temporal_C),:));
        nodeAbnormality.lobeAbrLoadCount.FrontalC(abrDef,:,sub) = ...
            sum(network((atlas.lobes.frontal_C),:));        
        nodeAbnormality.lobeAbrLoadCount.OccipitalC(abrDef,:,sub) = ...
            sum(network((atlas.lobes.occipital_C),:)); 
        nodeAbnormality.lobeAbrLoadCount.ParietalC(abrDef,:,sub) = ...
            sum(network((atlas.lobes.parietal_C),:)); 
        nodeAbnormality.lobeAbrLoadCount.SubcorticalC(abrDef,:,sub) = ...
           sum(network((atlas.lobes.subcortical_C),:)); 
        nodeAbnormality.lobeAbrLoadCount.CingulateC(abrDef,:,sub) = ...
            sum(network((atlas.lobes.cingulate_C),:)); 
                
    end
end

surgNaiveLobe(1,:) = [squeeze(nodeAbnormality.lobeAbrLoadCount.TemporalI(id_nAbrDef,id_zRange,:))/numel(atlas.lobes.temporal_I)];
surgNaiveLobe(2,:) = [squeeze(nodeAbnormality.lobeAbrLoadCount.SubcorticalI(id_nAbrDef,id_zRange,:))/numel(atlas.lobes.subcortical_I)];
surgNaiveLobe(3,:) = [squeeze(nodeAbnormality.lobeAbrLoadCount.ParietalI(id_nAbrDef,id_zRange,:))/numel(atlas.lobes.parietal_I)];
surgNaiveLobe(4,:) = [squeeze(nodeAbnormality.lobeAbrLoadCount.OccipitalI(id_nAbrDef,id_zRange,:))/numel(atlas.lobes.occipital_I)];
surgNaiveLobe(5,:) = [squeeze(nodeAbnormality.lobeAbrLoadCount.FrontalI(id_nAbrDef,id_zRange,:))/numel(atlas.lobes.frontal_I)];
surgNaiveLobe(6,:) = [squeeze(nodeAbnormality.lobeAbrLoadCount.CingulateI(id_nAbrDef,id_zRange,:))/numel(atlas.lobes.cingulate_I)];
surgNaiveLobe(7,:) = [squeeze(nodeAbnormality.lobeAbrLoadCount.TemporalC(id_nAbrDef,id_zRange,:))/numel(atlas.lobes.temporal_C)];
surgNaiveLobe(8,:) = [squeeze(nodeAbnormality.lobeAbrLoadCount.SubcorticalC(id_nAbrDef,id_zRange,:))/numel(atlas.lobes.subcortical_C)];
surgNaiveLobe(9,:) = [squeeze(nodeAbnormality.lobeAbrLoadCount.ParietalC(id_nAbrDef,id_zRange,:))/numel(atlas.lobes.parietal_C)];
surgNaiveLobe(10,:) = [squeeze(nodeAbnormality.lobeAbrLoadCount.OccipitalC(id_nAbrDef,id_zRange,:))/numel(atlas.lobes.occipital_C)];
surgNaiveLobe(11,:) = [squeeze(nodeAbnormality.lobeAbrLoadCount.FrontalC(id_nAbrDef,id_zRange,:))/numel(atlas.lobes.frontal_C)];
surgNaiveLobe(12,:) = [squeeze(nodeAbnormality.lobeAbrLoadCount.CingulateC(id_nAbrDef,id_zRange,:))/numel(atlas.lobes.cingulate_C)];

end
