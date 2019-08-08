clearvars;
close all hidden;

%% Skript zur exakten Ausrichten, beschneiden und einfaerben von Footprints
%% Input in Original\<Reifen>\*.jpg  Output in Original\<Reifen>\cropped\*.jpg

Pfad=fullfile(pwd,'Footprints_zu_auswerten');

left_cross_ROI=[100 500 1100 5000];
right_cross_ROI=[4000 500 700 5000];

%% Check the folders in Original\ and create a List of them
dirpath=fullfile(Pfad,'Original\*');
listofDirs=dir(dirpath);
j=1;
for ii = 1 : size(listofDirs,1)
    if(listofDirs(ii).isdir     && ~contains(listofDirs(ii).name,'.') && ~contains(listofDirs(ii).name ,'..'))
    MainListofDirs(j) = listofDirs(ii); %#ok<SAGROW> % bei Bedarf vor allocaten, aber im Moment egal
    j=j+1;
    
    end
            
end
%% Main Loop over Folders / Directories


for d=1:length(MainListofDirs)
currentFolder=MainListofDirs(d);
subpath=fullfile(Pfad,'Original',currentFolder.name,'*jpg');
listofFiles=dir(subpath);

%% Loop over Files in Folder

    for ii=1:length(listofFiles)

        FilePath=[listofFiles(ii).folder,'\',listofFiles(ii).name];
        if(exist(FilePath,'file') == 2)  
            %% Horizontale Ausrichtung des Footprints festlegen, dann Footprints umdrehen

            Bild1=imread(FilePath);
            % imshow(Bild1);
            copy1=Bild1;
            copy2=copy1;
            %% Punkt 1 und 2 finden
            [x1,y1]=find_cross_xy(copy1,left_cross_ROI);
            [x2,y2]=find_cross_xy(copy2,right_cross_ROI);
            %% Ursprung uebereinander legen
            if ii == 1 % erstes Bild legt Ursprung fuer Cropping fest
                x_start=x1;
                y_start=y1;
            end

            AllPoints=[];
            AllPoints(1,1)=x1;
            AllPoints(1,2)=y1;
            AllPoints(2,1)=x2;
            AllPoints(2,2)=y2;

            %% Berechnung von Rotationswinkel und Rotation
            deltaX=abs(AllPoints(1,1)-AllPoints(2,1));
            [minVal,IndexFirst]=min(AllPoints(:,1));
            if IndexFirst==1
                IndexSecond=2;
            else
                IndexSecond=1;
            end
            deltaY=AllPoints(IndexSecond,2)-AllPoints(IndexFirst,2);
            Omega=atan(deltaY/deltaX)*180/pi;
            Bild1=imrotate(Bild1,Omega,'crop');
            % imshow(Bild1)

            %% neue Koord. von Punkt 1 nach Rotation finden
            copy1=Bild1;
            [x1,y1]=find_cross_xy(copy1,left_cross_ROI);


            x_diff=x_start-x1;
            y_diff=y_start-y1;

            %% aktuelles Bild verschieben (nach x1,y1 von Punkt #1 von Bild #1)
                Bild1=imtranslate(Bild1,[x_diff,y_diff]);
                % imshow(Bild1)

    %         end
            %% korrigiertes aktuelles Bild speichern
                NeuerName=fullfile(listofFiles(ii).folder,'corrected',['Corrected_',listofFiles(ii).name]);
                mkdir(fullfile(listofFiles(ii).folder,'corrected'));
                imwrite(Bild1,NeuerName);

            %% Crop Image / beschneide Bild
            % lila maskieren, max min x,y finden. dann alle
             % bilder gleich croppen um das uebereinander legen
             % zu ermoeglichen
                %% das erste Bild gibt den maximalen Umriss vor.  
             if ii==1 

                copy3=Bild1;

                [x1_min,y1_min,x1_max,y1_max]=findFootprintArea(copy3);
                % Alle BIlder mit diesem croppen. Ursprung �bereinander legen
                Bild_2= imcrop(Bild1,[x1_min y1_min x1_max-x1_min y1_max-y1_min]);

                %% alle anderen Bildern werden mit diesem Umriss beschnitten
             else
                Bild_2= imcrop(Bild1,[x1_min y1_min x1_max-x1_min y1_max-y1_min]);
             end

    %% Farben anpassen: jedes Bild hat eigene Farbe         
             if mod(ii,4)==3
                Bild_neu(:,:,1)=Bild_2(:,:,3);
                Bild_neu(:,:,2)=Bild_2(:,:,2);
                Bild_neu(:,:,3)=Bild_2(:,:,1);
                Bild_2=Bild_neu;
                clear Bild_neu;
             end

             if mod(ii,4)==0
                Bild_neu(:,:,1)=Bild_2(:,:,2);
                Bild_neu(:,:,2)=Bild_2(:,:,1);
                Bild_neu(:,:,3)=Bild_2(:,:,3);
                Bild_2=Bild_neu;
                clear Bild_neu;
             end
            % imshow(Bild_2)

    %% zugeschnittene, gefaerbte Bilder abspeichern
            mkdir(fullfile(listofFiles(ii).folder,'cropped'));
            NeuerName=fullfile(listofFiles(ii).folder,'cropped',['Cropped_',listofFiles(ii).name]);
            imwrite(Bild_2,NeuerName)
            close gcf
        end
    end

end

    clc
    close all hidden
    clearvars

