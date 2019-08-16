function generate_electrode_sets_control_microstim_letter_task
%Written by Xing on 2/8/19
%Randomly assign channels with good current thresholds to new electrode
%sets for a control letter task, in which both microstimulation and visual
%versions are carried out.

electrodeNums=[16 47 55 59 9 12 16 32 35 50 2 17 32 34 40 41 44 47 51 52 55];
arrayNums=[12 12 12 13 14 14 14 14 14 14 16 16 16 16 16 16 16 16 16 16 16];
oddNums=1:2:length(electrodeNums);
evenNums=2:2:length(electrodeNums);
electrodeNumsShuffled=[electrodeNums(oddNums) electrodeNums(evenNums)];
arrayNumsShuffled=[arrayNums(oddNums) arrayNums(evenNums)];

allElectrodeSets={};
allArraySets={};
stepSize=floor(length(electrodeNumsShuffled)/20);
for setInd=1:10
    inds=(setInd-1)*stepSize+1:(setInd-1)*stepSize+10;
    electrodesTarg1=electrodeNumsShuffled(inds);
    arraysTarg1=arrayNumsShuffled(inds);
    electrodesTarg2=electrodeNumsShuffled;
    arraysTarg2=arrayNumsShuffled;
    electrodesTarg2(inds)=[];
    arraysTarg2(inds)=[];
    if length(electrodesTarg2)>10
        electrodesTarg2=electrodesTarg2(1:10);
        arraysTarg2=arraysTarg2(1:10);
    end
    if mod(setInd,2)==1
        allElectrodeSets(setInd,1:2)=[{electrodesTarg1} {electrodesTarg2}];
        allArraySets(setInd,1:2)=[{arraysTarg1} {arraysTarg2}];
    else
        allElectrodeSets(setInd,1:2)=[{electrodesTarg2} {electrodesTarg1}];
        allArraySets(setInd,1:2)=[{arraysTarg2} {arraysTarg1}];
    end
end
save('X:\aston\010819_data\electrodeSets020819.mat','allElectrodeSets','allArraySets')