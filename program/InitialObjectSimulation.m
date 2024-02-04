function saverect2path=InitialObjectSimulation(simrect,saveMainPath,dataEnImg,rectnum,...
    rectsize,rectdensity,rectrepetition,land,year)
for runcount=1:length(simrect)
    %generate the initial simualtion
    [saverect1datanum,saverect1path]=GenerateInitialSimulation(simrect,saveMainPath,dataEnImg,rectnum,rectsize,rectdensity,runcount,land,year);
    %adjust the initial state
    saverect2path=AdjustInitialState(saverect1datanum,simrect,saveMainPath,dataEnImg,rectsize,rectrepetition,runcount,land,year);
end
rectsimStatisticsplot(dataEnImg,saverect1path, saverect2path,year);