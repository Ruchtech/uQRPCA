clear;
close all;
clc;

% Set parameters
NameDirGT   = './ProjectFolder/GT/';  % Path to ground truth (GT) folder
Method      = 'Mean';                 % Name of the method to evaluate
NameDirBC   = strcat('./ProjectFolder/Results/', Method, '/IBMtest2/'); % Path to the result folder of the method
Format      = '.png';                % Image format
OutputStyle = 'excel';               % Output format: 'excel' or 'latex'
Show        = 0;                     % Whether to visualize the results (0: off, 1: on)

% Get all image files from the result (BC) folder
BCImages = dir(fullfile(NameDirBC, ['*' Format]));
numImages = length(BCImages);

% Initialize arrays to store evaluation metrics
AGE     = zeros(numImages,1);  % Average Gray-level Error
pEPs    = zeros(numImages,1);  % Percentage of Error Pixels
pCEPs   = zeros(numImages,1);  % Percentage of Clustered Error Pixels
MSSSIM  = zeros(numImages,1);  % Multi-Scale Structural Similarity
PSNR    = zeros(numImages,1);  % Peak Signal-to-Noise Ratio
CQM     = zeros(numImages,1);  % Color image Quality Measure

% Get the unique GT image path (assuming only one GT image exists)
GTImage = dir(fullfile(NameDirGT, ['*' Format]));
if length(GTImage) ~= 1
    error('The GT folder should contain exactly one image.');
end
NameGT = fullfile(NameDirGT, GTImage(1).name);

% Evaluate each image in the result (BC) folder against the GT image
for j = 1:numImages
    % Get the current background-computed (BC) image path
    NameBC = fullfile(NameDirBC, BCImages(j).name);

    % Evaluate current BC image using the GT image
    [AGE(j), pEPs(j), pCEPs(j), MSSSIM(j), PSNR(j), CQM(j)] = Evaluate3(NameGT, NameBC, Show);
    
    % Print metrics for current image
    fprintf('Image %d: AGE = %.4f, pEPs%% = %.4f, pCEPs%% = %.4f, MSSSIM = %.4f, PSNR = %.4f, CQM = %.4f\n', ...
            j, AGE(j), pEPs(j) * 100, pCEPs(j) * 100, MSSSIM(j), PSNR(j), CQM(j));
end

% Compute average values of all evaluation metrics
mean_AGE    = mean(AGE);
mean_pEPs   = mean(pEPs) * 100;
mean_pCEPs  = mean(pCEPs) * 100;
mean_MSSSIM = mean(MSSSIM);
mean_PSNR   = mean(PSNR);
mean_CQM    = mean(CQM);

% Print final evaluation results in the desired format
if strcmp(OutputStyle, 'latex')
	OutputFormat = '%16s & %.4f & %.4f & %.4f & %.4f & %.4f & %.4f \\\\\n';
else
	OutputFormat = '%16s %9.4f %9.4f %9.4f %9.4f %9.4f %9.4f\n';
end

fprintf('**************** Results of Method: %s ******************\n', Method);
fprintf('Sequence            AGE       pEPs%%     pCEPS%%    MSSSIM    PSNR       CQM\n');
fprintf(OutputFormat, 'Average', mean_AGE, mean_pEPs, mean_pCEPs, mean_MSSSIM, mean_PSNR, mean_CQM);
