function VS(GLTlat, GLTlon, Map, shp1path, shp2path, shpPixel3path, shptruepath, shpPixelstruepath, EnNum, sim, year, RECT1, RECT2, RECTtrue, Pixels, waveLinepath, GOCITIFF, dataEnImg, loc,results_dir)

filepath = sort_GOCI(GOCITIFF, year); % GOCI影像处理年份的数据按照日期进行排序

savePath = ([results_dir,'\VS']);
if ~exist(savePath, 'dir')
    mkdir(savePath);
end
savefilexlsx = ([savePath, '\', 'PrecisionStatistics.xlsx']);
plotnum = linspace(sim(1), sim(2), sim(2)-sim(1)+1);
P = cell(4, length(plotnum)*3+1);
for i = 2:length(plotnum) * 3 + 1
    if mod(i, 3) == 2
        P(1, i) = {'Coincident part/Remote sensing monitoring'};
    elseif mod(i, 3) == 0
        P(1, i) = {'Coincident part/Simulation result'};
    else
        P(1, i) = {'Coincidence rate'};
    end
end
P(2, 1) = {'Drift drive with GE'};
P(3, 1) = {'Drift drive without GE'};
P(4, 1) = {'Pixel-based simulation'};
for i = 1:length(plotnum)
    ti = EnNum(plotnum(i)) - EnNum(sim(1)) + 1;
    t = datetime(str2double(year), 05, 01);
    doy = day(t, 'dayofyear') - 1;
    doy = doy + EnNum(plotnum(i));
    Date = datestr(datetime(str2double(year), 1, doy));
    savefile = ([savePath, '\', Date, '_VS.tif']);
    savesheet = year;
    coincide1 = length(find((RECT1(:, :, ti) == 1) & (RECTtrue(:, :, i) == 1)));
    cr11 = coincide1 / length(find(RECT1(:, :, ti) == 1));
    cr12 = coincide1 / length(find(RECTtrue(:, :, i) == 1));
    cr13 = coincide1 / (length(find(RECT1(:, :, ti) == 1)) + length(find(RECTtrue(:, :, i) == 1)) - coincide1);
    coincide2 = length(find((RECT2(:, :, ti) == 1) & (RECTtrue(:, :, i) == 1)));
    cr21 = coincide2 / length(find(RECT2(:, :, ti) == 1));
    cr22 = coincide2 / length(find(RECTtrue(:, :, i) == 1));
    cr23 = coincide2 / (length(find(RECT2(:, :, ti) == 1)) + length(find(RECTtrue(:, :, i) == 1)) - coincide2);
    coincide3 = length(find((Pixels(:, :, ti) == 1) & (RECTtrue(:, :, i) == 1)));
    cr31 = coincide3 / length(find(Pixels(:, :, ti) == 1));
    cr32 = coincide3 / length(find(RECTtrue(:, :, i) == 1));
    cr33 = coincide3 / (length(find(Pixels(:, :, ti) == 1)) + length(find(RECTtrue(:, :, i) == 1)) - coincide3);
    P(2, (i - 1)*3+3) = {roundn(cr11*100, -2)};
    P(2, (i - 1)*3+2) = {roundn(cr12*100, -2)};
    P(2, (i - 1)*3+4) = {roundn(cr13*100, -2)};
    P(3, (i - 1)*3+3) = {roundn(cr21*100, -2)};
    P(3, (i - 1)*3+2) = {roundn(cr22*100, -2)};
    P(3, (i - 1)*3+4) = {roundn(cr23*100, -2)};
    P(4, (i - 1)*3+3) = {roundn(cr31*100, -2)};
    P(4, (i - 1)*3+2) = {roundn(cr32*100, -2)};
    P(4, (i - 1)*3+4) = {roundn(cr33*100, -2)};
    writecell(P, savefilexlsx, 'Sheet', savesheet);
    if ~exist(savefile, 'file')
        S1 = shaperead(shp1path(ti));
        S2 = shaperead(shp2path(ti));
        S3 = shaperead(shpPixel3path(ti));
        Strue4 = shaperead(shptruepath(i));
        Strue5 = shaperead(shpPixelstruepath(plotnum(i)));
        waveline = shaperead(waveLinepath);

        figure
        
        h = worldmap([min(min(GLTlat)) + 0.1, max(max(GLTlat)) - 0.1], [min(min(GLTlon)) + 0.1, max(max(GLTlon)) - 0.1]);
        path = filepath{1, plotnum(i)};
        En = dataEnImg(:, :, plotnum(i));
        rgbGOCI = getRGBGOCI(path, En, loc);
        pcolorm(GLTlat, GLTlon, rgbGOCI);
        alpha(0.9)
        hold on

        % pcolorm(GLTlat,GLTlon,cat(3,RECT1(:,:,end-1),RECT2(:,:,end-1),RECTtrue(:,:,end)));
        GID = {Map(:).GID_1};
        Lon = {Map(:).X};
        Lat = {Map(:).Y};
        loction = {Map(:).BoundingBox};
        name = {Map(:).NAME_2};
        for ii = 1:length(Map)
            if strcmp(GID(ii), 'CHN.23_1') == 1 || strcmp(GID(ii), 'CHN.15_1') == 1
                lonPlot = Lon(ii);
                lonPlot2 = cell2mat(lonPlot);
                latPlot = Lat(ii);
                latPlot2 = cell2mat(latPlot);
                geoshow(latPlot2, lonPlot2, 'Color', 'black', 'LineWidth', 0.5)
                namePlot = cell2mat(name(ii));
                loction2 = cell2mat(loction(ii));
                if loction2(1, 2) < min(min(GLTlat))
                    loction2(1, 2) = min(min(GLTlat));
                end
                if loction2(2, 2) > max(max(GLTlat))
                    loction2(2, 2) = max(max(GLTlat));
                end
                %                 if loction2(1,1)<min(min(GLTlon))
                %                     loction2(1,1)=min(min(GLTlon));
                %                 end
                %                 if loction2(2,1)>max(max(GLTlon))
                %                     loction2(2,1)=max(max(GLTlon));
                %                 end
                textm((loction2(1, 2) + loction2(2, 2))/2, (loction2(1, 1) + loction2(2, 1))/2, namePlot, 'Fontname', 'Times New Roman');
            end
        end
        
        c4 = geoshow([S3.X], [S3.Y], 'Color', 'm', 'LineWidth', 0.5); %绘制轮廓线
        c1 = geoshow([S1.X], [S1.Y], 'Color', 'r', 'LineWidth', 1); %绘制轮廓线
        c2 = geoshow([S2.X], [S2.Y], 'Color', 'b', 'LineWidth', 1); %绘制轮廓线
        %         c3=geoshow([Strue4.X],[Strue4.Y], 'Color','b');  %绘制轮廓线

        c5 = geoshow([waveline.X], [waveline.Y], 'Color', 'y', 'LineStyle', '-', 'LineWidth', 2); %绘制轮廓线
        %     geoshow([Strue5.X],[Strue5.Y], 'Color','y');  %绘制轮廓线
        Y = [1, 2];
        a = area(Y);
        a.FaceColor = [0, 1, 0];
        title([Date, ' Distribution map of Enteromorpha'], 'fontsize', 12, 'Fontname', 'Times New Roman')
        legend([c1, c2, a, c4, c5], 'MTF-DD', 'MTF-D', 'The true distribution of green tide', 'Traditional method', 'Drive data boundaries','Fontname', 'Times New Roman', 'Location', 'South');
        print(gcf, savefile, '-dpng', '-r330');
        close
    end
end
