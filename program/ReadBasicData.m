function [dataEnImg,EnNum,dataNwave,dataEwave,dataNwind,dataEwind,Temperature,...
     GLTlon,GLTlat,land,DEMPlot,DEMlat,DEMlon,Map]=...
     ReadBasicData(DEMPath,DEMlatPath,DEMlonPath,shpPath,EnteromorphaDir,...
     OceanCurrentDir,WindDir,TemperatureDir,GLTFile,landMask,...
     year,loc,timeloc)
 % read the binary graph of green tide dirtribution
namelist=struct2cell(dir([EnteromorphaDir,'\','*.mat']));%get all the file names in the .mat format under the folder
[k,len]=size(namelist);
for i=1:len
    name=namelist{1,i};
    if name(1:4)==year
        EnDate=strsplit(name(1:end-4),'_');%time to record green tide images
        path=[EnteromorphaDir,'\',name];
        EnImg=load(path);
    end
end
clear namelist k len name
for i=2:length(EnDate)%year, month and day are converted to accumulated days
    md=cell2mat(EnDate(i));
    ymd(i-1)=datetime(str2num(cell2mat(EnDate(1))), str2num(md(1:2)),  str2num(md(3:4)));
    doy(i-1)=day(ymd(i-1),'dayofyear');
end
startdate=datetime(str2num(cell2mat(EnDate(1))),05,01);
startdoy=day(startdate,'dayofyear');
EnNum=doy-startdoy+1;
dataEnImg=EnImg.imgOut(loc(1):loc(2),loc(3):loc(4),:);
clear  EnImg
% read ocean current data
namelist=struct2cell(dir([OceanCurrentDir,'\','*.mat']));
[k,len]=size(namelist);
for i=1:len
    name=namelist{1,i};
    if name(1:4)==year & name(6)=='V'
        path=[OceanCurrentDir,'\',name];
        OCN=load(path);
        dataNwave=OCN.imgOut_V(loc(1):loc(2),loc(3):loc(4),timeloc(1):timeloc(2));
        clear  OCN
    end
    if name(1:4)==year & name(6)=='U'
        path=[OceanCurrentDir,'\',name]; 
        OCE=load(path);
        dataEwave=OCE.imgOut_U(loc(1):loc(2),loc(3):loc(4),timeloc(1):timeloc(2));
        clear  OCE
    end
end
clear namelist k len name
% read the wind field data on the ocean surface
namelist=struct2cell(dir([WindDir,'\','*.mat']));
[k,len]=size(namelist);
for i=1:len
    name=namelist{1,i};
    if name(1:4)==year & name(6)=='V'
        path=[WindDir,'\',name];
        WindN=load(path);
        dataNwind=WindN.imgOut_V(loc(1):loc(2),loc(3):loc(4),timeloc(1):timeloc(2));
        clear  WindN
    end
    if name(1:4)==year & name(6)=='U'
        path=[WindDir,'\',name];
        WindE=load(path);
        dataEwind=WindE.imgOut_U(loc(1):loc(2),loc(3):loc(4),timeloc(1):timeloc(2));
        clear  WindE
    end
end
clear namelist k len name
% read ocean surface temperature data
namelist=struct2cell(dir([TemperatureDir,'\','*.mat']));
[k,len]=size(namelist);
for i=1:len
    name=namelist{1,i};
    if name(1:4)==year
        path=[TemperatureDir,'\',name];
        Temperature=load(path);
        Temperature=Temperature.imgOut_T(loc(1):loc(2),loc(3):loc(4),timeloc(1):timeloc(2));
    end
end
% read longitude and latitude coordinate data
GLT=load(GLTFile);
GLTlonTemp=GLT.LonLat(:,:,2);
GLTlon=GLTlonTemp(loc(1):loc(2),loc(3):loc(4));
clear GLTlonTemp
GLTlatTemp=GLT.LonLat(:,:,1);
GLTlat=GLTlatTemp(loc(1):loc(2),loc(3):loc(4));
clear GLT  GLTlatTemp
% read land mask data
landTemp=imread(landMask);
land=landTemp(loc(1):loc(2),loc(3):loc(4));
% read digital surface elevation data
DEMPlot=imread(DEMPath);
DEMPlot=double(DEMPlot);
DEMlat=load(DEMlatPath);
DEMlat=DEMlat.lat;
DEMlon=load(DEMlonPath);
DEMlon=DEMlon.lon;
% read administrative division data
Map=shaperead(shpPath);
 
 