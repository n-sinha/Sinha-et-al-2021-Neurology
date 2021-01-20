% This script and its associated functions reproduce the results shown in
% Section: Abnormality Load Corresponds With Year 1 Surgical Outcome 
%          and Later-Year Seizure Relapse; 
% and
% Section: Surgery-Related Effect on Reducing Abnormality Load

% We implement the methods discussed in 
% Section: Node Abnormality Computation, and 
% Section: Quantifying the Change in Abnormality Load After ATLR

% Reference: 
% Sinha et al. 2021, Neurology 2021;96:e758-e771. 
% doi: https://doi.org/10.1212/WNL.0000000000011315

% All codes are authored by Nishant Sinha, Newcastle University, UK
% Contact: nishant.sinha89@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear
close all
addpath(genpath('lib'))
set(0,'DefaultFigureWindowStyle','docked')
mkdir('Results/abnormalityGIF')
mkdir('Results/abnormalityDKT')

%% Setup data folder, load metaData, and add information on relapse

load('NetworkData/metaData.mat');

networkData = 'NetworkData/brainNetworks/GIFAtlas/';
load([networkData 'roiTIG.mat']);
atlas.ROI = roi_TIG;
atlas.ROI=sortrows(atlas.ROI,{'isSideLeft','Lobe'},{'descend','descend'});
load([networkData, 'gifLobesSorted.mat']);
atlas.lobes = lobes;

% Results from DKT atlas can be repoduced by directing to data in DKTAtlas folder 
% networkData = 'NetworkData/brainNetworks/DKTAtlas/';
% load([networkData 'roiDKT.mat']);
% atlas.ROI = roiDKT;
% atlas.ROI=sortrows(atlas.ROI,{'isSideLeft','Lobe'},{'descend','descend'});
% load([networkData, 'dktLobesSorted.mat']);
% atlas.lobes = lobes;
% metaDataControls(26,:) = []; % has a disconnected node

%% Concatenate and reorder GFA of controls

gFAControl = concatenateControls(networkData,atlas);
minLinkinControl = 10;

%% Run analysis

for sub = 1:size(metaData,1)
    %% Compute surgery network    
    nTracts.surgicallyNaive = load([networkData 'nTracts/' ...
        'Surgically Naive/surgicallyNaive_' num2str(metaData.IDP(sub))]);       
    nTracts.surgicallyInformed = load([networkData 'nTracts/' ...
        'Surgically Informed/surgicallyInformed_' num2str(metaData.IDP(sub))]);
    
    nTracts = computeSurgeryNetwork(nTracts);
    
    %% Load GFA surgically naive network and networks for controls
    gFA = load([networkData 'gFA/' ...
        'Surgically Naive/surgicallyNaive_' num2str(metaData.IDP(sub))]);
    
    %% Clean and reorder network ROIs
    [nTracts,gFA] = cleanReorder(atlas,nTracts,gFA);
    
    %% Compute z-score networks
    gFA.surgicallyNaiveZ = compLinkZscore(gFA.surgicallyNaive,...
        gFAControl,minLinkinControl);
    
    gFA.surgicallyInformedZ = gFA.surgicallyNaiveZ.*(1-nTracts.surgeryNetwork);
    
    %% Compute node abnormality
    zThreshold = round(2.1:0.1:4.5,3);
    nodeAbnormality = computeNodeAbr(gFA,zThreshold);
       
    abrThreshold = round(0.01:0.01:0.5,3);
    nodeAbnormality = countAbnormalNode(nodeAbnormality,abrThreshold);
    
    %% Save node abnormality of each subjects
      save(['Results/abnormalityGIF/nodeAbnormality_' num2str(metaData.IDP(sub))],...
          'nodeAbnormality','nTracts','gFA');
    
end

%% Node abnormality computation and data
results = 'Results/abnormalityGIF/';

[nodeAbnor,nodeAbnorCount,theshold] = concatenateAbnormality(metaData,results);
nodeAbnor = rev3FlipNodeAbnor(nodeAbnor,metaData);

%% Get discrimination and plot results

[d_ILAE1vs3to5,auc_ILAE1vs3to5]=computeDiscrimination(nodeAbnorCount,metaData);
plotDiscrimination(d_ILAE1vs3to5,auc_ILAE1vs3to5,theshold);
plotOutcomeRelapse(nodeAbnorCount,auc_ILAE1vs3to5,metaData);

%% Effect of Surgery in Reducing Node Abnormality at Year 1
[~,surgInfLobe,surgNaiveLobe] = rev3countAbnormalNode(nodeAbnor,...
    theshold.percentAbr/100,atlas,auc_ILAE1vs3to5);
[statSF,statNSF] = plotAbrLobes(surgNaiveLobe,surgInfLobe,metaData);