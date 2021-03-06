clearvars;
close all hidden;
[Name_Exceldatei,Pfad] = uigetfile('*.xl*','Zu bearbeitende Exceldatei ausw�hlen');
[num,txt,raw] = xlsread([Pfad,Name_Exceldatei]);

SpalteFoliennummer=15;
SpalteRadlastSoll=4;
SpalteDruckSoll=7;
SpalteNeuerName=12;
SpalteFolienTyp=2;
SpalteReifen=3;
SpalteTemperatur=5;
SpalteRelLuftfeuchte=6;
addpath([cd,'\','Druckausgabe'])
addpath([cd,'\','Unterfunktionen'])
FaktorHelligkeit=12;


%% Convert Color-Scale to pressure contact
for i=1:size(raw,1)
    FilePath=[Pfad,raw{i,SpalteNeuerName}];
    if(exist(FilePath,'file') == 2)  %
        Bild=imread(FilePath);
        Bild(:,:,1)=Bild(:,:,1)-FaktorHelligkeit;
        Bild(:,:,2)=Bild(:,:,2)-FaktorHelligkeit;
        Bild(:,:,3)=Bild(:,:,3)-FaktorHelligkeit;
        
        graypic = double(0.2989*Bild(:,:,1)+0.5870*Bild(:,:,2)+0.1140*Bild(:,:,3));
        Dichte=DichteFunktion(graypic,raw(i,SpalteFolienTyp));
        
        Ergebnisse.(matlab.lang.makeValidName(raw{i,SpalteReifen})).Folien.(matlab.lang.makeValidName(raw{i,SpalteFolienTyp}))= Druckausgabe(raw(i,SpalteFolienTyp),raw{i,SpalteTemperatur},raw{i,SpalteRelLuftfeuchte},Dichte);
        Ergebnisse.(matlab.lang.makeValidName(raw{i,SpalteReifen})).Reifendruck=raw{i,SpalteDruckSoll};
        Ergebnisse.(matlab.lang.makeValidName(raw{i,SpalteReifen})).RadlastSoll=raw{i,SpalteRadlastSoll};
    end
end

Reifen=fieldnames(Ergebnisse);
LengthPixel=25.4/600;
for i=1:size(Reifen,1)
    %% Find which sheet contains the max pressure
    % Find max between 4LW and 3LW
    a_4LW_3LW=max(Ergebnisse.(matlab.lang.makeValidName(Reifen{i,1})).Folien.LLLLW,Ergebnisse.(matlab.lang.makeValidName(Reifen{i,1})).Folien.LLLW);
    
    % Find max between 4LW and 3LW
    % Compare this max to max of 2LW
    % Retain the max between
    a=max(max(max(Ergebnisse.(matlab.lang.makeValidName(Reifen{i,1})).Folien.LLLLW,Ergebnisse.(matlab.lang.makeValidName(Reifen{i,1})).Folien.LLLW),Ergebnisse.(matlab.lang.makeValidName(Reifen{i,1})).Folien.LLW),Ergebnisse.(matlab.lang.makeValidName(Reifen{i,1})).Folien.LW);
    
    Folien=fieldnames(Ergebnisse.(matlab.lang.makeValidName(Reifen{i,1})).Folien);
    
    
    %% Print in temporary pdf files the results for each measurement sheet
    for r=1:4
        PlotDruck=Ergebnisse.(matlab.lang.makeValidName(Reifen{i,1})).Folien.(matlab.lang.makeValidName(Folien{r,1}));
        X_Matrix=0:1:(size(PlotDruck,2)-1);X_Matrix=X_Matrix.*LengthPixel;X_Matrix=repmat(X_Matrix,size(PlotDruck,1),1);
        Y_Matrix=0:1:(size(PlotDruck,1)-1);Y_Matrix=Y_Matrix'.*LengthPixel;Y_Matrix=repmat(Y_Matrix,1,size(PlotDruck,2));
        mesh(X_Matrix,Y_Matrix,PlotDruck)
        xlim([min(min(X_Matrix)) max(max(X_Matrix))])
        ylim([min(min(Y_Matrix)) max(max(Y_Matrix))])
        xlabel('length / mm')
        ylabel('width / mm')
        title([Reifen{i,1}, '; Film: ',(Folien{r,1}),'; Load: ',num2str(Ergebnisse.(matlab.lang.makeValidName(Reifen{i,1})).RadlastSoll) ,' N; Inflation Pressure: ',num2str(Ergebnisse.(matlab.lang.makeValidName(Reifen{i,1})).Reifendruck),' bar']) 
        c = colorbar;
        ylabel(c,'Pressure / MPa');
        daspect([1 1 0.2])
        view(2)
        set(gcf, 'Position', [300, 50, 700, 900]);
        set(gcf,'Units','Inches');
        pos = get(gcf,'Position');
        set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
        print(gcf,'-dpdf','-r600',[num2str(r),'_temp.pdf'])
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
    title([Reifen{i,1},'Film: llllW & LLLW','; Load: ',num2str(Ergebnisse.(matlab.lang.makeValidName(Reifen{i,1})).RadlastSoll) ,' N; Inflation Pressure: ',num2str(Ergebnisse.(matlab.lang.makeValidName(Reifen{i,1})).Reifendruck),' bar'])
    c = colorbar;
    ylabel(c,'Pressure / MPa');
    daspect([1 1 0.2])
    view(2)
    set(gcf, 'Position', [300, 50, 700, 900]);
    set(gcf,'Units','Inches');
    pos = get(gcf,'Position');
    set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(gcf,'-dpdf','-r600',[Reifen{i,1},'_Tot_4LW_3LW.pdf'])
    close all
    
    
    
    
    %% Print final results and append middle results in pdf file
%     a=a/1.5; % Korrekturfaktor, falls ben�tigt
    
    PlotDruck=a;
    X_Matrix=0:1:(size(PlotDruck,2)-1);X_Matrix=X_Matrix.*LengthPixel;X_Matrix=repmat(X_Matrix,size(PlotDruck,1),1);
    Y_Matrix=0:1:(size(PlotDruck,1)-1);Y_Matrix=Y_Matrix'.*LengthPixel;Y_Matrix=repmat(Y_Matrix,1,size(PlotDruck,2));
    mesh(X_Matrix,Y_Matrix,PlotDruck)
    xlim([min(min(X_Matrix)) max(max(X_Matrix))])
    ylim([min(min(Y_Matrix)) max(max(Y_Matrix))])
    xlabel('length / mm')
    ylabel('width / mm')
    title([Reifen{i,1},'; Load: ',num2str(Ergebnisse.(matlab.lang.makeValidName(Reifen{i,1})).RadlastSoll) ,' N; Inflation Pressure: ',num2str(Ergebnisse.(matlab.lang.makeValidName(Reifen{i,1})).Reifendruck),' bar'])
    c = colorbar;
    ylabel(c,'Pressure / MPa');
    daspect([1 1 0.2])
    view(2)
    set(gcf, 'Position', [300, 50, 700, 900]);
    set(gcf,'Units','Inches');
    pos = get(gcf,'Position');
    set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(gcf,'-dpdf','-r600',[Reifen{i,1},'_Tot.pdf'])
    close all
    
    append_pdfs([Reifen{i,1},'.pdf'], [Reifen{i,1},'_Tot_4LW_3LW.pdf'],[Reifen{i,1},'_Tot.pdf'], [num2str(1),'_temp.pdf'],[num2str(2),'_temp.pdf'],[num2str(3),'_temp.pdf'],[num2str(4),'_temp.pdf'])
    delete([Reifen{i,1},'_Tot_4LW_3LW.pdf'],[Reifen{i,1},'_Tot.pdf'],[num2str(1),'_temp.pdf'],[num2str(2),'_temp.pdf'],[num2str(3),'_temp.pdf'],[num2str(4),'_temp.pdf']);
    
    a(isnan(a)==1)=0;
%     csvwrite(Reifen{i,1},single(a))
    
    AnzPixel=size(a,1)*size(a,2)-sum(sum(double(isnan(a))));
    %600dpi
    Area=AnzPixel*(LengthPixel^2);
    Load=Area*nanmean(nanmean(a));
    Ergebnisse.(matlab.lang.makeValidName(Reifen{i,1})).Druck=a;
    Ergebnisse.(matlab.lang.makeValidName(Reifen{i,1})).Radlast=Load;
    
    
    
end

