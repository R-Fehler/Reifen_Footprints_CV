clearvars;
close all hidden;
clc;

margin_top=500;
margin_bottom=500;
margin_left=30;
margin_right=20;

img_a=imread(fullfile("C:\footprint_auswertung_druckmessfolien\FootprintsJan\20191004_Scans_Loop-3\Original\Ac1s2Asphalt2.6\22.jpg"));
figure,imshow(img_a);
[img_height,img_width,rgb_dim]=size(img_a);

left_cross_ROI=[margin_left margin_top 0.5*img_width img_height-margin_top-margin_bottom];
right_cross_ROI=[0.5*img_width margin_top 0.5*img_width-margin_right img_height-margin_top-margin_bottom ];


[xx,yy]=find_cross_xy(img_a,left_cross_ROI);
[x2,y2]=find_cross_xy(img_a,right_cross_ROI);

clc
close all hidden
clearvars
