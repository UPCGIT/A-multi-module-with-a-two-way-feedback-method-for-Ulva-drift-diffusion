function rectsimStatisticsplot(dataEnImg,saverect1path, saverect2path,year)
%统计矩形的数目、覆盖面积、重复率、遗漏率、虚警率
%........................................统计文件夹下文件的数目
namelist1=struct2cell(dir([saverect1path,'\','*.mat']));%获取文件夹下所有.mat格式的文件
namelist2=struct2cell(dir([saverect2path,'\','*.mat']));%获取文件夹下所有.mat格式的文件
[k,len]=size(namelist1);
%.........................................初始化统计矩阵
statistics=zeros(2,size(dataEnImg,3),5);
%.........................................遍历数据填充初始化统计矩阵
for i=1:size(dataEnImg,3)
    %........................................生成存储文件名
    dataEnImgtemp=dataEnImg(:,:,i);
    for ii=1:len
        name=namelist1{1,ii};%获取文件名
        if name(1:4)==year & name(end-4)==num2str(i)
             path=[saverect1path,'\',name];%组合文件路径和文件名
        end
    end
    %.........................................读取矩形数据
    RECT=load(path);RECT=RECT.RECT;
    statistics(1,i,1)=length(find(RECT(:,:,2)>0));%统计矩形的数目1
        rectdata=zeros(size(RECT,1),size(RECT,2));%初始化矩形矩阵存储
    %........................................矩形数据矩阵化
    for ii=1:size(RECT,1)
        for jj=1:size(RECT,2)
            L=RECT(ii,jj,2);
            d=RECT(ii,jj,3);
            thete=RECT(ii,jj,1);
            latCenter=ii;
            lonCenter=jj;
            [xplot,yplot]=rect(latCenter,lonCenter,thete,L,d);%生成矩形
            %...........................寻找位于该矩形下的点
            for iii=ii-(L+d):ii+(L+d)
                for jjj=jj-(L+d):jj+(L+d)
                    if iii<=size(dataEnImg,1) && jjj<size(dataEnImg,2)
                        f=fact(iii,jjj,thete,xplot,yplot);
                        if f==1
                            rectdata(iii,jjj)=1;
                        end
                    end
                end
            end
        end
    end
    statistics(1,i,2)=length(find(rectdata>0))*500*500/1000000;%统计矩形的覆盖面积
    statistics(1,i,3)=length(find(rectdata>0 & dataEnImgtemp>0))/length(find( (rectdata>0)|(dataEnImgtemp>0)   ));%统计重复率
    statistics(1,i,4)=length( find( (rectdata==0)&(dataEnImgtemp>0) ) )/length(find( (rectdata>0)|(dataEnImgtemp>0)   ));%统计遗漏率
    statistics(1,i,5)=(length( find(  (rectdata>0)&(dataEnImgtemp==0) )  ) )/length(find( (rectdata>0)|(dataEnImgtemp>0)   ));%统计虚警率
    
    for ii=1:len
        name=namelist2{1,ii};%获取文件名
        if name(1:4)==year & name(end-4)==num2str(i)
             path=[saverect2path,'\',name];%组合文件路径和文件名
        end
    end
    %.........................................读取矩形数据
    RECT=load(path);RECT=RECT.RECT;
    statistics(2,i,1)=length(find(RECT(:,:,2)>0));%统计矩形的数目2
    rectdata=zeros(size(RECT,1),size(RECT,2));%初始化矩形矩阵存储
    %........................................矩形数据矩阵化
    for ii=1:size(RECT,1)
        for jj=1:size(RECT,2)
            L=RECT(ii,jj,2);
            d=RECT(ii,jj,3);
            thete=RECT(ii,jj,1);
            latCenter=ii;
            lonCenter=jj;
            [xplot,yplot]=rect(latCenter,lonCenter,thete,L,d);%生成矩形
            %...........................寻找位于该矩形下的点
            for iii=ii-(L+d):ii+(L+d)
                for jjj=jj-(L+d):jj+(L+d)
                    if iii<=size(dataEnImg,1) && jjj<size(dataEnImg,2)
                        f=fact(iii,jjj,thete,xplot,yplot);
                        if f==1
                            rectdata(iii,jjj)=1;
                        end
                    end
                end
            end
        end
    end
   
    statistics(2,i,2)=length(find(rectdata>0))*500*500/1000000;%统计矩形的覆盖面积
    statistics(2,i,3)=length(find(rectdata>0 & dataEnImgtemp>0))/length(find( (rectdata>0)|(dataEnImgtemp>0)   ));%统计重复率
    statistics(2,i,4)=length( find( (rectdata==0)&(dataEnImgtemp>0) ) )/length(find((dataEnImgtemp>0)   ));%统计遗漏率
    statistics(2,i,5)=(length( find(  (rectdata>0)&(dataEnImgtemp==0) )  ) )/length(find( (rectdata>0)   ));%统计虚警率
    %.................................绘制条形图
    %     disp(statistics(1,:,:)*100)
    %     disp(statistics(2,:,:)*100)
end
% figure
% statisticsplot=statistics(1,:,3:5)*100;
% statisticsplot=reshape(statisticsplot,[size(statisticsplot,2),size(statisticsplot,3)]);
% bar(statisticsplot)
% figure
% statisticsplot=statistics(2,:,3:5)*100;
% statisticsplot=reshape(statisticsplot,[size(statisticsplot,2),size(statisticsplot,3)]);
% bar(statisticsplot)
% % disp(roundn(statistics(1,:,3:5)*100,-2))
% disp('重复率、遗漏率、虚警率为：')
% disp(roundn(statistics(2,:,3:5)*100,-2))
P=cell(4,size(dataEnImg,3)+1);
P(2,1)={'Repetition rate'};
P(3,1)={'Omission rate'};
P(4,1)={'False alarm rate'};
for i=1:4
    for j=2:size(dataEnImg,3)+1
        if i==1
            P(i,j)={[year,'_',num2str(j-1)]};
        else
            P(i,j)={roundn(statistics(2,j-1,i+1)*100,-2)};
        end
    end
end
savePath=(['results']);
if ~exist(savePath,'dir')
    mkdir(savePath);
end
savefilexlsx=([savePath,'\','PrecisionStatistics0.xlsx']);
savesheet=year;
writecell(P,savefilexlsx,'Sheet',savesheet);
end

