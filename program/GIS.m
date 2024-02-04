function saverect1datanum=GIS(dataEnImg,rectnum,rectsize,rectdensity,saverect1datanum,namecount)
i=namecount;
%locate the position of enteromorpha particles
[lat,lon]=find(dataEnImg(:,:,i));
chosennum=randperm(length(lat),round(length(lat)));
latchosen=lat(chosennum);
lonchosen=lon(chosennum);
%initialization parameters
chosennum=0;
recnum=0;
RECT=zeros(size(dataEnImg,1),size(dataEnImg,2),4);
%Generate simulation objects
for rc=1:length(latchosen)
    for num=1:rectnum
        recnum=recnum+1;
        L=randi(rectsize);
        d=randi(rectsize);
        thete=randi([0,90]);
        lonCenter=lonchosen(rc);
        latCenter=latchosen(rc);
        [xplot,yplot]=rect(latCenter,lonCenter,thete,L,d);%生成矩形
        pointnum=0;
        for ii=latCenter-50:latCenter+50
            for jj=lonCenter-50:lonCenter+50
                f=fact(ii,jj,thete,xplot,yplot);
                if ii<=size(dataEnImg,1) & jj<size(dataEnImg,2)
                    if f==1 & dataEnImg(ii,jj,i)==1
                        pointnum=pointnum+1;
                    end
                end
            end
        end
        RectRecord(recnum)=pointnum/(L*d);
        if RectRecord(recnum)>rectdensity
            chosennum=chosennum+1;
            RECT(latCenter,lonCenter,1:3)=[thete,L,d];%存储矩形,存储方式为（矩形序号，中心lat，中心lon，thete，L，d）
            RECT(latCenter,lonCenter,4)=pointnum/(L*d);
        end
    end
end
savefile=saverect1datanum;
driftnum=length(RECT(RECT(:,:,2)>0));
disp(['Firstly the number of objects is ',num2str(driftnum)]);
save(savefile,'RECT');