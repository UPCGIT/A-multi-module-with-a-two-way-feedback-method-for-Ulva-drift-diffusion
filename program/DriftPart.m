function RectSpace=DriftPart(RectSpace,ti,starttime,dataNwave,dataEwave,dataNwind,dataEwind,wc,MaxDis)

for lat=1:size(RectSpace,1)
    for lon=1:size(RectSpace,2)
        %If there is a non-stagnation object at this location, drift
        if ti-starttime>0
            if RectSpace(lat,lon,ti-starttime,2)~=0&&RectSpace(lat,lon,ti-starttime,4)>=3
                RectSpace(lat,lon,ti-starttime+1,1:3)=RectSpace(lat,lon,ti-starttime,1:3);
                RectSpace(lat,lon,ti-starttime+1,4)=RectSpace(lat,lon,ti-starttime,4)-1;%并在2*24小时之后进行漂移
            end
        end
        
        if RectSpace(lat,lon,ti-starttime+1,2)~=0&&RectSpace(lat,lon,ti-starttime+1,4)<3
            %Update location
            latnew=lat;
            lonnew=lon;
            %Update parameters
            thetenew=RectSpace(latnew,lonnew,ti-starttime+1,1);
            Lnew=RectSpace(latnew,lonnew,ti-starttime+1,2);
            dnew=RectSpace(latnew,lonnew,ti-starttime+1,3);
            %Get the label of the object
            gen=RectSpace(latnew,lonnew,ti-starttime+1,4);
            %Set the length of the simulation time
            resttimeN=24*60*60;
            resttimeE=24*60*60;
            %Create location record
            latnewtemp=zeros(MaxDis,1);
            lonnewtemp=zeros(MaxDis,1);
            latnewtemp(1)=latnew;
            lonnewtemp(1)=lonnew;
            %Run drive
            for step=1:MaxDis
                %If the simulation object is beyond the scope of study, stop driving
                if lonnew>=size(dataNwave,2)||lonnew<=1||latnew>=size(dataNwave,1)||latnew<=1
                    break
                elseif  (isnan(dataNwave(latnew,lonnew,ti)))||(isnan(dataEwave(latnew,lonnew,ti)))
                    break
                else%Otherwise, continue to drive
                    [xplot,yplot]=rect( latnew, lonnew,thetenew,Lnew,dnew);
                    speNwave=0;
                    speEwave=0;
                    speNwind=0;
                    speEwind=0;
                    spenum=0;
                    %The velocity attenuation coefficient is defined according to the size of the object, the larger the object, the greater the attenuation coefficient (current)
                    k1=1-(Lnew*dnew)/(50*50);
                    for i=latnew-50:latnew+50
                        for j=lonnew-50:lonnew+50
                            if j<size(dataNwave,2)&&j>1&&i<size(dataNwave,1)&&i>1
                                if isnan(dataNwave(i,j,ti))==0
                                    f=fact(i,j,thetenew,xplot,yplot);
                                    if f==1
                                        speNwave=speNwave+dataNwave(i,j,ti);
                                        speEwave=speEwave+dataEwave(i,j,ti);
                                        speNwind=speNwind+wc*dataNwind(i,j,ti);
                                        speEwind=speEwind+wc*dataEwind(i,j,ti);
                                        spenum=spenum+1;
                                    end
                                end
                            end
                        end
                    end
                    %Parent object velocity perturbation
                    if gen==0
                        %Get the average speed of the object
                        AspeN=(speNwave*k1+speNwind)/spenum/2;
                        if speEwind>0
                            AspeE=(speEwave*k1+speEwind*2)/spenum/2;
                        else
                            AspeE=(speEwave*k1+speEwind)/spenum/2;
                        end
                        if rand(1)<0.3
                            if AspeN>0
                                AspeN= (2.5+rand(1))*AspeN;
                            else
                                AspeN= (2+rand(1))*AspeN;
                            end
                            if AspeE>0
                                AspeE= (2.5+rand(1))*AspeE;
                            else
                                if rand(1)<0.4
                                    AspeE= (2.5-rand(1))*AspeE;
                                else
                                    AspeE= (1.5-rand(1))*AspeE;
                                end
                            end
                        end
                    else
                        AspeN=(speNwave+speNwind)/spenum/2;
                        if speEwind>0
                            AspeE=(speEwave+speEwind*2)/spenum/2;
                        else
                            AspeE=(speEwave+speEwind)/spenum/2;
                        end
                        if AspeN>0
                            AspeN= (2.5+rand(1))*AspeN;
                        else
                            AspeN= (3-rand(1))*AspeN;
                        end
                        if rand(1)<0.3
                            if AspeE>0
                                AspeE= (3+rand(1))*AspeE;
                            else
                                if rand(1)<0.5
                                    AspeE= (3+rand(1))*AspeE;
                                else
                                    AspeE= (2+rand(1))*AspeE;
                                end
                            end
                        end
                    end
                    %Determine whether particles can leave the grid
                    resttimeN=resttimeN-500/abs(AspeN);
                    resttimeE=resttimeE-500/abs(AspeE);
                    if resttimeN<0&&resttimeE<0
                        break
                    elseif resttimeN>0&&resttimeE<0
                        if AspeN>0
                            latnew=latnew-1;
                        else
                            latnew=latnew+1;
                        end
                        latnewtemp(step+1)=latnew;
                    elseif resttimeN<0&&resttimeE>0
                        if  AspeE>0
                            lonnew=lonnew+1;
                        else
                            lonnew=lonnew-1;
                        end
                        lonnewtemp(step+1)=lonnew;
                    elseif resttimeN>0&&resttimeE>0
                        if AspeN>0
                            latnew=latnew-1;
                        else
                            latnew=latnew+1;
                        end
                        latnewtemp(step+1)=latnew;
                        if  AspeE>0
                            lonnew=lonnew+1;
                        else
                            lonnew=lonnew-1;
                        end
                        lonnewtemp(step+1)=lonnew;
                        
                    end
                end
            end
            %Update object
            lattemp=latnewtemp(latnewtemp>0);
            lontemp=lonnewtemp(lonnewtemp>0);
            if rand(1)<0.1&&RectSpace(lattemp(end),lontemp(end),ti-starttime+2,4)==0
                RectSpace(lattemp(1),lontemp(1),ti-starttime+2,1:3)=[thetenew,Lnew,dnew];
                RectSpace(lattemp(1),lontemp(1),ti-starttime+2,4)=4;
            else
                RectSpace(lattemp(end),lontemp(end),ti-starttime+2,1:3)=[thetenew,Lnew,dnew];
            end
        end
    end
end

