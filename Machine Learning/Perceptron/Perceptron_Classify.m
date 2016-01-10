function [ est_class_labels, classification_error ] = Perceptron_Classify( phi, class_labels, w )
% Reports the estimated classification 'est_class_labels' and the classification error 
% 'class_error' on the dataset given by feature matrix
% 'phi', class labels 'class_labels' and weight vector 'w'

%  Compute the Perceptron classification error
est_class_labels = [];
for n = 1 : size(phi, 1)
    val = (w'*phi(n,:)');
    if(val < 0)
        val_new = 1;
    else
        val_new = -1;
    end

    est_class_labels = [est_class_labels val_new];
end
classification_error = length(find((est_class_labels - class_labels') == 0))/length(class_labels);

end

