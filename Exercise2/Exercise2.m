function [D, Error, ConfusionMatrix] = Exercise2(dMax)
%% load image and some init values
% load training data
images = loadMNISTImages('train-images.idx3-ubyte');
labels = loadMNISTLabels('train-labels.idx1-ubyte');
% load test data
imagesTest = loadMNISTImages('t10k-images.idx3-ubyte');
labelsTest = loadMNISTLabels('t10k-labels.idx1-ubyte');
% nubmer of test samples
N = size(labelsTest, 1);
% number of labels
kindeOfLabels = 10;
% labels out of our classifier
labelsOutput = zeros(N, 1);
% init error vector
error = zeros(dMax, 1);
% init ConfusionMatrix cells
ConfusionMatrix = cell(dMax, 1);

%% 
% zero mean
imagesMean = mean(images, 2);
imagesZeroMean = images - repmat(imagesMean,1,size(images, 2));
imagesTestZeroMean = imagesTest - repmat(imagesMean,1,size(imagesTest, 2));
% covariance
imagesCOV = cov(imagesZeroMean');

%% loop part
for d = 1:dMax
    [eigenVectorsDhighest,h]=eigs(imagesCOV,d);
    imagesPCA = eigenVectorsDhighest'*images;

  
    % new solution without loop
    % init matrix eachDigit
    eachDigit = zeros(size(imagesTest, 2), kindeOfLabels);
    imagesTestPCA = eigenVectorsDhighest'*imagesTest;
    for i = 1:kindeOfLabels
        eachDigitMean = mean(imagesPCA(:, labels' == (i-1)), 2);
        eachDigitCOV = cov(imagesPCA(:, labels' == (i-1))');
        eachDigit(:, i) = mvnpdf(imagesTestPCA', eachDigitMean', eachDigitCOV);
    end
    [nouse, labelsOutput] = max(eachDigit');
    labelsOutput = (labelsOutput-1)';

    % print clasification error
%     fprintf('\nFor d = %f error is: %f\n',d, (1 - mean(double(labelsOutput == labelsTest))) * 100);
    ConfusionMatrix{d} = confusionmat(labelsTest, labelsOutput);
    error(d) = (1 - mean(double(labelsOutput == labelsTest))) * 100;
end

% output
[Error, D] = min(error);
ConfusionMatrix = ConfusionMatrix{D};
plot(error, 'r-');
end