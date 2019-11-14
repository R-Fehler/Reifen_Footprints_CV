clearvars;
close all hidden;
clc;



img_a=imread(fullfile("C:\footprint_auswertung_druckmessfolien\JanNeu\FootprintsJan_jpegsedit\20180828_Scans_Loop-2\Original\BBAsphalt2.6bar5750N0deg\6.jpg"));
figure,imshow(img_a);
[img_height,img_width,rgb_dim]=size(img_a);
margin_top=img_height*0.2;
margin_bottom=img_height*0.2;
margin_left=25;
margin_right=35;
CrossBorderLine=0.75;
left_cross_ROI=[margin_left margin_top CrossBorderLine*img_width img_height-margin_top-margin_bottom];
right_cross_ROI=[CrossBorderLine*img_width margin_top (1-CrossBorderLine)*img_width-margin_right img_height-margin_top-margin_bottom ];
            
[xx,yy]=find_cross_xy(img_a,left_cross_ROI);
[x2,y2]=find_cross_xy(img_a,right_cross_ROI);

% clc
close all hidden
% clearvars
