function networkZ = compLinkZscore(network,control,minLinkinControl)

networkZ = zeros(size(network));

for k = 1:size(networkZ,3)
    for j = 1:size(networkZ,2)
        for i = 1:size(networkZ,1)
            if network (i,j,k) ~= 0
                linkContrl = squeeze(control(i,j,:));
                linkContrl(find(linkContrl==0))=[];
                if numel(linkContrl)>=minLinkinControl
                    [~,mu,sigma] = zscore(linkContrl);
                    networkZ(i,j,k) = (network(i,j,k)-mu)/(sigma);
                end
            end
        end
    end
end

networkZ = abs(networkZ);

%networkZ(isnan(networkZ)) = 0;
%networkZ(isinf(networkZ)) = 0;

end