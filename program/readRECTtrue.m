function RECTtrue=readRECTtrue(saverect2path,sim,year)
namelist=struct2cell(dir([saverect2path,'\','*.mat']));%get all the file names in the .mat format under the folder
[~,len]=size(namelist);
Index=linspace(sim(1),sim(2),sim(2)-sim(1)+1);
for i=1:len
    name=namelist{1,i};
    if name(1:4)==year
        path=[saverect2path,'\',name];
        RECT=load(path);RECT=RECT.RECT;
        RECTtrue=zeros(size(RECT,1),size(RECT,2),length(Index),3);
        break
    end
end
for i=1:length(Index)
    for ii=1:len
        name=namelist{1,ii};
        if (name(end-4)==num2str(Index(i)))&(name(1:4)==year)
            path=[saverect2path,'\',name];
            RECT=load(path);RECT=RECT.RECT;
            RECTtrue(:,:,i,:)=RECT(:,:,1:3);
        end
    end
end