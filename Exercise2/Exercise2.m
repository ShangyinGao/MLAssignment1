function [d, Error, ConfusionMatrix] = Exercise2(dMax)
% clear
clear; close all; clc;


%%
% load training data
images = loadMNISTImages('train-images.idx3-ubyte');
labels = loadMNISTLabels('train-labels.idx1-ubyte');
% load test data
imagesTest = loadMNISTImages('t10k-images.idx3-ubyte');
labelsTest = loadMNISTLabels('t10k-labels.idx1-ubyte');
% d low dimensional space
d = 15;
% nubmer of test samples
N = size(labelsTest, 1);
% number of labels
kindeOfLabels = 10;
% for each test input kindOfLables number of pdf (matrix form)
PDFtemp = zeros(kindeOfLabels, 1);
% labels out of our classifier
labelsOutput = zeros(N, 1);

%% 
% zero mean
imagesMean = mean(images, 2);
imagesZeroMean = images - imagesMean;
% covariance
imagesCOV = cov(imagesZeroMean');
% eigenvalues and eigenvectors
[eigenVectors, eigenValues] = eig(imagesCOV);
eigenValues = diag(eigenValues);
% d highest eigenvlues
[eigenValuesSort, eigenValuesIndex] = sort(eigenValues, 'descend');
eigenValuesIndex = eigenValuesIndex(1:d);
% d highest eigenvactors
eigenVectorsDhighest = eigenVectors(:, eigenValuesIndex);
% reduced dimensional data
imagesPCA = eigenVectorsDhighest'*images;

%%
% calculate the mean and covariance of each digit class
% save the images of same digit in first cell, mean in second, covariance
% in third
imagesEachDigit = cell(kindeOfLabels, 3);
% [labelsSort, labelsIndex] = sort(labels);
for i=1:kindeOfLabels
    imagesEachDigit{i, 1} = imagesPCA(:, find(labels==(i-1)));
    imagesEachDigit{i, 2} = mean(imagesEachDigit{i, 1}, 2);
    imagesEachDigit{i, 3} = cov(imagesEachDigit{i, 1}');
end

%%
% loop of N to test each testImages
for j = 1:N
    % for a novel test input
    % zero mean
    testImageZeroMean = imagesTest(:, j) - imagesMean;
    % project on the leared bias
    testImagePCA = eigenVectorsDhighest'*testImageZeroMean;
    % calculate likelihood
    for i = 1:kindeOfLabels
        PDFtemp(i) = mvnpdf(testImagePCA, imagesEachDigit{i, 2}, imagesEachDigit{i, 3});
    end
    [PDFtempMax, PDFtempMaxIndex] = max(PDFtemp);
    % labels based on our classifier
    labelsOutput(j) = PDFtempMaxIndex - 1;

end
% print clasification error
fprintf('\nTraining Set Error: %f\n', (1 - mean(double(labelsOutput == labelsTest))) * 100);
ConfusionMatrix = confusionmat(labelsTest, labelsOutput);
% helperDisplayConfusionMatrix(ConfusionMatrix);

end