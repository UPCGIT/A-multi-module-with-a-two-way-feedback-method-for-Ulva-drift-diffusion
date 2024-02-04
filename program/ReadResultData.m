function [RECT1,RECT2,Pixels]=ReadResultData(savefile1,savefile2,savefile3)
RECT1=load(savefile1);RECT1=RECT1.RectSpace;
RECT2=load(savefile2);RECT2=RECT2.RectSpace;
Pixels=load(savefile3);Pixels=Pixels.RectSpace;

