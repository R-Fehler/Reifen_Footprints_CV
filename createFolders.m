clearvars;
close all hidden;
[Name_Exceldatei,Pfad] = uigetfile('*.xl*','Zu bearbeitende Exceldatei auswählen');
[num,txt,raw] = xlsread([Pfad,Name_Exceldatei]);
cd(Pfad)
SpalteFoliennummer=10;
SpalteRadlastSoll=4;
SpalteDruckSoll=7;
SpalteNeuerName=12;
SpalteFolienTyp=2;
SpalteReifen=3;
SpalteFahrbahn=1;
SpalteTemperatur=5;
SpalteRelLuftfeuchte=6;

for ii=3:size(raw,1)
 newPath=[raw{ii,SpalteReifen},raw{ii,SpalteFahrbahn},num2str(raw{ii,SpalteDruckSoll})];
 mkdir(newPath);
 movefile(fullfile(Pfad,raw{ii,SpalteFoliennummer}),newPath);
end