function TempteratureIndex=CalculateNetGrowthRate(Gmax,Dmax,T1,T2,T3,a1,a2,a3,Temperature)
TempteratureG=zeros(size(Temperature));
TempteratureD=zeros(size(Temperature));
TempteratureIndex=zeros(size(Temperature));
for lat=1:size(Temperature,1)
    for lon=1:size(Temperature,2)
        for ti=1:size(Temperature,3)
            if Temperature(lat,lon,ti)<T1
                TempteratureG(lat,lon,ti)=Gmax*a1^(Temperature(lat,lon,ti)-T1);
            elseif Temperature(lat,lon,ti)<T2
                TempteratureG(lat,lon,ti)=Gmax;
            else
                TempteratureG(lat,lon,ti)=Gmax*a2^(T2-Temperature(lat,lon,ti));
            end
            if Temperature(lat,lon,ti)<T3
                TempteratureD(lat,lon,ti)=Dmax*a3^(Temperature(lat,lon,ti)-T3);
            else
                TempteratureD(lat,lon,ti)=Dmax;
            end
        end
    end
end
TempteratureIndex=TempteratureG-TempteratureD;



