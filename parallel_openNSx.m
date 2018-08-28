Pool=parpool
parfor workerInd=1:Pool.NumWorkers
    channelNumsPool=['c:',num2str(1+3*(workerInd-1)),':',num2str(3*workerInd)]%works for file size of 44 GB, 135 s
%     channelNumsPool=['c:',num2str(1+9*(workerInd-1)),':',num2str(9*workerInd)]%works for file size of 14 GB, 47 seconds
    tic
%     myNSx = openNSx('D:\data\examples\06-Dec-2016_16-43-16_i2_001.ns4')%out of memory error
%     myNSx = openNSx('D:\data\examples\06-Dec-2016_16-43-16_i2_001.ns4','read',channelNumsPool)
    myNSx = openNSx('D:\data\examples\06-Dec-2016_16-43-16_i2_001.ns6','read',channelNumsPool);
    toc
end
delete(gcp('nocreate'))

%Can open:
%4.2 GB file, datafile_10min_128chs.ns5 

%Cannot open:
%9.1 GB file, datafile_20min_128chs.ns5