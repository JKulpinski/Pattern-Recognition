clc; clear all;
load haberman.data
pkg load io
pkg load statistics
pkg load nan

A = haberman;
#Sort because 4 column is class
A = sortrows(A,4);

%outliers
mi=mean(A); 
sigma=std(A); 
n=size(A,1); 
outlier = abs(A - mi(ones(n,1),:))>3*sigma(ones(n,1),:); 
nout=sum(outlier); 
A(any(outlier'),:)=[]; 
#cat(any(outlier'),:)=[]; 

#5 outliers were removed
# Searching for information how many instances belongs to class1 and class2
class1=0;
class2=0;
for i=1:301
  if A(i,4)== 1
    class1++; %222 elements
  else
    class2++; %79
  endif
endfor

%separate matrix containing class and remove class column from dataset
class = A(:,4);
A(:,4)=[];

%transform into 0 1
transA1=A-repmat(min(A),size(A,1),1); 
transA2=repmat(max(A),size(A,1),1) - repmat(min(A),size(A,1),1); 
A=transA1 ./ transA2; 

%training 80-20%
X = A(1:222,:); 
Y = A(223:301,:);
Data = [{X(:,:)}   '1';
{Y(:,:)} '2'];
[TrainingSet,ValidationSet,TrainingClass,ValidationClass] = basicsets(Data); #80 20%

%3 gscatters
figure 
subplot(1,3,1); 
gscatter(A(:,1),A(:,3),class,'rgb','...',15,'on','Age','Number of nodes');  

subplot(1,3,2); 
gscatter(TrainingSet(:,1),TrainingSet(:,3),TrainingClass,'rgb','...',15,'on','Age','Number of nodes'); 
axis([0 1 0 1]);  
 
subplot(1,3,3); 
gscatter(ValidationSet(:,1),ValidationSet(:,3),ValidationClass,'rgb','...',15,'on','Age','Number of nodes'); 
axis([0 1 0 1]); 
##
##%training 70-30%
##[TrainingSet2,ValidationSet2,TrainingClass2,ValidationClass2] = basicsets70_30(Data);
##
##%3 gscatters
##figure 
##subplot(1,3,1); 
##gscatter(A(:,1),A(:,3),class,'rgb','...',20,'off','Age','Number of nodes');  
##
##subplot(1,3,2); 
##gscatter(TrainingSet2(:,1),TrainingSet2(:,3),TrainingClass2,'rgb','...',20,'on','Age','Number of nodes'); 
##axis([0 1 0 1]);  
## 
##subplot(1,3,3); 
##gscatter(ValidationSet2(:,1),ValidationSet2(:,3),ValidationClass2,'rgb','...',20,'on','Age','Number of nodes'); 
##axis([0 1 0 1]); 
##
##%training 90-10%
##[TrainingSet3,ValidationSet3,TrainingClass3,ValidationClass3] = basicsets90_10(Data);
##
##%3 gscatters
##figure 
##subplot(1,3,1); 
##gscatter(A(:,1),A(:,3),class,'rgb','...',20,'off','Age','Number of nodes');  
##
##subplot(1,3,2); 
##gscatter(TrainingSet3(:,1),TrainingSet3(:,3),TrainingClass3,'rgb','...',20,'on','Age','Number of nodes'); 
##axis([0 1 0 1]); 
## 
##subplot(1,3,3); 
##gscatter(ValidationSet3(:,1),ValidationSet3(:,3),ValidationClass3,'rgb','...',20,'on','Age','Number of nodes'); 
##axis([0 1 0 1]); 

%Linear Classifier
[classesLinear,errn] =classify(ValidationSet,TrainingSet,TrainingClass,'LDA'); 
##%Linear Classifier
##[classesLinear2,errn2] =classify(ValidationSet2,TrainingSet2,TrainingClass2,'LDA'); 
##%Linear Classifier
##[classesLinear3,errn3] =classify(ValidationSet3,TrainingSet3,TrainingClass3,'LDA'); 

%plots
% Visualizing results 
% subplot_1 decision areas 
[x,y] = meshgrid(0:0.01:1,0:0.01:1); 
x = x(:); 
y = y(:); 
j1 = classify([x y],TrainingSet(:,[1,3]),TrainingClass,'LDA'); 
figure 
subplot(1,3,1); 
gscatter(x,y,j1,'rgb','ooo',1,'on','Age','Number of nodes'); 
axis([0 1 0 1]); 
% Visualizing results 
% subplot 2 - the ValidationSet before the classification 
subplot(1,3,2); 
gscatter(ValidationSet(:,1),ValidationSet(:,3),ValidationClass,'rgb','ooo',5,'on','Age','Number of nodes'); 
axis([0 1 0 1]); 
% subplot 3 - the ValidationSet after the classification 
subplot(1,3,3); 
gscatter(ValidationSet(:,1),ValidationSet(:,3),classesLinear,'rgb','ooo',5,'on','Age','Number of nodes'); 
axis([0 1 0 1]);

%Quadratic Classifier
[classesQuad,errn2]=classify(ValidationSet,TrainingSet,TrainingClass,'QDA2'); 

% Visulaizing results 
[x,y] = meshgrid(0:0.01:1,0:0.01:1); 
x = x(:); y = y(:); 
j1 = classify([x y],TrainingSet(:,[1,3]),TrainingClass,'QDA2'); 
figure 
subplot(1,3,1); 
gscatter(x,y,j1,'rgb','ooo',1,'on','Age','Number of nodes'); 
axis([0 1 0 1]); 
% Visulaizing results 
% subplot 2 - the ValidationSet before classification 
subplot(1,3,2); 
gscatter(ValidationSet(:,1),ValidationSet(:,3),ValidationClass,'rgb','ooo',5,'on','Age','Number of nodes'); 
axis([0 1 0 1]);
% subplot 3 - the ValidationSet after classification 
subplot(1,3,3); 
gscatter(ValidationSet(:,1),ValidationSet(:,3),classesQuad ,'rgb','ooo',5,'on','Age','Number of nodes'); 
axis([0 1 0 1]); 

%KMEANS
%2 clusters
[idx,C] = kmeans(A,2,'distance','cosine'); #here i made kmeans settings changes

figure;
subplot(1,2,1);
gscatter(A(:,1),A(:,3),class,'rgb','...',20);
title 'Haberman';
%legend('1','2','3','location','northwest')
subplot(1,2,2);
hold on;
plot(A(idx==1,1),A(idx==1,3),'r*','MarkerSize',10)
plot(A(idx==2,1),A(idx==2,3),'g*','MarkerSize',10)


% visualize cluster centers
plot(C(:,1),C(:,3),'kx','MarkerSize',10,'LineWidth',2)
plot(C(:,1),C(:,3),'ko','MarkerSize',10,'LineWidth',2)


legend('Cluster 1','Cluster 2','Centroids','location','northwest')
title 'Cluster Assignments and Centroids'
hold off;

figure;
for i = 1:2
    clust = find(idx==i);
    plot3(A(clust,1),A(clust,2),A(clust,3),'...',"markersize", 20, "markerfacecolor", "auto");
    hold on
end
plot3(C(:,1),C(:,2),C(:,3),'ko',"markersize", 15);
plot3(C(:,1),C(:,2),C(:,3),'kx',"markersize", 15);
title 'Cluster Assignments and Centroids 3D'
hold off
xlabel('Age');
ylabel('Year');
zlabel('Nodes');
view(-137,10);
grid on

%LINKAGE
figure;
X=A(:,[1,3]);
Y = pdist(X,'euclidean');
squareform(Y);
Z = linkage(Y);
dendrogram(Z);

#Y = pdist(X,'cityblock');
#Z = linkage(Y,'average');
%c = cophenet(Z,Y);

I = inconsistent(Z);