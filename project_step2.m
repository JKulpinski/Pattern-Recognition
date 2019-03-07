clc; clear all;
load haberman.data
pkg load io
pkg load statistics
pkg load nan

A = haberman;
#Sort because 4 column is class
A = sortrows(A,4);

# 3 features 1.Age of patient at time of operation (numerical) 
#2. Patient's year of operation (year - 1900, numerical) 
#3. Number of positive axillary nodes
for i=1:3
  figure(i);
  #2 classes: 225 patients survived (1), 81 not survived (2)
  boxplot({ A(1:225,i), A(226:306,i)});
endfor