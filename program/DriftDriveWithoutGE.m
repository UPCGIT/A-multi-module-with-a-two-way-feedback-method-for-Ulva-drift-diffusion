function [savefile1,savefile2]=DriftDriveWithoutGE(saverect2path,dataNwave,dataEwave,dataNwind,dataEwind,sim,EnNum,year,wc,gi,results_dir)
savePath=([results_dir,'\DDBFMResult2']);
if ~exist(savePath,'dir')
    mkdir(savePath);
end
savefile1=([savePath,'\',year,'RectSpace.mat']);
savefile2=([savePath,'\',year,'ObjectTrajectory.mat']);
if  (~exist(savefile1,'file')) || (~exist(savefile2,'file'))
    rect2dataPath=([saverect2path,'\',year,'_A_RECTdata_',num2str(sim(1))]);
    RECT=load(rect2dataPath);RECT=RECT.RECT;
    MaxDis=1000;
    starttime=EnNum(sim(1));endtime=EnNum(sim(2));
    RectSpace=zeros(size(dataEwind,1),size(dataEwind,2),endtime-starttime+2,4);
    RectSpace(:,:,1,1:3)=RECT(:,:,1:3);
    RectSpace(:,:,1,4)=0;
    driftnum=0;
    for lat =1:size(RectSpace,1)
        for lon=1:size(RectSpace,2)
            if RectSpace(lat,lon,1,2)>0
                driftnum=driftnum+1;
                RectSpace(lat,lon,1,5)=driftnum;
            end
        end
    end
    for ti=starttime:endtime
        ObjectTrajectory=zeros(driftnum,endtime-starttime+1,200,12);
        %run drift and drive module
        disp(['Drive is in progress on day ',num2str(ti-starttime+1)])
        tic
        [RectSpace,ObjectTrajectory]=DriftPartWithGE(RectSpace,ti,starttime,dataNwave,dataEwave,dataNwind,dataEwind,wc,MaxDis);
        toc
    end
    save(savefile1,'RectSpace');
    save(savefile2,'ObjectTrajectory');
end