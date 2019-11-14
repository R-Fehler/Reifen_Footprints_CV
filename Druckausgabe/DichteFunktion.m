function Dichte=DichteFunktion(Graypic,Folientyp)

if strcmp(Folientyp,'LLLLW')
    
    load('Kalibrierung_LLLLW.mat')
    
    Dichte=interp1(Mittelwerte_Farbdichte,Dichtewerte_Farbdichte,Graypic,'linear','extrap');
    
elseif strcmp(Folientyp,'LLLW')
    
    load('Kalibrierung_LLLW.mat')
    Dichte=interp1(Mittelwerte_Farbdichte,Dichtewerte_Farbdichte,Graypic,'linear','extrap');
    
elseif strcmp(Folientyp,'LLW')
    
    load('Kalibrierung_LLW.mat')
    Dichte=interp1(Mittelwerte_Farbdichte,Dichtewerte_Farbdichte,Graypic,'linear','extrap');
    
elseif strcmp(Folientyp,'LW')
    
    load('Kalibrierung_LW.mat')
    Dichte=interp1(Mittelwerte_Farbdichte,Dichtewerte_Farbdichte,Graypic,'linear','extrap');
    
end
