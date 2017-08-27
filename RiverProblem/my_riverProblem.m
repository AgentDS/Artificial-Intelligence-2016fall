function my_riverProblem
%% ��������
clc
clear all
global numans 
global mat_back  % ���ڻ��ݵľ���
% mat_back= [��i�� ��״̬(����ǰ) ���� ��(i+1)�� ��״̬(���ߺ�) �Ƿ����]
% ÿ����״̬�;���������Ԫ�����,��һ��Ϊ����ʿ����,�ڶ���ΪҰ������
% ������,��mat_back��Ӧ��ĩβԪ��Ϊ1;����Ϊ0
%% ������ʼ��
mat_back= zeros(1,9);  % ��ʼ��mat_back
numans= 0;  % ��ʼ���������и���

%% ���õݹ����
getd([3 3],1,[-1 -1 -1 -1],[-1 -1 -1 -1]);

sprintf('\n�ܹ���%d���ľ�������', numans)
size(mat_back)  % �������ߴ�

%% ���ݵõ����Ӳ���
mat_back= unique(mat_back,'rows');  % �����ظ���

row_no= find(mat_back(:,9)==1);  % �ҳ����һ���ľ���
mat_back(row_no,:)

for i= 1:length(row_no)
    disp(sprintf('��%4d������',i))
    cur_step_status= mat_back(row_no(i),1:3);
    step= mat_back(row_no(i),1);
    cur_dec_seq(step,:)= mat_back(row_no(i),1:9);
    
    % ֻҪ��û����̬[3,3],���������
    while ~vec_equal(cur_step_status(2:3),[3,3])
        id_mat= find(mat_back(:,9)~=1);
        mid_mat_back= mat_back(id_mat,[6 7 8]);
        [r,id]= vec_in_matrix(cur_step_status,mid_mat_back);
        id= id_mat(id);
        step= step-1;
        if (r~=1 | id<=0)
            disp('���ݴ���')
            pause
            return;
        end
        % ��������
        cur_dec_seq(step,:)= mat_back(id,1:9);
        % ��ǰstep״̬
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


