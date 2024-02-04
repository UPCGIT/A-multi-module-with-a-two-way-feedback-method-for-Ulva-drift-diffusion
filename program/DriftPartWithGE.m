function [RectSpace,ObjectTrajectory]=DriftPartWithGE(RectSpace,ti,starttime,dataNwave,dataEwave,dataNwind,dataEwind,wc,MaxDis)

for lat=1:size(RectSpace,1)
    for lon=1:size(RectSpace,2)
        %选择矩形进行驱动
        if RectSpace(lat,lon,ti-starttime+1,2)~=0
            %更新位置之后不得再使用lat，lon
            latnew=lat;
            lonnew=lon;
            %更新矩形的参数
            thetenew=RectSpace(latnew,lonnew,ti-starttime+1,1);
            Lnew=RectSpace(latnew,lonnew,ti-starttime+1,2);
            dnew=RectSpace(latnew,lonnew,ti-starttime+1,3);
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
                elseif  (isnan(dataNwave(latnew,lonnew,ti)))||(isnan(dataEwave(latnew,lonnew,ti)))
                    break
                else%否则继续驱动
                    %更新速度
                    %以矩形中心作为漂移点，该点的速度由矩形范围内的所有速度的均值表示
                    %寻找该矩形涵盖的范围并获得速度值
                    %生成矩形
                    [xplot,yplot]=rect( latnew, lonnew,thetenew,Lnew,dnew);
                    speNwave=0;
                    speEwave=0;
                    speNwind=0;
                    speEwind=0;
                    speN=0;
                    speE=0;
                    spenum=0;
                    %根据矩形框的大小定义衰减系数，矩形框越大，衰减系数越大,该衰减系数仅针对海流
                    k1=1-(Lnew*dnew)/(50*50);
                    for i=latnew-50:latnew+50
                        %矩形的最大边长不超过100，因此以矩形中心为中点的200边长的正方形一定可以包含该矩形
                        for j=lonnew-50:lonnew+50
                            if j<size(dataNwave,2)&&j>1&&i<size(dataNwave,1)&&i>1
                                if isnan(dataNwave(i,j,ti))==0
                                    %判断该点是否位于矩形范围内
                                    f=fact(i,j,thetenew,xplot,yplot);
                                    if f==1%如果该点位于矩形内
                                        %则记录速度
                                        speNwave=speNwave+dataNwave(i,j,ti);
                                        speEwave=speEwave+dataEwave(i,j,ti);
                                        speNwind=speNwind+wc*dataNwind(i,j,ti);
                                        speEwind=speEwind+wc*dataEwind(i,j,ti);
                                        spenum=spenum+1;
                                    end
                                end
                            end
                        end
                    end
                    
                    
                    AspeN=(speNwave*k1+speNwind)/spenum/2;
                    if speEwind>0
                        windout=speEwind*2;
                        AspeE=(speEwave*k1+speEwind*2)/spenum/2;
                    else
                        windout=speEwind;
                        AspeE=(speEwave*k1+speEwind)/spenum/2;
                    end
                    if rand(1)<0.3
                        if AspeN>0
                            AspeN= (2.5+rand(1))*AspeN;
                        else
                            AspeN= (3-rand(1))*AspeN;
                        end
                        if AspeE>0
                            AspeE= (2.5+rand(1))*AspeE;
                        else
                            if rand(1)<0.4
                                AspeE= (2.5-rand(1))*AspeE;
                            else
                                AspeE= (1.5-rand(1))*AspeE;
                            end
                        end
                    end
                    %
                    
                    %每次漂移记录粒子参数
                    %（lat lon 流速*2 风速*2 改变之后的流速*2 改变之后的风速*2 浒苔速度*2）      先北后东
                    ObjectTrajectory(RectSpace(lat,lon,ti-starttime+1,5),ti-starttime+1,step,1:12)=...
                        [latnew,lonnew,speNwave/spenum,speEwave/spenum,speNwind/0.05/spenum,speEwind/0.05/spenum,speNwave*k1/spenum,speEwave*k1/spenum,speNwind/spenum,windout/spenum,AspeN,AspeE];
                    
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
            RectSpace(lattemp(end),lontemp(end),ti-starttime+2,1:3)=[thetenew,Lnew,dnew];
            RectSpace(lattemp(end),lontemp(end),ti-starttime+2,5)=RectSpace(lat,lon,ti-starttime+1,5);
        end
    end
end
