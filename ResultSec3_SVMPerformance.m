% This script and its associated functions reproduce the results 
% shown section: Personalized Prediction of 12-Month Seizure Freedom 
% Additionally Suggests ILAE Class and Relapse at Later Years

% We implement the methods discussed in section: 
% Predictive Model Design for Generalizability Assessment.

% Reference: 
% Sinha et al. 2021, Neurology 2021;96:e758-e771. 
% doi: https://doi.org/10.1212/WNL.0000000000011315

% All codes are authored by Nishant Sinha, Newcastle University, UK
% Contact: nishant.sinha89@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear
%close all
addpath(genpath('lib'))
set(0,'DefaultFigureWindowStyle','docked')

%% Load clinical information

infoClinical = {'AgeOnset','AgeSurgery','EpilepsyDuration','nAEDspreOp',...
    'isStatusEpilpticus','isFemale','isSecGenSeizure',...
    'isSideLeft','isMRInormal','isHippScl',...
    'depressionPreOp', 'psychosisPreOp','otherPsychiatryPreop'};

infoInterest = [{'Naive','Informed'},infoClinical];

%% Load processed metaData
load('NetworkData/metaData.mat');
results = 'Results/abnormalityGIF/';

[~,nodeAbnorCount,theshold] = concatenateAbnormality(metaData,results);

try
    load('Results/leaveOneout.mat')
    load('Results/leaveILAE2out.mat')
    
catch
    [leaveOneout,leaveILAE2out]=getNodeAbrFeatures(nodeAbnorCount,theshold,metaData);
end

%% Run SVM RFE and plot results
try
    load('Results/crossValNest.mat');
catch
    overallPerf = SVM_RFEnestedCV(metaData,infoClinical,leaveOneout,leaveILAE2out);
    save('Results/crossValNest.mat','overallPerf');
end
plotAUCr(overallPerf,infoInterest);

%% Plot performace at RFE ittr = 11 and ittr = 15

bestScore = overallPerf.scoreT.ittr11;
allStats = plotOutcomeRelapseClassif(bestScore,metaData);

scoreSparedNet = overallPerf.scoreT.ittr15;
plotYrRelapseAssociation(scoreSparedNet,metaData);