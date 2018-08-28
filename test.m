function test
figure
for locInd=1:length(Grid_x)*length(Grid_y)%go through each stimulus location condition
    locMatchInd=find(stimXY==locInd);
    if ~isempty(locMatchInd)
        MUAm=mean(stimActBaselineSub(locMatchInd,:),1);%calculate mean MUA across trials for that condition
%         subplot(17,17,locInd);
        plot(MUAm);
    end
end
for testInd=1:length(test)
plot(stimActBaselineSub(test(testInd)-50:test(testInd)+50));hold on
end