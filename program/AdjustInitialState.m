function saverect2path=AdjustInitialState(saverect1datanum,simrect,saveMainPath,dataEnImg,rectsize,rectrepetition,runcount,land,year)
namecount=simrect(runcount);
saverect2path=[saveMainPath,'\','AdjustInitialState'];
saverect2data=[saverect2path,'\',year,'_'];
saverect2datanum=[saverect2data,'A_RECTdata_',num2str(namecount),'.mat'];
if ~exist(saverect2path,'dir')
    mkdir(saverect2path);
    if ~exist(saverect2datanum,'file') 
        AIS(saverect1datanum,dataEnImg,rectsize,rectrepetition,namecount,saverect2datanum);
%         rectsimplot(dataEnImg,land,saverect2datanum,namecount);
    end
else
    if ~exist(saverect2datanum,'file')
        AIS(saverect1datanum,dataEnImg,rectsize,rectrepetition,namecount,saverect2datanum);
%         rectsimplot(dataEnImg,land,saverect2datanum,namecount);
    end
end
%   rectsimplot(dataEnImg,land,saverect2datanum,namecount);