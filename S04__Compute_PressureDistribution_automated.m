clearvars;
close all hidden;
set(0,'defaulttextinterpreter','none');
[Name_Exceldatei,Pfad] = uigetfile('*.xl*','Zu bearbeitende Exceldatei ausw�hlen');
[num,txt,raw] = xlsread([Pfad,Name_Exceldatei]);

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

addpath([cd,'\','Druckausgabe'])
addpath([cd,'\','Unterfunktionen'])

FaktorHelligkeit=12;


%% Convert Color-Scale to pressure contact
for ii=3:(size(num,1)+2)
    FilePath=fullfile(raw{ii,SpalteNeuerName});
    FilePath
    if(exist(FilePath,'file') == 2)  %
        Bild=imread(FilePath);
        Bild(:,:,1)=Bild(:,:,1)-FaktorHelligkeit;
        Bild(:,:,2)=Bild(:,:,2)-FaktorHelligkeit;
        Bild(:,:,3)=Bild(:,:,3)-FaktorHelligkeit;
        
        graypic = double(0.2989*Bild(:,:,1)+0.5870*Bild(:,:,2)+0.1140*Bild(:,:,3));
        Dichte=DichteFunktion(graypic,raw(ii,SpalteFolienTyp));
        FahrbahnName=matlab.lang.makeValidName(raw{ii,SpalteFahrbahn});
        ReifenName=matlab.lang.makeValidName(raw{ii,SpalteReifen});
        RadLastName=matlab.lang.makeValidName(num2str(raw{ii,SpalteRadlastSoll}));
        DruckSollName=matlab.lang.makeValidName(num2str(raw{ii,SpalteDruckSoll}));
        CamberAngleName=matlab.lang.makeValidName(num2str(raw{ii,SpalteCamberAngle}));
        FolienTypName=matlab.lang.makeValidName(raw{ii,SpalteFolienTyp});
        CombinedName=matlab.lang.makeValidName(strcat(ReifenName,FahrbahnName,RadLastName,DruckSollName,CamberAngleName));
        Ergebnisse.(CombinedName).Folien.(FolienTypName)= Druckausgabe(raw(ii,SpalteFolienTyp),raw{ii,SpalteTemperatur},raw{ii,SpalteRelLuftfeuchte},Dichte);
        Ergebnisse.(CombinedName).Reifendruck=raw{ii,SpalteDruckSoll};
        Ergebnisse.(CombinedName).RadlastSoll=raw{ii,SpalteRadlastSoll};
    end
end

Reifen=fieldnames(Ergebnisse);
LengthPixel=25.4/600;

for ii=3:(size(num,1)+2)
 newPath=fullfile(Pfad,'Original',[raw{ii,SpalteReifen},raw{ii,SpalteFahrbahn},num2str(raw{ii,SpalteDruckSoll}),'bar',num2str(raw{ii,SpalteRadlastSoll}),'N',num2str(raw{ii,SpalteCamberAngle}),'deg']);
 ListofDirs{ii-2}=newPath; 
end
ListofDirs=convertCharsToStrings(ListofDirs);
ListofDirs=unique(ListofDirs,'stable');

for ii=1:size(Reifen,1)
    Reifen{ii,1}
    %% Find which sheet contains the max pressure
    % Find max between 4LW and 3LW
    a_4LW_3LW=max(Ergebnisse.(matlab.lang.makeValidName(Reifen{ii,1})).Folien.LLLLW,Ergebnisse.(matlab.lang.makeValidName(Reifen{ii,1})).Folien.LLLW);
    
    % Find max between 4LW and 3LW
    % Compare this max to max of 2LW
    % Retain the max between
    a=max(max(max(Ergebnisse.(matlab.lang.makeValidName(Reifen{ii,1})).Folien.LLLLW,Ergebnisse.(matlab.lang.makeValidName(Reifen{ii,1})).Folien.LLLW),Ergebnisse.(matlab.lang.makeValidName(Reifen{ii,1})).Folien.LLW),Ergebnisse.(matlab.lang.makeValidName(Reifen{ii,1})).Folien.LW);
    
    Folien=fieldnames(Ergebnisse.(matlab.lang.makeValidName(Reifen{ii,1})).Folien);
    
    
    %% Print in temporary pdf files the results for each measurement sheet
    for r=1:4
        PlotDruck=Ergebnisse.(matlab.lang.makeValidName(Reifen{ii,1})).Folien.(matlab.lang.makeValidName(Folien{r,1}));
        X_Matrix=0:1:(size(PlotDruck,2)-1);X_Matrix=X_Matrix.*LengthPixel;X_Matrix=repmat(X_Matrix,size(PlotDruck,1),1);
        Y_Matrix=0:1:(size(PlotDruck,1)-1);Y_Matrix=Y_Matrix'.*LengthPixel;Y_Matrix=repmat(Y_Matrix,1,size(PlotDruck,2));
        mesh(X_Matrix,Y_Matrix,PlotDruck)
        xlim([min(min(X_Matrix)) max(max(X_Matrix))])
        ylim([min(min(Y_Matrix)) max(max(Y_Matrix))])
        xlabel('length / mm')
        ylabel('width / mm')
        title([Reifen{ii,1},sprintf('\n'),' Film: ',(Folien{r,1}),'; Load: ',num2str(Ergebnisse.(matlab.lang.makeValidName(Reifen{ii,1})).RadlastSoll) ,' N; Inflation Pressure: ',num2str(Ergebnisse.(matlab.lang.makeValidName(Reifen{ii,1})).Reifendruck),' bar']) 
        c = colorbar;
        ylabel(c,'Pressure / MPa');
        daspect([1 1 0.2])
        % hier wurde das Bild gespiegelt. elevation auf -90 hat es gel�st
        view(0,-90)
        set(gcf, 'Position', [300, 50, 700, 900]);
        set(gcf,'Units','Inches');
        pos = get(gcf,'Position');
        set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
        print(gcf,'-dpdf','-r600',fullfile(ListofDirs(ii),[num2str(r),'_temp.pdf']))
        close all
    end
    %% Print results for max between 4LW and 3LW (highest sensitivity) 
    PlotDruck=a_4LW_3LW;
    X_Matrix=0:1:(size(PlotDruck,2)-1);X_Matrix=X_Matrix.*LengthPixel;X_Matrix=repmat(X_Matrix,size(PlotDruck,1),1);
    Y_Matrix=0:1:(size(PlotDruck,1)-1);Y_Matrix=Y_Matrix'.*LengthPixel;Y_Matrix=repmat(Y_Matrix,1,size(PlotDruck,2));
    mesh(X_Matrix,Y_Matrix,PlotDruck)
    xlim([min(min(X_Matrix)) max(max(X_Matrix))])
    ylim([min(min(Y_Matrix)) max(max(Y_Matrix))])
    xlabel('length / mm')
    ylabel('width / mm')
    title([Reifen{ii,1},sprintf('\n'),' Film: llllW & LLLW','; Load: ',num2str(Ergebnisse.(matlab.lang.makeValidName(Reifen{ii,1})).RadlastSoll) ,' N; Inflation Pressure: ',num2str(Ergebnisse.(matlab.lang.makeValidName(Reifen{ii,1})).Reifendruck),' bar'])
    c = colorbar;
    ylabel(c,'Pressure / MPa');
    daspect([1 1 0.2])
    view(0,-90)
    set(gcf, 'Position', [300, 50, 700, 900]);
    set(gcf,'Units','Inches');
    pos = get(gcf,'Position');
    set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(gcf,'-dpdf','-r600',fullfile(ListofDirs(ii),[Reifen{ii,1},'_Tot_4LW_3LW.pdf']))
    close all
    
    
    
    
    %% Print final results and append middle results in pdf file
%     a=a/1.5; % Korrekturfaktor, falls benoetigt auskommentieren
    
    PlotDruck=a;
    X_Matrix=0:1:(size(PlotDruck,2)-1);X_Matrix=X_Matrix.*LengthPixel;X_Matrix=repmat(X_Matrix,size(PlotDruck,1),1);
    Y_Matrix=0:1:(size(PlotDruck,1)-1);Y_Matrix=Y_Matrix'.*LengthPixel;Y_Matrix=repmat(Y_Matrix,1,size(PlotDruck,2));
    mesh(X_Matrix,Y_Matrix,PlotDruck)
    xlim([min(min(X_Matrix)) max(max(X_Matrix))])
    ylim([min(min(Y_Matrix)) max(max(Y_Matrix))])
    xlabel('length / mm')
    ylabel('width / mm')
    
    c = colorbar;
    ylabel(c,'Pressure / MPa');
    daspect([1 1 0.2])
    view(0,-90)
    set(gcf, 'Position', [300, 50, 700, 900]);
    set(gcf,'Units','Inches');
    pos = get(gcf,'Position');
    
        a(isnan(a)==1)=0;

%% Druckdaten Speichern %%%%%%%
%     csvwrite(Reifen{ii,1},single(a))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    AnzPixel=size(a,1)*size(a,2)-sum(sum(double(isnan(a))));
    %600dpi
    
    Area=AnzPixel*(LengthPixel^2)
    Load=Area*nanmean(nanmean(a))
        
    title([Reifen{ii,1},sprintf('\n'),' Load: ',num2str(Ergebnisse.(matlab.lang.makeValidName(Reifen{ii,1})).RadlastSoll) ,' N; Inflation Pressure: ',num2str(Ergebnisse.(matlab.lang.makeValidName(Reifen{ii,1})).Reifendruck),' bar',sprintf('\n Computed: Load: %f N  Area: %f mm^2',Load,Area)])
    
    set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(gcf,'-dpdf','-r600',fullfile(ListofDirs(ii),[Reifen{ii,1},'_Tot.pdf']))
    close all
    
    append_pdfs(fullfile(ListofDirs(ii),[Reifen{ii,1},'.pdf']), fullfile(ListofDirs(ii),[Reifen{ii,1},'_Tot_4LW_3LW.pdf']),fullfile(ListofDirs(ii),[Reifen{ii,1},'_Tot.pdf']), fullfile(ListofDirs(ii),[num2str(1),'_temp.pdf']),fullfile(ListofDirs(ii),[num2str(2),'_temp.pdf']),fullfile(ListofDirs(ii),[num2str(3),'_temp.pdf']),fullfile(ListofDirs(ii),[num2str(4),'_temp.pdf']));
    delete(fullfile(ListofDirs(ii),[Reifen{ii,1},'_Tot_4LW_3LW.pdf']),fullfile(ListofDirs(ii),[Reifen{ii,1},'_Tot.pdf']),fullfile(ListofDirs(ii),[num2str(1),'_temp.pdf']),fullfile(ListofDirs(ii),[num2str(2),'_temp.pdf']),fullfile(ListofDirs(ii),[num2str(3),'_temp.pdf']),fullfile(ListofDirs(ii),[num2str(4),'_temp.pdf']));
    

   
    Ergebnisse.(matlab.lang.makeValidName(Reifen{ii,1})).Druck=a;
    Ergebnisse.(matlab.lang.makeValidName(Reifen{ii,1})).Radlast=Load;
    fileID = fopen(fullfile(ListofDirs(ii),[Reifen{ii,1},'.txt']),'w');
    fprintf(fileID,'Load: %f N \n Area: %f mm^2 \n',Load,Area);
    fclose(fileID);
    save(fullfile(Pfad,Reifen{ii,1}),'Ergebnisse','a_4LW_3LW','a');
end

