function getd(status,step,ever1,ever2)
% status ������,����Ԫ�طֱ��ʾ���޵�ʿ������Ұ������
% ever1Ϊ������,�����ĸ�Ԫ�طֱ��ʾ���޵�ʿ����,��Ұ����,�󰶾���
% ever2Ϊ������,�����ĸ�Ԫ�طֱ��ʾ�Ұ��޵�ʿ����,�Ұ�Ұ����,�Ұ�����
global numans
global mat_back
if status==[0 0]  % ���ɹ��ɺ�
    sprintf('��Ϸ����, �ɹ��ɺ�!!! �7�8�������ϣ��R�6�3�Q���ϩ��������7�8')
    return;
end

%% ����״̬
allow_s= [0 1; 0 2; 0 3; 3 0; 3 1; 3 2; 3 3; 1 1; 2 2];
allow_d= [1 0; 0 1; 1 1; 2 0; 0 2];
row_d= size(allow_d,1);

for i= 1:row_d
    cur_status= status + getid(step)*allow_d(i,:);
    % ��鵱ǰ�����Ƿ�Ϸ�
    if cur_status(1)<=3 & cur_status(2)<=3 & ...
       cur_status(1)>=0 & cur_status(2)>=0 & ...
       (cur_status(1)==0 | cur_status(2)==0 | ...
        (cur_status(1)>0 & cur_status(1)>=cur_status(2))) & ...
        ~(cur_status(1)==3 & cur_status(2)==3)
       cursd= [cur_status,allow_d(i,:)];
       if cur_status(1)==0 & cur_status(2)==0  % ���ݹ�ﵽ��������
           mat_back(size(mat_back,1)+1,:)= [step,status,allow_d(i,:),0,0,0,1];
           numans= numans+1;
           sprintf('�ɹ�����!!! �7�8�������ϣ��R�6�3�Q���ϩ��������7�8');
           return;
       else
           if getid(step)==1
               if  vec_in_matrix(cur_status,allow_s)==1 & vec_in_matrix(cursd,ever1)==0
                   ever1= [ever1;cursd];
                   mat_back(size(mat_back,1)+1,:)= [step,status,allow_d(i,:),step+1,cur_status,0];
                   getd(cur_status,step+1,ever1,ever2);
               end
           else
               if  vec_in_matrix(cur_status,allow_s)==1 & vec_in_matrix(cursd,ever2)==0
                   ever2= [ever2;cursd];
                   mat_back(size(mat_back,1)+1,:)= [step,status,allow_d(i,:),step+1,cur_status,0];
                   getd(cur_status,step+1,ever1,ever2);
               end
           end
       end
    else
        
    end
end
