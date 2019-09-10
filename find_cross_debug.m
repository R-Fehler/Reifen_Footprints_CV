clearvars;
close all hidden;
clc;



img_a=imread(fullfile(pwd,'Footprints_zu_auswerten_2\Original\Run1\2.jpg'));
 figure,imshow(img_a);
left_cross_ROI=[100 500 1100 5000];
right_cross_ROI=[3500 500 1200 5000];

[xx,yy]=find_cross_xy(img_a,left_cross_ROI);
[x2,y2]=find_cross_xy(img_a,right_cross_ROI);

clc
close all hidden
clearvars
