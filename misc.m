analyse_RF_barsweep_coordinates
figure; plot(MUAm)
originalMUA=MUAm;
testMUA=zeros(1,1599);
norm = normpdf(-200:200,0,30);
plot(-200:200,norm)
testMUA(600:1000)=testMUA(600:1000)+norm;
plot(testMUA)
testMUA=testMUA*1000;
testMUA=testMUA+10;
plot(testMUA)

MUAm=testMUA;
BaseS=5;
SNR=Scale/BaseS;