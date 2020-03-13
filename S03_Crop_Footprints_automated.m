clearvars;
close all hidden;
%% Requires Matlab R2019 for CSV --> optimized read/writecell function
%% Skript zur exakten Ausrichten, beschneiden und einfaerben von Footprints
%% Input in Original\<Reifen>\*.jpg  Output in Original\<Reifen>\cropped\*.jpg

Folienanzahl = 4;


answer = questdlg('Excel or CSV File?', ...
	'', ...
	'Excel','CSV','Cancel','Cancel');
% Handle response
switch answer
    case 'Excel'
        read_CSV_File=false;
       
    case 'CSV'
        read_CSV_File=true;
    case 'Cancel'
        errordlg('Keine Datei ausgew�hlt, breche ab')
        error('Keine Datei ausgew�hlt, breche ab')
end
if read_CSV_File==true
    [filename, filepath] = uigetfile('executed_*.csv', 'Choose CSV File created with createFolders.m');
    offset=0;
else
    [filename, filepath] = uigetfile('*.xl*', 'Zu bearbeitende Exceldatei auswaehlen');
    offset=2;

end


if filename == 0
    clearvars
    errordlg('Keine Datei ausgew�hlt, breche ab')
    error('Keine Datei ausgew�hlt, breche ab')
end

% customReadCells() can also read xls files. 
% xlsread is deprecated in R2019

if read_CSV_File==true
    [num,txt,raw] = customReadCells(fullfile(filepath,filename));
else
    [num, txt, raw] = xlsread([filepath, filename]);
end


SpalteFahrbahn = 1;
SpalteFolienTyp = 2;
SpalteReifen = 3;
SpalteRadlastSoll = 4;
SpalteTemperatur = 5;
SpalteRelLuftfeuchte = 6;
SpalteDruckSoll = 7;
SpalteCamberAngle = 8;

SpalteFoliennummer = 10;
SpalteNeuerName = 12;
PosCrop_x = 13;
PosCrop_y = 14;
Width = 15;
Height = 16;
SpalteFolderPath = 17;

AuswertungWeitermachen = 1;
addpath(fullfile(cd, 'Unterfunktionen'))

%%
Pfad = fullfile(filepath);

Alpha_Setting = 0;

%% Neue Implementation
for ii = 1+offset:(size(num, 1) + offset)
    newPath = fullfile('Original', [raw{ii, SpalteReifen}, raw{ii, SpalteFahrbahn}, num2str(raw{ii, SpalteDruckSoll}), 'bar', num2str(raw{ii, SpalteRadlastSoll}), 'N', num2str(raw{ii, SpalteCamberAngle}), 'deg']);
    ListofDirs{ii - offset} = newPath;
end

ListofDirs = convertCharsToStrings(ListofDirs);
ListofDirs = unique(ListofDirs, 'stable');

%% Main Loop over Folders / Directories

