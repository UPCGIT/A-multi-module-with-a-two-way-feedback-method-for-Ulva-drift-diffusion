%%
%创建函数，用于判断像素点是否位于矩形内部
function f=fact(lat,lon,thete,xplot,yplot)
%长边直线
f=0;
a=((lat-yplot(1))-((yplot(2)-yplot(1))/(xplot(2)-xplot(1))*((lon-xplot(1)))))*...
    ((lat-yplot(3))-((yplot(3)-yplot(4))/(xplot(3)-xplot(4))*((lon-xplot(3)))));
b=((lat-yplot(2))-((yplot(2)-yplot(3))/(xplot(2)-xplot(3))*((lon-xplot(2)))))...
    *((lat-yplot(4))-((yplot(1)-yplot(4))/(xplot(1)-xplot(4))*((lon-xplot(4)))));
if a<0&&b<0
    f=1;
else
    f=0;
end
end
