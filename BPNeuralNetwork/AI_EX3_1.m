%% Neural Network(BP Algorithm)  
%  choose lambda
%% store the test data set in TestDataSet 
%  TestDataSet has 5 columns, the 5th column is the label 
% fn= [pwd '/MyData/Iris-test.txt'];
% fid= fopen(fn);
% TestDataSet= zeros(10,5);
% k= 0;
% while ~feof(fid)
%     k= k + 1;
%     line= fgetl(fid);
%     TestDataSet(k,:)= str2num(line); 
% end

%% store the training data set in TrainDataSet 
%  TrainDataSet has 5 columns, the 5th column is the label
% fn= [pwd '/MyData/Iris-train.txt'];
% fid= fopen(fn);
% TrainDataSet= zeros(10,5);
% k= 0;
% while ~feof(fid)
%     k= k + 1;
%     line= fgetl(fid);
%     TrainDataSet(k,:)= str2num(line); 
% end
clear all
clc
load('/Users/liangsiqi/Documents/MATLAB/MyData/AI_EX3.mat')
X= TrainDataSet(:,1:4);  % feature information
y= TrainDataSet(:,5) + 1;    % label information
disp('Data set loading succeeded.')
fn= [pwd '/AI_ex/output2.txt'];
fid = fopen(fn,'wt');
%% Setup the parameters 
input_layer_size  = 4;    % 4 features
hidden_layer_size = 25;   % 25 hidden units
num_labels = 3;           % 3 labels, from 1 to 3   
%  You should also try different values of lambda
m= size(X,1);  % number of training samples
for lambda= [0]
    lambda
    totCVerror= zeros(10,1);
    totTrainerror= zeros(10,1);
    fprintf(fid,' k   Train error     CV error\n');
    for k= 1:10
        %% Initializing pameters
        %fprintf('\nInitializing Neural Network Parameters ...\n')
        initial_Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size);
        initial_Theta2 = randInitializeWeights(hidden_layer_size, num_labels);
        % Unroll parameters
        initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)];

        %% Training NN with training data set
        %fprintf('\nTraining Neural Network... \n')
        options = optimset('MaxIter', 200);
        %options = optimset('GradObj', 'on', 'MaxIter', 100);
        for i= 1:m
            if i==1
                X_train= X(2:m,:);    y_train= y(2:m);
                X_cv= X(1,:);         y_cv= y(1);
            elseif i==m
                X_train= X(1:m-1,:);    y_train= y(1:m-1);
                X_cv= X(m,:);         y_cv= y(m);
            else
                X_train= [X(1:i-1,:);X(i+1:m,:)];    
                y_train= [y(1:i-1);y(i+1:m)];
                X_cv= X(i,:);         y_cv= y(i);
            end
            % Create "short hand" for the cost function to be minimized
            costFunction = @(p) nnCostFunction(p, ...
                                               input_layer_size, ...
                                               hidden_layer_size, ...
                                               num_labels, X_train, y_train, lambda);

            % Now, costFunction is a function that takes in only one argument (the
            % neural network parameters)
            [nn_params, cost] = fmincg(costFunction, initial_nn_params, options);
            [cost_train,~] = nnCostFunction(nn_params, ...
                                           input_layer_size, ...
                                           hidden_layer_size, ...
                                           num_labels, ...
                                           X_train, y_train, lambda);

            [cost_cv,~] = nnCostFunction(nn_params, ...
                                           input_layer_size, ...
                                           hidden_layer_size, ...
                                           num_labels, ...
                                           X_cv, y_cv, lambda);

            %[nn_params, cost, ~, output] = fminunc(costFunction, initial_nn_params, options);
            % Obtain Theta1 and Theta2 back from nn_params
            Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                             hidden_layer_size, (input_layer_size + 1));

            Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                             num_labels, (hidden_layer_size + 1));

            % compute J_cv and J_train
            regulTerm= sum(sum(Theta1(:,2:input_layer_size+1).^2)) + sum(sum(Theta2(:,2:hidden_layer_size + 1).^2));

            J_cv= cost_cv - lambda*regulTerm/(2*1);;
            totCVerror(k)= totCVerror(k) + J_cv;

            J_train= cost_train - lambda*regulTerm/(2*(m-1));;
            totTrainerror(k)= totTrainerror(k) + J_train;
        %     %% Predict on Training Set
        %     pred = predict(Theta1, Theta2, X);
        %     fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == y)) * 100);
        % 
        %     %% Predict on Test Set
        %     X_test= TestDataSet(:,1:4);
        %     y_test= TestDataSet(:,5) + 1;
        %     pred_test = predict(Theta1, Theta2, X_test);
        %     fprintf('\nTest Set Accuracy: %f\n', mean(double(pred_test == y_test)) * 100);
        end
        totTrainerror(k)= totTrainerror(k)/m;
        totCVerror(k)= totCVerror(k)/m;
        disp(['k=' num2str(k)])
        fprintf(fid,'%2d    %.6f         %.6f\n',k,totTrainerror(k),totCVerror(k));
    end
    fprintf(fid,' \n');
    fprintf(fid,' \n');
    disp('=======================================================')
    disp(['lambda=' num2str(lambda) ' training ends'])
    fprintf(fid,'=====================================================\n');
    fprintf(fid,'lambda= %.3f\n' ,lambda);
    fprintf(fid,'Average J_cv=%.6f\n', mean(totCVerror));
    fprintf(fid,'Average J_train=%.6f\n', mean(totTrainerror));
    fprintf(fid,'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
end
