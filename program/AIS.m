function AIS(saverect1datanum,dataEnImg,rectsize,rectrepetition,namecount,saverect2datanum)
%read rectangle data
RECT=load(saverect1datanum);RECT=RECT.RECT;
i=namecount;
[lat,lon]=find(dataEnImg(:,:,i));
rectdata=zeros(100,6);
RECT2=zeros(size(dataEnImg,1),size(dataEnImg,2),4);
for i=min(lat)-rectsize(2):max(lat)+rectsize(2)
    for j=min(lon)-rectsize(2):max(lon)+rectsize(2)
        pointnum=0;
        %........................寻找该粒子rectsize(2)*rectsize(2)栅格块中的矩形中心，找到覆盖该粒子的矩形
        %........................按照矩形内粒子的密度进行排序，保留密度最高的前5个矩形
        for ii=i-rectsize(2):i+rectsize(2)
            for jj=j-rectsize(2):j+rectsize(2)
                if ii<=size(dataEnImg,1) & jj<size(dataEnImg,2) &ii>0&jj>0
                    if RECT(ii,jj,2)>0
                        L=RECT(ii,jj,2);
                        d=RECT(ii,jj,3);
                        thete=RECT(ii,jj,1);
                        latCenter=ii;
                        lonCenter=jj;
                        [xplot,yplot]=rect(latCenter,lonCenter,thete,L,d);%生成矩形
                        f=fact(i,j,thete,xplot,yplot);
                        if f==1
                            pointnum=pointnum+1;
                            rectdata(pointnum,1)=latCenter;
                            rectdata(pointnum,2)=lonCenter;
                            rectdata(pointnum,3:end)=RECT(latCenter,lonCenter,:);%记录该矩形
                        end
                    end
                end
            end
        end
        if pointnum>=1&pointnum<=rectrepetition
            for ii=1:size(rectdata,1)
                if rectdata(ii,end)>0
                    RECT2(rectdata(ii,1),rectdata(ii,2),1:4)=rectdata(ii,3:end);
                end
            end
        elseif pointnum>rectrepetition
            %.......................对记录的矩形按照密度由大到小进行排序，将密度最大的前5个保存在RECT2中
            cutvaluetemp=sort(rectdata(:,6),'descend');
            cutvalue=cutvaluetemp(rectrepetition);
            for ii=1:size(rectdata,1)
                if rectdata(ii,end)>=cutvalue
                    RECT2(rectdata(ii,1),rectdata(ii,2),1:4)=rectdata(ii,3:end);
                end
            end
        end
    end
end
savefile=saverect2datanum;
clear RECT
RECT=RECT2;
driftnum=length(RECT(RECT(:,:,2)>0));
disp(['Then the number of objects is ',num2str(driftnum)]);
save(savefile,'RECT');