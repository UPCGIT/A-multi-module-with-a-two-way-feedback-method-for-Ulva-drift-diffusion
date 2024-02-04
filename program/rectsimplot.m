function rectsimplot(dataEnImg,land,saverect,namecount)
%绘制矩形
%..................绘制绿潮分布
figure
%创建RGB图层
R=zeros(size(land));
G=zeros(size(land));
B=zeros(size(land));
%设置陆地为棕色
R(land==0)=205/255;
G(land==0)=205/255;
B(land==0)=180/255;
%设置海洋为蓝色
R(land==1)=142/255;
G(land==1)=229/255;
B(land==1)=238/255;
%设置绿潮为绿色
R( dataEnImg(:,:,namecount)==1)=46/255;
G( dataEnImg(:,:,namecount)==1)=139/255;
B( dataEnImg(:,:,namecount)==1)=87/255;
imshow(cat(3,R,G,B))
rectangle('Position',[348,404,115,152],'Linewidth',3,'LineStyle','-','EdgeColor','r')
figure
%创建RGB图层
R=zeros(size(land));
G=zeros(size(land));
B=zeros(size(land));
%设置陆地为棕色
R(land==0)=205/255;
G(land==0)=205/255;
B(land==0)=180/255;
%设置海洋为蓝色
R(land==1)=142/255;
G(land==1)=229/255;
B(land==1)=238/255;
%设置绿潮为绿色
R( dataEnImg(:,:,namecount)==1)=46/255;
G( dataEnImg(:,:,namecount)==1)=139/255;
B( dataEnImg(:,:,namecount)==1)=87/255;
imshow(cat(3,R,G,B))
hold on
RECT=load(saverect);RECT=RECT.RECT;%读取数据
for ii=1:size(RECT,1)
    for jj=1:size(RECT,2)
        if RECT(ii,jj,end)>0
            L=RECT(ii,jj,2);
            d=RECT(ii,jj,3);
            thete=RECT(ii,jj,1);
            lonCenter=jj;
            latCenter=ii;
            [xplot,yplot]=rect( latCenter, lonCenter,thete,L,d);
            plot(xplot,yplot,'k');
        end
    end
end
rectangle('Position',[348,404,115,152],'Linewidth',3,'LineStyle','-','EdgeColor','r')
end
% savefile='RECT\4.png';
% print(gcf,savefile,'-dpng','-r330');