%%
%创建矩形生成函数
function [xplot,yplot]=rect(lon,lat,thete,L,d)
%生成逆时针旋转矩阵
R=[cos(thete),sin(thete);-sin(thete),cos(thete)];
a11=[-d/2,-L/2];
a12=[-d/2,L/2];
a21=[d/2,-L/2];
a22=[d/2,L/2];
a11=a11*R;
a12=a12*R;
a21=a21*R;
a22=a22*R;
xplot=lat+[a11(1),a12(1),a22(1),a21(1), a11(1)];
yplot=lon+[a11(2),a12(2),a22(2),a21(2), a11(2)];
end