for currentFolder = ListofDirs%%Iterator for each string, d ist string var
    currentFolder
    subpath = fullfile(Pfad, currentFolder, '*jpg');
    tempres = txt == currentFolder;
    [row, col] = find(tempres == 1);
    dd = min(row);

    %% Loop over Files in Folder
    listofFiles = dir(subpath);
    xlsfiles = {listofFiles.name};
    xlsfiles = natsortfiles(xlsfiles);

    for ii = 1:length(listofFiles)

        FilePath = fullfile(listofFiles(ii).folder, xlsfiles{ii});

        if (exist(FilePath, 'file') == 2)
            %% Horizontale Ausrichtung des Footprints festlegen, dann Footprints umdrehen
            FilePath
            Bild1 = imread(FilePath);
            % imshow(Bild1);
            copy1 = Bild1;
            copy2 = copy1;
            [img_height, img_width, rgb_dim] = size(Bild1);

            %% PARAMETER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            margin_top = img_height * 0.2;
            margin_bottom = img_height * 0.2;
            margin_left = 25;
            margin_right = 35;
            CrossBorderLine = 0.5; % wo befindet sich die "Bildhälfte" zwischen den zwei Kreuzen
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            left_cross_ROI = [margin_left margin_top CrossBorderLine*img_width img_height-margin_top-margin_bottom];
            right_cross_ROI = [CrossBorderLine*img_width margin_top (1-CrossBorderLine)*img_width-margin_right img_height-margin_top-margin_bottom ];

            %% Punkt 1 und 2 finden
            [x1, y1] = find_cross_xy(copy1, left_cross_ROI);
            [x2, y2] = find_cross_xy(copy2, right_cross_ROI);
            %% Ursprung uebereinander legen
            if ii == 1% erstes Bild legt Ursprung fuer Cropping fest
                x_start = x1;
                y_start = y1;
            end

            AllPoints = [];
            AllPoints(1, 1) = x1;
            AllPoints(1, 2) = y1;
            AllPoints(2, 1) = x2;
            AllPoints(2, 2) = y2;

            %% Berechnung von Rotationswinkel und Rotation
            deltaX = abs(AllPoints(1, 1) - AllPoints(2, 1));
            [minVal, IndexFirst] = min(AllPoints(:, 1));

            if IndexFirst == 1
                IndexSecond = 2;
            else
                IndexSecond = 1;
            end

            deltaY = AllPoints(IndexSecond, 2) - AllPoints(IndexFirst, 2);
            Omega = atan(deltaY / deltaX) * 180 / pi;
            Bild1 = imrotate(Bild1, Omega, 'crop');
            % imshow(Bild1)

            %% neue Koord. von Punkt 1 nach Rotation finden
            copy1 = Bild1;
            [x1, y1] = find_cross_xy(copy1, left_cross_ROI);

            x_diff = x_start - x1;
            y_diff = y_start - y1;

            %% aktuelles Bild verschieben (nach x1,y1 von Punkt #1 von Bild #1)
            Bild1 = imtranslate(Bild1, [x_diff, y_diff]);
            % imshow(Bild1)

            %         end
            %% korrigiertes aktuelles Bild speichern
            NeuerName = fullfile(listofFiles(ii).folder, 'corrected', ['Corrected_', listofFiles(ii).name]);
            mkdir(fullfile(listofFiles(ii).folder, 'corrected'));
            imwrite(Bild1, NeuerName);

            %% Crop Image / beschneide Bild
            % lila maskieren, max min x,y finden. dann alle
            % bilder gleich croppen um das uebereinander legen
            % zu ermoeglichen
            %% das erste Bild gibt den maximalen Umriss vor.
            if ii == 1

                copy3 = Bild1;

                [x1_min, y1_min, x1_max, y1_max] = findFootprintArea(copy3);
                % Alle BIlder mit diesem croppen. Ursprung �bereinander legen
                Bild_2 = imcrop(Bild1, [x1_min y1_min x1_max-x1_min y1_max-y1_min]);

                %% alle anderen Bildern werden mit diesem Umriss beschnitten
            else
                Bild_2 = imcrop(Bild1, [x1_min y1_min x1_max-x1_min y1_max-y1_min]);
                Bild_BW = im2bw(Bild_2, 0.9);
                % figure,imshow(Bild_BW);
            end

            %Excel Zellen fuellen
            raw{ii + dd - 1, PosCrop_x} = x1_min;
            raw{ii + dd - 1, PosCrop_y} = y1_min;
            raw{ii + dd - 1, Width} = x1_max - x1_min;
            raw{ii + dd - 1, Height} = y1_max - y1_min;

            %% schwarze Kreuze entfernen
            [~, Bild_2] = createMask_pink(Bild_2);
            M = repmat(all(~Bild_2, 3), [1 1 3]);
            Bild_2(M) = 255;

            %% zugeschnittene, gefaerbte Bilder abspeichern
            mkdir(fullfile(listofFiles(ii).folder, 'cropped'));
            NeuerName = fullfile(listofFiles(ii).folder, 'cropped', ['Cropped_', listofFiles(ii).name]);
            raw{ii + dd - 1, 12} = NeuerName;
            imwrite(Bild_2, NeuerName)
            close gcf
        end

    end
    
if read_CSV_File==true
    opts = detectImportOptions([filepath, filename]);
    writecell(raw,fullfile(filepath,filename),'Delimiter',opts.Delimiter{1});
else
    xlswrite([filepath, filename], raw);
end

end

% clc
close all hidden
clearvars