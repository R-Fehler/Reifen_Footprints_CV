clearvars;
close all hidden;

%% Skript zur exakten Ausrichten, beschneiden und einfaerben von Footprints
%% Input in Original\<Reifen>\*.jpg  Output in Original\<Reifen>\cropped\*.jpg

Pfad=[pwd,'\Footprints_zu_auswerten\'];



%% Check the folders in Original\ and create a List of them
dirpath=[Pfad,'Original\*'];
listofDirs=dir(dirpath);
j=1;
for i = 1 : size(listofDirs,1)
    if(listofDirs(i).isdir     && ~contains(listofDirs(i).name,'.') && ~contains(listofDirs(i).name ,'..'))
    MainListofDirs(j) = listofDirs(i); % bei Bedarf vor allocaten, aber im Moment egal
    j=j+1;
    
    end
            
end
%% Main Loop over Folders / Directories


for d=1:length(MainListofDirs)
currentFolder=MainListofDirs(d);
subpath=[Pfad,'Original\',currentFolder.name,'\*jpg'];
listofFiles=dir(subpath);

%% Loop over Files in Folder

    for i=1:length(listofFiles)

        FilePath=[listofFiles(i).folder,'\',listofFiles(i).name];
        if(exist(FilePath,'file') == 2)  
            %% Horizontale Ausrichtung des Footprints festlegen, dann Footprints umdrehen

            Bild1=imread(FilePath);
            % imshow(Bild1);
            copy1=Bild1;
            copy2=copy1;
            %% Punkt 1 und 2 finden
            [x1,y1]=find_cross_xy(copy1,[100 500 1100 5000]);
            [x2,y2]=find_cross_xy(copy2,[4000 500 700 5000]);
            %% Ursprung uebereinander legen
            if mod(i,4) == 1 % erstes Bild legt Ursprung f�r Cropping fest
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
            [x1,y1]=find_cross_xy(copy1,[100 500 1100 5000]);


            x_diff=x_start-x1;
            y_diff=y_start-y1;

            %% aktuelles Bild verschieben (nach x1,y1 von Punkt #1 von Bild #1)
                Bild1=imtranslate(Bild1,[x_diff,y_diff]);
                % imshow(Bild1)

    %         end
            %% korrigiertes aktuelles Bild speichern
                NeuerName=[listofFiles(i).folder,'\corrected\Corrected_',listofFiles(i).name];
                mkdir([listofFiles(i).folder,'\corrected']);
                imwrite(Bild1,NeuerName);

            %% Crop Image / beschneide Bild
            % lila maskieren, max min x,y finden. dann alle
             % bilder gleich croppen um das uebereinander legen
             % zu ermoeglichen
                %% das erste Bild gibt den maximalen Umriss vor.  
             if mod(i,4)==1

                copy3=Bild1;

                [x1_min,y1_min,x1_max,y1_max]=findFootprintArea(copy3);
                % Alle BIlder mit diesem croppen. Ursprung �bereinander legen
                Bild_2= imcrop(Bild1,[x1_min y1_min x1_max-x1_min y1_max-y1_min]);

                %% alle anderen Bildern werden mit diesem Umriss beschnitten
             else
                Bild_2= imcrop(Bild1,[x1_min y1_min x1_max-x1_min y1_max-y1_min]);
             end

    %% Farben anpassen: jedes Bild hat eigene Farbe         
             if mod(i,4)==3
                Bild_neu(:,:,1)=Bild_2(:,:,3);
                Bild_neu(:,:,2)=Bild_2(:,:,2);
                Bild_neu(:,:,3)=Bild_2(:,:,1);
                Bild_2=Bild_neu;
                clear Bild_neu;
             end

             if mod(i,4)==0
                Bild_neu(:,:,1)=Bild_2(:,:,2);
                Bild_neu(:,:,2)=Bild_2(:,:,1);
                Bild_neu(:,:,3)=Bild_2(:,:,3);
                Bild_2=Bild_neu;
                clear Bild_neu;
             end
            % imshow(Bild_2)

    %% zugeschnittene, gefaerbte Bilder abspeichern
            mkdir([listofFiles(i).folder,'\cropped']);
            NeuerName=[listofFiles(i).folder,'\cropped\Cropped_',listofFiles(i).name];
            imwrite(Bild_2,NeuerName)
            close gcf
        end
    end

end

    clc
    close all hidden
    clearvars

