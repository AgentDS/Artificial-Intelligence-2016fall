
trainData2=sortrows(trainData,2);
m=length(trainData(:,1));
trainData(:,7)=zeros(m,1);%标记是否浏览过user_item避免重复样例
trainData2(2197730,:)=zeros(1,6);
trainData(2197730,:)=zeros(1,7);
NewtrainData=zeros(1000000,12);
k=1;
for i=1:m
    if trainData(i,7)==0
        userid=trainData(i,1);
        itemid=trainData(i,2);
        label=0;
            
        j=i;
        if i==1||trainData(i,1)~=trainData(i-1,1)%只有userid变了的情况才重新计算user特征
            user_buy=0;
            user_jiaohu=0;
            while trainData(j,1)==userid
                if trainData(j,5)~=18
                    if trainData(j,3)==4
                        user_buy=user_buy+1;
                    else
                        user_jiaohu=user_jiaohu+1;
                    end
                end
                j=j+1;
            end
        end

        useritem_buy=0;
        useritem_jiaohu=0;
        j=i;
        while trainData(j,1)==userid
            if itemid==trainData(j,2)&&trainData(j,5)~=18%特征值获取
                trainData(j,7)=1;%记录已浏览过
                if trainData(j,3)==4
                    useritem_buy=useritem_buy+1;
                else
                    useritem_jiaohu=useritem_jiaohu+1;
                end
            end
            if trainData(j,5)==18&&trainData(j,3)==4%标签获取
                label=1;
            end
            j=j+1;
        end

        item_buy=0;
        item_jiaohu=0;
        j=1;
        while trainData2(j,2)<=itemid && j~=m
            j=j+100000;
            if j>m
                j=m;
            end
        end
        while trainData2(j,2)>=itemid && j~=1
            j=j-1000;
            if j<1
                j=1;
            end
        end
        if j>2197700
            fprintf('%d\n',j)
        end
        while trainData2(j,2)<itemid
            j=j+1;
        end
        while trainData2(j,2)==itemid && j<=m
            if trainData2(j,5)~=18
                if trainData2(j,3)==4
                    item_buy=item_buy+1;
                else
                    item_jiaohu=item_jiaohu+1;
                end
            end
            j=j+1;
        end
        
        if trainData(i,5)~=18
            NewtrainData(k,1)=userid;
            NewtrainData(k,2)=itemid;
            NewtrainData(k,3)=label;
            NewtrainData(k,4)=user_jiaohu;
            NewtrainData(k,5)=user_buy;
            NewtrainData(k,6)=user_buy/user_jiaohu;
            NewtrainData(k,7)=item_jiaohu;
            NewtrainData(k,8)=item_buy;
            NewtrainData(k,9)=item_buy/item_jiaohu;
            NewtrainData(k,10)=useritem_jiaohu;
            NewtrainData(k,11)=useritem_buy;
            NewtrainData(k,12)=useritem_buy/useritem_jiaohu;
            %……
            k=k+1;
        end
    end
    if mod(i,1000)==0
        fprintf('%d\n',i)
    end
end