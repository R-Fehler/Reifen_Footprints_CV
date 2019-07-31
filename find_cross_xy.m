function [x,y] = find_cross_xy(I,ROI)
% FIND_CROSS_XY returns the estimated coordinate of the hand drawn
% cross
%
% Syntax:
%    [x,y] = find_cross_xy(I,ROI)
%
% Inputs:
%    I - Image I
%    ROI - Rectange Region of Interest (where the cross is likely to be)
%
% Outputs:
%    x,y coords of the cross


I=createMask_black(I);
I=imcrop(I,ROI);


BW=~I;
% figure,imshow(BW);
BW=imclearborder(BW); % entfernen der Randobjekte
% imshow(BW);

%% Linien detektieren
[H,T,R] = hough(BW);




P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
plot(x,y,'s','color','white');

lines = houghlines(BW,T,R,P,'FillGap',1,'MinLength',1);
% figure, imshow(I), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      
   end
end


%calculate the cross coords
x_min=100000;% large pixelcount 
y_min=100000;
x_max=0;% small 
y_max=0;

x_sum=0;
y_sum=0;
%% Bestimmen des average Punkts um ROI mithilfe eines Radius zu bestimmen
for k= 1:length(lines)
    x_sum=x_sum+lines(k).point1(1)+lines(k).point2(1);
    y_sum=y_sum+lines(k).point1(2)+lines(k).point2(2);
    
    
end    

x_avg=x_sum/(2*length(lines));
y_avg=y_sum/(2*length(lines));

radius=400;
%% Bestimme den Mittelpunkt des Kreuzes. hier anhand der Mitte der Extremwerte
%  avg der Werte auch denkbar.(war teilweise weniger robust)
for k= 1:length(lines)
  
    %% eingrenzen des ROI fuer Linien
    if (abs(lines(k).point1(1)-x_avg)<radius && abs(lines(k).point1(2)-y_avg)<radius)
        %% betrachte Horizontale Linien
        if (abs(lines(k).theta)>80)
            if(lines(k).point1(2)<y_min)
                    y_min=lines(k).point1(2);
            end
                
                if(lines(k).point1(2)>y_max)
                    y_max=lines(k).point1(2);
                end
        else
        
        %% Betrachte Vertikale
            if(abs(lines(k).theta)<10)
                if(lines(k).point1(1)<x_min)
                    x_min=lines(k).point1(1);
                end
                
                if(lines(k).point1(1)>x_max)
                    x_max=lines(k).point1(1);
                end
                

            end
        end
    end


end

x=(y_max+y_min)/2;
y=(x_max+x_min)/2;

close gcf
%% Berechne die Koordinaten im gesamten (urspruenglichen) Bild
x=ROI(2)+x;
y=ROI(1)+y;
% Swap x und y. Grund nicht ganz klar. funktioniert so.
c=x;
x=y;
y=c;


end
