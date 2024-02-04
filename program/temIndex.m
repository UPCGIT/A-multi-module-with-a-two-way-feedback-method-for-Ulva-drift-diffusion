function temIndex(Temperature,savedata4path,Gmax,Dmax,T1,T2,T3,a1,a2,a3)
%..........................计算并存储温度影响因子
TempteratureG=zeros(size(Temperature));%生成温度影响因子存储矩阵
TempteratureD=zeros(size(Temperature));%生成温度影响因子存储矩阵
TempteratureIndex=zeros(size(Temperature));%初始化温度影响因子存储矩阵
for lat=1:size(Temperature,1)
    for lon=1:size(Temperature,2)
        for ti=1:size(Temperature,3)
            %计算生长速率
            if Temperature(lat,lon,ti)<T1
                TempteratureG(lat,lon,ti)=Gmax*a1^(Temperature(lat,lon,ti)-T1);
            elseif Temperature(lat,lon,ti)<T2
                TempteratureG(lat,lon,ti)=Gmax;
            else
                TempteratureG(lat,lon,ti)=Gmax*a2^(T2-Temperature(lat,lon,ti));
            end
            %计算死亡率
            if Temperature(lat,lon,ti)<T3
                TempteratureD(lat,lon,ti)=Dmax*a3^(Temperature(lat,lon,ti)-T3);
            else
                TempteratureD(lat,lon,ti)=Dmax;
            end
        end
    end
end
%..........................存储温度影响因子
savefile= savedata4path;
T=TempteratureIndex;
save(savefile,'T');
end

