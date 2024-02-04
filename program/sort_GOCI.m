function filepath=sort_GOCI(GOCITIFF,year)
namelist = struct2cell(dir([GOCITIFF, '\', '*.tif'])); % get all the tiff name in the filepath
[k, len] = size(namelist);
GOCIY = [];
GOCIM = [];
% 寻找某一年的数据索引
for i = 1:len
    name = namelist{1, i};
    name = strsplit(name, '.');
    name = strsplit(name{1}, '_');
    name = name{5};
    if strcmp(name(1:4), year) == 1
        GOCIY = [GOCIY, i];
        GOCIM = [GOCIM, floor(str2num(name(5:8)))];
    end
end
[~, GOCIM] = sort(GOCIM);
GOCIS = [];
filepath=cell(1,length(GOCIM));
for i = 1:length(GOCIM)
    GOCIS = [GOCIS, GOCIY(GOCIM(i))];
    name=[GOCITIFF,'\',namelist{1,GOCIS(i)}];
    filepath{1,i}=name;
end
