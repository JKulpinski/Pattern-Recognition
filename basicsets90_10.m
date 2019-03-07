function [ TrainingSet,ValidationSet,TrainingClass,ValidationClass ] = basicsets90_10( Data )
   %% Created by iikem%%%
   %% Splits Data to training and validation set %%% 
    TrainingSet=[];ValidationSet=[];TrainingClass=[];ValidationClass=[];
     for i=1:size(Data,1)
        TrainingSet=[TrainingSet;Data{i,1}(1:(size(Data{i,1},1)*90/100),:)];
        TrainingClass=[TrainingClass;repmat(Data(i,2),size(Data{i,1},1)*90/100,1)];
     end
     for i=1:size(Data,1)
         ValidationSet=[ValidationSet;Data{i,1}(round(1+(size(Data{i,1},1)*90/100)):(size(Data{i,1})),:)];
        ValidationClass=[ValidationClass;repmat(Data(i,2),size(Data{i,1},1)*10/100,1)];
     end
     %TrainingClass=cell2mat(TrainingClass);
     %ValidationClass=cell2mat(ValidationClass);
end