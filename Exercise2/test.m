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
