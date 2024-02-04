function pixels=ConObjectstoPixels(object)
pixels=zeros(size(object,1),size(object,2),size(object,3));
for ti=1:size(object,3)
    for lat=1:size(object,1)
        for lon=1:size(object,2)
            if object(lat,lon,ti,2)~=0
                thete=object(lat,lon,ti,1);
                L=object(lat,lon,ti,2);
                d=object(lat,lon,ti,3);
                [xplot,yplot]=rect(lat,lon,thete,L,d);
                for i=lat-50:lat+50
                    for j=lon-50:lon+50
                        if j<size(object,2)&&j>1&&i<size(object,1)&&i>1
                            f=fact(i,j,thete,xplot,yplot);
                            if f==1
                                pixels(i,j,ti)=1;
                            end
                        end
                    end
                end
            end
        end
    end
end


