function [dVal,ci_dscore,data1Median,ci_data1Median,data2Median,...
    ci_data2Median]= confidenceInterval_Bootstrap(data1,data2,nboot)

dscore = @(x1,x2) computeCohen_d(x1,x2);
dVal = dscore(data1,data2);
rng(1);
ci_dscore = bootci(nboot,dscore,data1,data2); 

xMedian = @(x) nanmedian(x);
data1Median = xMedian(data1);
data2Median = xMedian(data2);
rng(1);
ci_data1Median = bootci(nboot,xMedian,data1);
rng(1);
ci_data2Median = bootci(nboot,xMedian,data2); 

% diffMed = @(x1,x2)(nanmedian(x1) - nanmedian(x2));
% diffMedian = diffMed(data(:,1),data(:,2));
% ci_diffMedian = bootci(nboot,diffMed,data(:,1),data(:,2));

end