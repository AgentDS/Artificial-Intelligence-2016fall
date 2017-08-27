function r = getid(step)
if mod(step,2)==1  % 若为奇数步,则为从左岸到右岸
    r= -1;
else
    r= 1;  % 若为偶数步,则为从右岸到左岸
end