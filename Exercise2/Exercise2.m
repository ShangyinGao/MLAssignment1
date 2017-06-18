function [d, Error, ConfusionMatrix] = Exercise2(dMax)
% clear
clear; close all; clc;


%%
% load training data
images = loadMNISTImages('train-images.idx3-ubyte');
labels = loadMNISTLabels('train-labels.idx1-ubyte');
% load test data
images_test = loadMNISTImages('t10k-images.idx3-ubyte');
labels_test = loadMNISTLabels('t10k-labels.idx1-ubyte');
d = 15;
N = size(labels, 1);
kindeOfLables = 10;

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
imagesEachDigit = cell(kindeOfLables, 3);
% [labelsSort, labelsIndex] = sort(labels);
for i=1:kindeOfLables
    imagesEachDigit{i, 1} = imagesPCA(:, find(labels==(i-1)));
    imagesEachDigit{i, 2} = mean(imagesEachDigit{i, 1}, 2);
    imagesEachDigit{i, 3} = cov(imagesEachDigit{i, 1}');
end

%%
% for a novel test input
for i = 1:kindeOfLables
    % zero mean
    testImageZeroMean = images_test(:, 1) - imagesMean;
    % project on the leared bias
    testImagePCA = eigenVectorsDhighest'*testImageZeroMean;
    % calculate likelihood
    
end



end