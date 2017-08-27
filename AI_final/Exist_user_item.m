function flag = Exist_user_item(user_id, item_id, table)
% if user-item has already existed in table, flag = 1; otherwise flag = 0
% first column of table is user_ids, second column of table is item_ids
existcol = (user_id==table(:,1)) & (item_id==table(:,2));
flag = (sum(existcol)>0);
end