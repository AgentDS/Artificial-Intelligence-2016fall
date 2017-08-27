function [r,id] = vec_in_matrix(cur,matrix)
% 判定向量cur是否在矩阵matrix中
[m,n]= size(matrix);
for i= 1:m
    if vec_equal(cur,matrix(i,:))==1
        r= 1;    id= i;    return;
    end 
end
r= 0;