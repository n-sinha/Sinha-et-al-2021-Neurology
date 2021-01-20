function gFAControl = concatenateControls(networkData,atlas)

listing = dir([networkData 'gFA/Controls/*.mat']);

for i = 1:size(listing,1)
    
    load([networkData 'gFA/Controls/' listing(i).name]);    
    gFAControl(:,:,i) = weight_conversion(control,'autofix');
    
    network = gFAControl(:,:,i);
    net = network(atlas.ROI.SNo,:);
    net = net(:,atlas.ROI.SNo);

    gFAControl(:,:,i) = net;
    
end

end