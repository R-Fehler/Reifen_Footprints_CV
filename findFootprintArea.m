function [xmin,ymin,xmax,ymax] = findFootprintArea(I)
% FINDFOOTPRINTAREA finds the approximated Rectangle around the footprint
%                   
% Syntax:
%    [xmin,ymin,xmax,ymax] = findFootprintArea(I)


%% Settings
% Puffer um auch gesamten Bereich zu erhalten. (da Rauschfilter den verkleinert)
puffer=65;
%% load Image
img_a=I;
% figure,imshow(img_a);

BW=createMask_pink(img_a);
% imshow(BW);

%% Filtere Rauschen 

seD = strel('diamond',2);
BWfinal = imerode(BW,seD);
BWfinal = imerode(BWfinal,seD);
%  imshow(BWfinal), title('segmented image');
 
seD = strel('diamond',1);
BWfinal = imerode(BWfinal,seD);
BWfinal = imerode(BWfinal,seD);
BWfinal = imerode(BWfinal,seD);
BWfinal = imerode(BWfinal,seD);

%  imshow(BWfinal), title('3x segmented image');


%% Bestimme Umriss
[x,y]=find(BWfinal==true);
xmax=max(y);
xmin=min(y);
ymax=max(x);
ymin=min(x);

rectangle('Position',[xmin-puffer-30,ymin-puffer,xmax-xmin+puffer,ymax-ymin+puffer],'EdgeColor','b','LineWidth',3);
end