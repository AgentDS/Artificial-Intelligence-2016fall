function my_riverProblem
%% 变量声明
clc
clear all
global numans 
global mat_back  % 用于回溯的矩阵
% mat_back= [第i步 左岸状态(决策前) 决策 第(i+1)步 左岸状态(决策后) 是否结束]
% 每个左岸状态和决策由两个元素组成,第一个为传教士人数,第二个为野人人数
% 若结束,则mat_back对应行末尾元素为1;否则为0
%% 变量初始化
mat_back= zeros(1,9);  % 初始化mat_back
numans= 0;  % 初始化决策序列个数

%% 调用递归求解
getd([3 3],1,[-1 -1 -1 -1],[-1 -1 -1 -1]);

sprintf('\n总共有%d长的决策序列', numans)
size(mat_back)  % 输出矩阵尺寸

%% 回溯得到过河策略
mat_back= unique(mat_back,'rows');  % 消除重复行

row_no= find(mat_back(:,9)==1);  % 找出最后一步的决策
mat_back(row_no,:)

for i= 1:length(row_no)
    disp(sprintf('第%4d个策略',i))
    cur_step_status= mat_back(row_no(i),1:3);
    step= mat_back(row_no(i),1);
    cur_dec_seq(step,:)= mat_back(row_no(i),1:9);
    
    % 只要还没到初态[3,3],则继续回溯
    while ~vec_equal(cur_step_status(2:3),[3,3])
        id_mat= find(mat_back(:,9)~=1);
        mid_mat_back= mat_back(id_mat,[6 7 8]);
        [r,id]= vec_in_matrix(cur_step_status,mid_mat_back);
        id= id_mat(id);
        step= step-1;
        if (r~=1 | id<=0)
            disp('回溯错误')
            pause
            return;
        end
        % 决策序列
        cur_dec_seq(step,:)= mat_back(id,1:9);
        % 当前step状态
        cur_step_status= mat_back(id,1:3);
    end
    
    if step~=1
        disp('step~=1')
        cur_step_status
        cur_dec_seq
        return;
    end
    cur_dec_seq
end


