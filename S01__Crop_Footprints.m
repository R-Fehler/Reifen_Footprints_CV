clearvars;
close all hidden;

[Name_Exceldatei,Pfad] = uigetfile('*.xl*','Zu bearbeitende Exceldatei ausw�hlen');

if Name_Exceldatei==0
    clearvars
    errordlg('Keine Excel-Datei ausgew�hlt, breche ab')
    error('Keine Excel-Datei ausgew�hlt, breche ab')
end
[num,txt,raw] = xlsread([Pfad,Name_Exceldatei]);

is_nan_temperatur = any(isnan(num(:, 2)));
is_nan_luftfeuchtigkeit = any(isnan(num(:, 3)));
is_nan_film_number = any(isnan([raw{3:end, 10}]));

if is_nan_temperatur || is_nan_luftfeuchtigkeit || is_nan_film_number
    errordlg('ERROR: Excel-Datei pr�fen, Eintrag fehlt')
    error('ERROR: Excel-Datei pr�fen, Eintrag fehlt')
end
SpalteFoliennummer=10;
SpalteNeuerName=12;
SpalteFolientyp=2;
PosCrop_x=13;
PosCrop_y=14;
Width=15;
Height=16;
AuswertungWeitermachen = 1;
addpath([cd,'\','Unterfunktionen'])


for i=1:size(raw,1)
    FilePath=[Pfad,'Original\',raw{i,10}];
    if(exist(FilePath,'file') == 2)  %
        %% Horizontale Ausrichtung des Footprints festlegen, dann Footprints umdrehen
        
        Bild1=imread(FilePath);
        imshow(Bild1);
        message = sprintf(['Horizontale Ausrichtung des Reifens einlesen \n\n', ...
            '\t- Ersten Punkt ausw�hlen und auf AddPoint klicken\n',...
            '\t- Zweiten Punkt ausw�hlen und auf AddPoint klicken\n',...
            '\t- Auf Next/End klicken']);
        msgbox(message,'replace')
        datacursormode on
        
        %Buttons hinzufuegen
        AllPoints=[];
        
        while (size(AllPoints,1)<2) && ishandle(1)
            handles.push1=uicontrol('Style', 'pushbutton', 'String','AddPoint','Position',[10 10 60 20],'Callback','[AllPoints]=GetValue(AllPoints)');
            handles.push2=uicontrol('Style', 'pushbutton', 'String','Next/End','Position',[80 10 60 20],'Callback', 'Abort');
            uiwait
            if size(AllPoints,1)<2
                msgbox('2 Punkte f�r die horizontale Ausrichtung ben�tigt','replace')
            end
        end
        if ishandle(1)==0
            AuswertungWeitermachen = 0;
            break
        end
        
        deltaX=abs(AllPoints(1,1)-AllPoints(2,1));
        [minVal,IndexFirst]=min(AllPoints(:,1));
        if IndexFirst==1
            IndexSecond=2;
        else
            IndexSecond=1;
        end
        deltaY=AllPoints(IndexSecond,2)-AllPoints(IndexFirst,2);
        Omega=atan(deltaY/deltaX)*180/pi;
        Bild1=imrotate(Bild1,Omega);
        imshow(Bild1)
        
        %% Origin
        message = sprintf(['- Ursprungspunkt ausw�hlen und auf AddPoint klicken\n',...
            '- Auf Next/End klicken\n\n',...
            'Hinweis: Bei jeder Folie muss der Ursprung konsistent sein (z.B. immer das Zentrum von dem linken Kreuz)']);
        msgbox(message,'Ursprung einlesen','replace');
        AllPoints=[];
        while (size(AllPoints,1)<1) && ishandle(1)
            handles.push1=uicontrol('Style', 'pushbutton', 'String','AddPoint','Position',[10 10 60 20],'Callback','[AllPoints]=GetValue(AllPoints)');
            handles.push2=uicontrol('Style', 'pushbutton', 'String','Next/End','Position',[80 10 60 20],'Callback', 'Abort');
            
            set(gcf,'toolbar','figure')
            uiwait
            if size(AllPoints,1)<1
                msgbox('1 Punkt f�r den Ursprung des Footprints ben�tigt. Ursprung ausw�hlen, auf AddPoint und dann auf Next/End klicken','replace')
            end
        end
        
        if ishandle(1)==0
            AuswertungWeitermachen = 0;
            break
        end
        
        if strcmp(raw{i,SpalteFolientyp},'LLLLW')==1
            datacursormode off
            handles.push2=uicontrol('Style', 'pushbutton', 'String','Next/End','Position',[80 10 60 20],'Callback', 'Abort');
            
            h = imrect(gca,[round(size(Bild1,2)/2-size(Bild1,2)/10) round(size(Bild1,1)/2-size(Bild1,1)/10) size(Bild1,2)/5 size(Bild1,1)/5]);
            
            message = sprintf(['Ziehbares Rechteck mit der Maus auf die Gr��e des Footprints einstellen.\n',...
                'Innerhalb des Rechteckes sollte nur Rosa-Farbe sein\n',...
                'Auf Next/End klicken']);
            msgbox(message,'replace')
            
            uiwait
            pos = getPosition(h);
            
            for s=1:4
                raw{i+s-1,PosCrop_x}=pos(1)-AllPoints(1,1);
                raw{i+s-1,PosCrop_y}=pos(2)-AllPoints(1,2);
                raw{i+s-1,Width}=pos(3);
                raw{i+s-1,Height}=pos(4);
            end
        end
        %Crop Image
        x_min=AllPoints(1,1)+(raw{i,PosCrop_x});
        y_min=AllPoints(1,2)+(raw{i,PosCrop_y});
        x_max=(raw{i,Width});
        y_max=(raw{i,Height});
        Bild_2= imcrop(Bild1,[x_min y_min x_max y_max]);
        imshow(Bild_2)
        
        NeuerName=[Pfad,'Cropped_',raw{i,10}];
        raw{i,12}=['Cropped_',raw{i,10}];
        imwrite(Bild_2,NeuerName)
        close gcf
    end
end
if AuswertungWeitermachen == 1
    xlswrite([Pfad,Name_Exceldatei],raw);
    clc
    close all hidden
else
    clc
    close all hidden
    clearvars
end

