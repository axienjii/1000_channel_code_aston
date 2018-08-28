function draw_rf_letters(instanceInd,channelInd,newFig)
%Written by Xing 7/7/17. Take instance and channel number, and plot RF
%location relative to letter stimuli.
load(['D:\data\best_260617-280617\RFs_instance',num2str(instanceInd),'.mat']);
allLetters='IUALTVSYJP';
screenWidth=1024;
screenHeight=768;
sampleSize=112;%a multiple of 14, the number of divisions in the letters
visualWidth=sampleSize;%in pixels
visualHeight=visualWidth;%in pixels
Par.PixPerDeg=25.860053410707074;

if newFig==1
    figure;
end
hold on
topLeft=1;%distance from fixation spot to top-left corner of sample, measured diagonally (eccentricity)
sampleX = round(sqrt((topLeft^2)/2)*Par.PixPerDeg);%randi([30 100]);%location of sample stimulus, in RF quadrant 150 230%want to try 20
sampleY = round(sqrt((topLeft^2)/2)*Par.PixPerDeg);%randi([30 100]);%[30 140]
destRect=[screenWidth/2+sampleX screenHeight/2+sampleY screenWidth/2+sampleX+visualWidth screenHeight/2+sampleY+visualHeight];
plot([0 0],[-240 60],'k:')
plot([-60 240],[0 0],'k:')
colind = hsv(10);
for i=1:10
    targetLetter=allLetters(i);
    letterPath=['D:\data\letters\',targetLetter,'.bmp'];
    originalOutline=imread(letterPath);
    shape=imresize(originalOutline,[visualHeight,visualWidth]);
    whiteMask=shape==0;
    whiteMask=whiteMask*255;
    shapeRGB(:,:,1)=whiteMask+shape*255*colind(i,1);
    shapeRGB(:,:,2)=whiteMask+shape*255*colind(i,2);
    shapeRGB(:,:,3)=whiteMask+shape*255*colind(i,3);
    h=image(sampleX,-sampleY-visualHeight,flip(shapeRGB,1)); 
    if i<4
        set(h, 'AlphaData', 0.5);
    else
        set(h, 'AlphaData', 0.1);
    end
    hold on
%     axis square
    axis equal
%     pause(1)
end
hold on
p=ellipse(channelRFs(channelInd,3)/2,channelRFs(channelInd,3)/2,channelRFs(channelInd,1),channelRFs(channelInd,2));
set(p,'Color',[0.4 0.4 0.4]);
plot(channelRFs(channelInd,1),channelRFs(channelInd,2),'x','Color',[0.4 0.4 0.4]);
scatter(0,0,'r','o');
set(gca,'XTick',[-2*Par.PixPerDeg 0 2*Par.PixPerDeg 4*Par.PixPerDeg 6*Par.PixPerDeg 8*Par.PixPerDeg]);
set(gca,'XTickLabel',{'-2' '0' '2' '4' '6' '8'});
set(gca,'YTick',[-8*Par.PixPerDeg -6*Par.PixPerDeg -4*Par.PixPerDeg -2*Par.PixPerDeg 0 2*Par.PixPerDeg]);
set(gca,'YTickLabel',{'-8' '-6' '-4' '-2' '0' '2'});
ellipse(50,50,0,0,[0.1 0.1 0.1]);
ellipse(100,100,0,0,[0.1 0.1 0.1]);
ellipse(150,150,0,0,[0.1 0.1 0.1]);
ellipse(200,200,0,0,[0.1 0.1 0.1]);
xlim([-60 240]);ylim([-240 60]);
xlim([-40 180]);ylim([-180 20]);
titleText='RF location';
title(titleText);
