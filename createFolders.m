clearvars;
close all hidden;
[Name_Exceldatei,Pfad] = uigetfile('*.xl*','Zu bearbeitende Exceldatei ausw�hlen');
[num,txt,raw] = xlsread([Pfad,Name_Exceldatei]);
cd(Pfad)
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

for ii=3:(size(num,1)+2)
    newPath=fullfile('Original',[raw{ii,SpalteReifen},raw{ii,SpalteFahrbahn},num2str(raw{ii,SpalteDruckSoll}),'bar',num2str(raw{ii,SpalteRadlastSoll}),'N',num2str(raw{ii,SpalteCamberAngle}),'deg']);
    mkdir(newPath);
 movefile(fullfile(Pfad,[num2str(raw{ii,SpalteFoliennummer}),'.jpg']),newPath);
end