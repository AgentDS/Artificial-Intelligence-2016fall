%% Neural Network(BP Algorithm)  
%  predict on test data set
clear all
clc
%% load the test data set and training data set 
load('/Users/liangsiqi/Documents/MATLAB/MyData/AI_EX3.mat')
X= TrainDataSet(:,1:4);  % feature information
y= TrainDataSet(:,5) + 1;    % label information
disp('Data set loading succeeded.')
disp('---------------------------------------------')
%% Setup the parameters 
input_layer_size  = 4;    % 4 features
hidden_layer_size = 25;   % 25 hidden units
num_labels = 3;           % 3 labels, from 1 to 3   
%  You should also try different values of lambda
lambda = 0.01;
accuracy1= zeros(10,1);
accuracy2= zeros(10,1);
m= size(X,1);  % number of training samples
disp(' k     Training Set Accuracy     Test Set Accuracy')
for k= 1:10
    %% Initializing pameters
    %fprintf('\nInitializing Neural Network Parameters ...\n')
    initial_Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size);
    initial_Theta2 = randInitializeWeights(hidden_layer_size, num_labels);
    % Unroll parameters
    initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)];

    %% Training NN with training data set
        % using gradient descent
        alpha= 0.1;    num_iters= 1000;
        [nn_params, J_history] = nngradientDescent(input_layer_size, ...
                                           hidden_layer_size, ...
                                           num_labels,...
                                           initial_nn_params, ...
                                           alpha, num_iters,...
                                           X, y, lambda);
                                       
        Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                         hidden_layer_size, (input_layer_size + 1));

        Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                         num_labels, (hidden_layer_size + 1));
        %% Predict on Training Set
          pred_train = predict(Theta1, Theta2, X);
          accuracy1(k)= mean(double(pred_train == y)) * 100;
    
        %% Predict on Test Set
        X_test= TestDataSet(:,1:4);
        y_test= TestDataSet(:,5) + 1;
        pred_test = predict(Theta1, Theta2, X_test);
        accuracy2(k)= mean(double(pred_test == y_test)) * 100;
        % display accuracy on test set and training set
        fprintf('%2d      %8.4f                  %8.4f\n',k,accuracy1(k),accuracy2(k));          
end

%% display average accuracy and std
disp(' ')
disp(' ')
disp('=======================================================')
disp(['Average Accuracy on test set:  ' num2str(sum(accuracy2)/10)])
disp(['Standard Deviation on test set of 10 training:  ' num2str(std(accuracy2/100))])
disp(' ')
disp(['Average Accuracy on training set:  ' num2str(sum(accuracy1)/10)])
disp(['Standard Deviation on training set of 10 training:  ' num2str(std(accuracy1/100))])
