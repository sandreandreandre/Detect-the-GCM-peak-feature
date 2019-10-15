
finalFeature = [zerocrossingcount1' polyCoeff featureMatrix pos_one neg_one];
normalizedFeature = normalize(finalFeature);

normalizedFeature(isnan(normalizedFeature))=0;

[coeff, score, latent] = pca(normalizedFeature);

top5Eigen = coeff(:,1:5);

newFeature = normalizedFeature*top5Eigen;



scatter(1:33, newFeature(:,1));
%plot.LineWidth = 3;


csvwrite('coeff.csv',coeff);
csvwrite('score.csv',score);
csvwrite('latent.csv',latent);
csvwrite('zerocrossingcount.csv', zerocrossingcount1');
csvwrite('polyCoeff.csv',polyCoeff);
csvwrite('FFT.csv',featureMatrix);
csvwrite('ConfidenceInterval1.csv',pos_one);
csvwrite('ConfidenceInterval2.csv',neg_one);