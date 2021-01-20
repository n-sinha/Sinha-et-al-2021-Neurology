function nTracts = computeSurgeryNetwork(nTracts)

surgicallyNaive = nTracts.surgicallyNaive.surgicallyNaive;
surgicallyInformed = nTracts.surgicallyInformed.surgicallyInformed;

surgeryNetwork = surgicallyNaive - surgicallyInformed; % Subtract
surgeryNetwork(surgeryNetwork>0) = 1; % Binarise
surgeryNetwork = surgeryNetwork - diag(diag(surgeryNetwork)); % Remove Diagonal

nTracts.surgicallyNaive = surgicallyNaive;
nTracts.surgicallyInformed = surgicallyInformed;
nTracts.surgeryNetwork = surgeryNetwork;

end