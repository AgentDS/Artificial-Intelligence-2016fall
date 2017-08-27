% clear all
% clc
% fn = '/Users/liangsiqi/Documents/MATLAB/MyData/fresh_comp_offline/tianchi_fresh_comp_train_user.csv';
% fid = fopen(fn);
% M= {};
% i= 1;
% while ~feof(fid)
%     line= fgetl(fid);
%     M{i,1}= line;
%     i= i+1;
%     if mod(i,100000)==0
%         i
%     end
% end
% i = i - 1;
% m = length(M);
% newM = {};
% k = 0;
% for i = 1:m
%     line = M{i,1};
%     len = length(line);
%     if strcmp(line(len-7:len-3),'12-16') 
%         k = k + 1;
%         newM{k,1} = line;
%     end
%     if strcmp(line(len-7:len-3),'12-17') 
%         k = k + 1;
%         newM{k,1} = line;
%     end
%     if strcmp(line(len-7:len-3),'12-18') 
%         k = k + 1;
%         newM{k,1} = line;
%     end
%     
% end
% 
% m = length(newM);
% trainData = zeros(m,6);
% for i = 1:m
%     line = newM{i,1};
%     S = regexp(line, ',', 'split');
%     trainData(i,1) = str2num(S{1,1});   % user_id
%     trainData(i,2) = str2num(S{1,2});   % item_id
%     trainData(i,3) = str2num(S{1,3});   % behavior_type 
%     trainData(i,4) = str2num(S{1,5});   % item_category
%     time = S{1,6};
%     trainData(i,5) = str2num(time(9:10));   % date
%     trainData(i,6) = str2num(time(12:13));   % hour
% end