function [saverect1datanum,saverec1tpath]=GenerateInitialSimulation(simrect,saveMainPath,dataEnImg,rectnum,rectsize,rectdensity,runcount,land,year)

namecount=simrect(runcount);
saverec1tpath=[saveMainPath,'\','GenerateInitialSimulation'];
saverect1data=[saverec1tpath,'\',year,'_'];
saverect1datanum=[saverect1data,'G_RECTdata_',num2str(namecount),'.mat'];
if ~exist(saverec1tpath,'dir')
    mkdir(saverec1tpath);
    if ~exist(saverect1datanum,'file')
        GIS(dataEnImg,rectnum,rectsize,rectdensity,saverect1datanum,namecount);
%         rectsimplot(dataEnImg,land,saverect1datanum,namecount);
    end
else
    if ~exist(saverect1datanum,'file')
        GIS(dataEnImg,rectnum,rectsize,rectdensity,saverect1datanum,namecount);
%         rectsimplot(dataEnImg,land,saverect1datanum,namecount);
    end
end
