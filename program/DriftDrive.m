function [savefile]=DriftDrive(saverect2path,dataNwave,dataEwave,dataNwind,dataEwind,TempteratureIndex,sim,EnNum,year,wc,gi, results_dir)
savePath=([results_dir,'\DDBFMResult1']);
if ~exist(savePath,'dir')
    mkdir(savePath);
end
savefile=([savePath,'\',year,'RectSpace.mat']);
rect2dataPath=([saverect2path,'\',year,'_A_RECTdata_',num2str(sim(1))]);
if ~exist(savefile,'file')
    RECT=load(rect2dataPath);RECT=RECT.RECT;
    MaxDis=1000;
    starttime=EnNum(sim(1));endtime=EnNum(sim(2));
    RectSpace=zeros(size(dataEwind,1),size(dataEwind,2),endtime-starttime+2,4);
    RectSpace(:,:,1,1:3)=RECT(:,:,1:3);
    RectSpace(:,:,1,4)=0;
    for ti=starttime:endtime
        %Count the maximum speed at the current moment
        [speNtempMax,speEtempMax]=CountMaxSpeed(ti,dataNwave,dataEwave,wc,dataNwind,dataEwind);
        % run generation and elimination module
        RectSpace=GenerationElimination(RectSpace,ti,starttime,dataNwave,dataEwave,dataNwind,dataEwind,TempteratureIndex,wc,gi,speNtempMax,speEtempMax);
        %run drift and drive module
        disp(['Drive is in progress on day ',num2str(ti-starttime+1)])
        tic
        RectSpace=DriftPart(RectSpace,ti,starttime,dataNwave,dataEwave,dataNwind,dataEwind,wc,MaxDis);
        toc
    end
    save(savefile,'RectSpace');
end
