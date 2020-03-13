clearvars;
close all hidden;
answer = questdlg('Excel or CSV File?', ...
	'','Excel','CSV','Cancel','Cancel');
% Handle response
switch answer
    case 'Excel'
        read_CSV_File=false;
        offset=2;
    case 'CSV'
        read_CSV_File=true;
        offset=0;
    case 'Cancel'
        errordlg('Keine Datei ausgew�hlt, breche ab')
        error('Keine Datei ausgew�hlt, breche ab')
end
if read_CSV_File==true
    [filename, filepath] = uigetfile('*.csv', 'Choose CSV File');
else
    [filename, filepath] = uigetfile('*.xl*', 'Zu bearbeitende Exceldatei auswaehlen');
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


cd(filepath)
SpalteFahrbahn=1;
SpalteFolienTyp=2;
SpalteReifen=3;
SpalteRadlastSoll=4;
SpalteTemperatur=5;
SpalteRelLuftfeuchte=6;
SpalteDruckSoll=7;
SpalteCamberAngle=8;


SpalteFoliennummer=10;
SpalteNeuerName=12;
SpalteFolderPath=17;
for ii=1+offset:(size(num,1)+offset)
    newPath=fullfile('Original',[raw{ii,SpalteReifen},raw{ii,SpalteFahrbahn},num2str(raw{ii,SpalteDruckSoll}),'bar',num2str(raw{ii,SpalteRadlastSoll}),'N',num2str(raw{ii,SpalteCamberAngle}),'deg']);
    raw{ii,SpalteFolderPath}=newPath;
    mkdir(newPath);
 movefile(fullfile(filepath,[num2str(raw{ii,SpalteFoliennummer}),'.jpg']),newPath);
end
if read_CSV_File==true
    writecell(raw,[filepath,'executed_',filename]);
else
    xlswrite([filepath,filename],raw);
end
 
close all hidden
clearvars