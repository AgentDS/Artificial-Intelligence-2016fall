% m = size(NewtrainData,1);
% m_test = size(NewtestData,1);
% % 
% X = NewtrainData(:,4:12);
% sigma = std(X); mu = mean(X);
% upper = (X-repmat(mu,size(X,1),1));
% below = repmat(sigma, size(X,1),1);
% X = upper./below;
% y = NewtrainData(:,3);
% X_test = NewtestData(:,4:12);
% X_test = (X_test-repmat(mu,size(X_test,1),1))./repmat(sigma, size(X_test,1),1);
% b = glmfit(X,y,'binomial');
% score_train = glmval(b,X,'logit');
alpha = 0.26
y_ = (score_train > alpha);
prec = sum(y_&y)/sum(y_);
recall = sum(y_&y)/sum(y);
prec1 = sum(y_==y)/length(y);
F1 = 2*prec*recall/(prec+recall);
fprintf('precise: %.4f      pred buy: %d      true buy: %d      \nrepeat buy: %d      F1: %.4f\n',...
         prec1,sum(y_),sum(y),sum(y_&y),F1)
% score_test = glmval(b,X_test,'logit');
%y_test = (score_test > alpha);
% idx = find(y_test==1);
% user_item = zeros(length(idx),2);
%user_item(:,:) = NewtestData(idx,1:2);
