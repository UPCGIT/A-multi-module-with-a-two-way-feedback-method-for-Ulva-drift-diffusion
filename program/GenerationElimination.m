function RectSpace=GenerationElimination(RectSpace,ti,starttime,dataNwave,dataEwave,dataNwind,dataEwind,TempteratureIndex,wc,gi,speNtempMax,speEtempMax)

for lat=1:size(RectSpace,1)
    for lon=1:size(RectSpace,2)
        %control the growth interval
        if RectSpace(lat,lon,ti-starttime+1,4)==gi
            RectSpace(lat,lon,ti-starttime+1,4)=1;
        elseif RectSpace(lat,lon,ti-starttime+1,4)==1
            RectSpace(lat,lon,ti-starttime+1,4)=0;
        end
        %control the location and size of simulation objects
        if  RectSpace(lat,lon,ti-starttime+1,4)==0&&RectSpace(lat,lon,ti-starttime+1,2)~=0&&RectSpace(lat,lon,ti-starttime+1,2)>2
            %Determine the speed direction of the rectangular movement
            speNwavetemp=0;
            speEwavetemp=0;
            speNwindtemp=0;
            speEwindtemp=0;
            temperatureIndexNet=0;
            speNtemp=0;
            speEtemp=0;
            thete=RectSpace(lat,lon,ti-starttime+1,1);
            L=RectSpace(lat,lon,ti-starttime+1,2);
            d=RectSpace(lat,lon,ti-starttime+1,3);
            [xplot,yplot]=rect( lat, lon,thete,L,d);
            spenum=0;
            for i=lat-50:lat+50
                for j=lon-50:lon+50
                    if j<size(dataEwave,2)&&j>1&&i<size(dataEwave,1)&&i>1
                        if isnan(dataEwave(i,j,ti))==0
                            %Determine whether the point is within the rectangle
                            f=fact(i,j,thete,xplot,yplot);
                            if f==1%if the point is within the rectangle
                                speNwavetemp=speNwavetemp+dataNwave(i,j,ti);
                                speEwavetemp=speEwavetemp+dataEwave(i,j,ti);
                                speNwindtemp=speNwindtemp+wc*dataNwind(i,j,ti);
                                speEwindtemp=speEwindtemp+wc*dataEwind(i,j,ti);
                                temperatureIndexNet=temperatureIndexNet+TempteratureIndex(i,j,ti);
                                spenum=spenum+1;
                            end
                        end
                    end
                end
            end
            temperatureIndexNet=temperatureIndexNet/spenum;
            %Determine whether to generate a new object
            if  temperatureIndexNet>0
                if rand(1)<temperatureIndexNet/2
                    theteReplace=randi([0,90]);
                    LRect=rand(1)*1.5*L;
                    dRect=rand(1)*1.5*d;
                    speNtemp=   (speNwavetemp+ speNwindtemp)/2/spenum;
                    speEtemp=    (speEwavetemp+speEwindtemp)/2/spenum;
                    if speNtemp>0
                        latADD=-round(abs(speNtemp)/speNtempMax*10);
                    else
                        latADD=round(abs(speNtemp)/speNtempMax)*10;
                    end
                    if speEtemp>0
                        lonADD=round(abs(speEtemp)/speEtempMax)*10;
                    else
                        lonADD=-round(abs(speEtemp)/speEtempMax)*10;
                    end
                    if lat+latADD>0&&lat+latADD<size(RectSpace,1)&&lon+lonADD>0&&lon+lonADD<size(RectSpace,2)&&lon+LRect<size(RectSpace,2)-50&&lat+LRect<size(RectSpace,1)-50
                        %RectSpace(lat+latADD,lon+lonADD,ti-disNum(1)+1,2:3)=RectSpace(lat,lon,ti-disNum(1)+1,2:3);
                        RectSpace(lat+latADD,lon+lonADD,ti-starttime+1,2:3)=[LRect,dRect];
                        RectSpace(lat+latADD,lon+lonADD,ti-starttime+1,1)=theteReplace;
                        RectSpace(lat+latADD,lon+lonADD,ti-starttime+1,4)=gi;
                    end
                end
                %Enteromorpha objects die randomly
                if rand(1)<temperatureIndexNet/4
                    RectSpace(lat,lon,ti-starttime+1,2:3)=[0,0];
                    RectSpace(lat,lon,ti-starttime+1,1)=0;
                    RectSpace(lat,lon,ti-starttime+1,4)=0;
                end
            else%If the net growth rate is less than zero, die
                if rand(1)<abs(temperatureIndexNet)
                    RectSpace(lat,lon,ti-starttime+1,2:3)=[0,0];
                    RectSpace(lat,lon,ti-starttime+1,1)=0;
                    RectSpace(lat,lon,ti-starttime+1,4)=0;
                else%Shrink the object
                    LRect=RectSpace(lat,lon,ti-starttime+1,2)*(1-abs(temperatureIndexNet));
                    dRect=RectSpace(lat,lon,ti-starttime+1,3)*(1-abs(temperatureIndexNet));
                    RectSpace(lat,lon,ti-starttime+1,2:3)=[LRect,dRect];
                end
            end
            
        end
        
    end
end




