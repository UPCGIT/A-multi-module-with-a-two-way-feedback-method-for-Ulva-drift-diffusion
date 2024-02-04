function savefile=DriftDriveWithPixels(dataEnImg,dataNwave,dataEwave,dataNwind,dataEwind,sim,EnNum,year,wc,gi,results_dir)
savePath=([results_dir,'\DDBFMResult3']);
if ~exist(savePath,'dir')
    mkdir(savePath);
end
savefile=([savePath,'\',year,'RectSpace.mat']);
if ~exist(savefile,'file')
    MaxDis=1000;
    starttime=EnNum(sim(1));endtime=EnNum(sim(2));
    RectSpace(:,:,1)=dataEnImg(:,:,sim(1));
    for ti=starttime:endtime
        %在每个时间节点，对矩形进行驱动
        for lat=1:size(RectSpace,1)
            for lon=1:size(RectSpace,2)
                %选择矩形进行驱动
                if RectSpace(lat,lon,ti-starttime+1)~=0
                    %更新位置之后不得再使用lat，lon
                    latnew=lat;
                    lonnew=lon;
                    %设置初始时间长度
                    resttimeN=24*60*60;
                    resttimeE=24*60*60;
                    %创建latnew，lonnew记录
                    latnewtemp=zeros(MaxDis,1);
                    lonnewtemp=zeros(MaxDis,1);
                    latnewtemp(1)=latnew;
                    lonnewtemp(1)=lonnew;
                    %进行驱动
                    for step=1:MaxDis
                        %如果浒苔粒子进入陆地或者超出范围，则停止驱动
                        if lonnew>=size(dataNwave,2)||lonnew<=1||latnew>=size(dataNwave,1)||latnew<=1
                            break
                        elseif (isnan(dataNwave(latnew,lonnew,ti)))||(isnan(dataEwave(latnew,lonnew,ti)))
                            break
                        else%否则继续驱动
                            %更新速度
                            speNwave=dataNwave(latnew,lonnew,ti);
                            speEwave=dataEwave(latnew,lonnew,ti);
                            speNwind=0.05*dataNwind(latnew,lonnew,ti);
                            speEwind=0.05*dataEwind(latnew,lonnew,ti);
                            
                            AspeN=(speNwave+speNwind)/2;
                            %如果风速为东向，则风速乘以增加系数
                            if speEwind>0
                                AspeE=(speEwave+speEwind*2)/2;
                            else
                                AspeE=(speEwave+speEwind)/2;
                            end
                            if rand(1)<0.3%有50%的概率改变速度的大小
                                if AspeN>0
                                    AspeN= (2.5+rand(1))*AspeN;
                                else
                                    AspeN= (3-rand(1))*AspeN;
                                end
                                
                                %如果速度东向，则速度增加2.5~3.5倍
                                if AspeE>0
                                    AspeE= (2.5+rand(1))*AspeE;
                                else
                                    %如果速度西向，则有50%的概率在1~2之间变化，50%的概率2~3之间变化
                                    if rand(1)<0.4
                                        AspeE= (2.5-rand(1))*AspeE;
                                    else
                                        AspeE= (1.5-rand(1))*AspeE;
                                    end
                                end
                            end
                            
                            %判断粒子能否离开该栅格
                            resttimeN=resttimeN-500/abs(AspeN);
                            resttimeE=resttimeE-500/abs(AspeE);
                            %如果北向、东向剩余时间均小于零，说明粒子无法离开该栅格，则结束一天的漂移
                            if resttimeN<0&&resttimeE<0
                                break
                            elseif resttimeN>0&&resttimeE<0
                                if AspeN>0
                                    latnew=latnew-1;
                                else
                                    latnew=latnew+1;
                                end
                                latnewtemp(step+1)=latnew;
                                
                            elseif resttimeN<0&&resttimeE>0%如果北向不可离开，东向可以离开
                                if  AspeE>0%如果东向速度为正，说明粒子向右移动，即lon值增加
                                    lonnew=lonnew+1;
                                else
                                    lonnew=lonnew-1;
                                end
                                lonnewtemp(step+1)=lonnew;
                                
                            elseif resttimeN>0&&resttimeE>0%如果东向，北向均可以离开
                                if AspeN>0%如果北向速度为正，说明粒子向上移动，即lat值减小
                                    latnew=latnew-1;
                                else%否则lat值加一
                                    latnew=latnew+1;
                                end
                                latnewtemp(step+1)=latnew;
                                if  AspeE>0%如果东向速度为正，说明粒子向右移动，即lon值增加
                                    lonnew=lonnew+1;
                                else
                                    lonnew=lonnew-1;
                                end
                                lonnewtemp(step+1)=lonnew;
                                
                            end
                        end
                    end
                    %完成一天的驱动之后，更新ti+1时刻的RectSpace
                    %寻找更新记录中的非零值的最后一个
                    lattemp=latnewtemp(latnewtemp>0);
                    lontemp=lonnewtemp(lonnewtemp>0);
                    RectSpace(lattemp(end),lontemp(end),ti-starttime+2)=1;
                end
            end
        end
    end
    save(savefile,'RectSpace');
end