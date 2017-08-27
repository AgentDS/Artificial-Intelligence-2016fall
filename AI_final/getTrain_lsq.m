load('/Users/liangsiqi/Documents/MATLAB/MyData/fresh_comp_offline/data16_18double.mat')
%% get unique user-item set
k = 0;  % user-item count
m = length(trainData);
NewtrainData = zeros(1000000,12);
for i = 1:m
    user_id = trainData(i,1);
    item_id = trainData(i,2);
    if (~Exist_user_item(user_id, item_id, NewtrainData(:,1:2)) && trainData(i,5)~=18)
        k = k + 1;
        NewtrainData(k,1) = user_id;
        NewtrainData(k,2) = item_id;
    end
    if mod(i,10000)==0
        i
    end
end

% fetch features
user_item_cnt = size(NewtrainData,1);
jiaohu_col = ((trainData(:,3) ~= 4) & (trainData(:,5) ~= 18));  % all behaviors except buying
buy18_col = ((trainData(:,3) == 4) & (trainData(:,5) == 18));  % buy in 12-18
buy16_17_col = ((trainData(:,3) == 4) & ((trainData(:,5) == 16)|(trainData(:,5) == 17)));    % buy in 12-16 or 12-17

% for k = 1:user_item_cnt
%     user_id = NewtrainData(k,1);
%     item_id = NewtrainData(k,2);
%     user_col = (trainData(:,1) == user_id);
%     item_col = (trainData(:,2) == item_id);
%     
%     user_jiaohu = sum(jiaohu_col & user_col);
%     user_buy = sum(buy16_17_col & user_col);
%     user_buy_jiaohu = user_buy/user_jiaohu;
%     
%     item_jiaohu = sum(jiaohu_col & item_col);
%     item_buy = sum(buy16_17_col & item_col);
%     item_buy_jiaohu = item_buy/item_jiaohu;
%     
%     user_item_jiaohu = sum(jiaohu_col & item_col & user_col);
%     user_item_buy = sum(buy16_17_col & item_col & user_col);
%     user_item_buy_jiaohu = user_item_buy/user_item_jiaohu;
%     
%     NewtrainData(k,1) = user_id;
%     NewtrainData(k,2) = item_id;
%     NewtrainData(k,3) = (sum(user_col & item_col & buy18_col) >0);
%     NewtrainData(k,4) = user_jiaohu;
%     NewtrainData(k,5) = user_buy;
%     NewtrainData(k,6) = user_buy_jiaohu;
%     NewtrainData(k,7) = item_jiaohu;
%     NewtrainData(k,8) = item_buy;
%     NewtrainData(k,9) = item_buy_jiaohu;
%     NewtrainData(k,10) = user_item_jiaohu;
%     NewtrainData(k,11) = user_item_buy;
%     NewtrainData(k,12) = user_item_buy_jiaohu;
%     if mod(k,1000) == 0
%         k
%     end
% end 