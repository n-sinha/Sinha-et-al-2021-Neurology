function [nTracts,gFA] = cleanReorder(atlas,nTracts,gFA)

network = weight_conversion(nTracts.surgeryNetwork,'autofix');
temp = network(atlas.ROI.SNo,:);
temp = temp(:,atlas.ROI.SNo);
nTracts.surgeryNetwork = temp;

network = weight_conversion(nTracts.surgicallyNaive,'autofix');
temp = network(atlas.ROI.SNo,:);
temp = temp(:,atlas.ROI.SNo);
nTracts.surgicallyNaive = temp;

network = weight_conversion(nTracts.surgicallyInformed,'autofix');
temp = network(atlas.ROI.SNo,:);
temp = temp(:,atlas.ROI.SNo);
nTracts.surgicallyInformed = temp;

network = weight_conversion(gFA.surgicallyNaive,'autofix');
temp = network(atlas.ROI.SNo,:);
temp = temp(:,atlas.ROI.SNo);
gFA.surgicallyNaive = temp;


end