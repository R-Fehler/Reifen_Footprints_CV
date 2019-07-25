%Ermittlung des Drucks über die Farbdichte
%Typ: 'LLLLW','LLLW','LLW','LW'
%Temperatur=T [°C] von 0°C bis 35°C möglich
%Luftfeuchtigkeit=L [%]
%Dichte mit der "Funktion Farbdichtenermittlung_final" ermittelt
%Input:Typ,T,L,Dichte
%Output:Druck


function [Druck] =Druckausgabe(Typ,T,L,Dichte)


if strcmp(Typ,'LLLLW')
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 4LW %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Geraden Temperatur-Luftfeuchtigkeit
    
    e = -(4/35)*T+42;
    d = -(4/35)*T+56;
    c = -(4/35)*T+66;
    b = -(4/35)*T+72;
    
    
    %Entscheidung, welcher Graph zur Druckerfassung herangezogen werden muss
    %Auslesen des Drucks [MPa] mit Hilfe der Farbdichte
    
    if (e>=L) && (L>0)&&(T<=35) && (T>0)
        %Graph E
        load('LLLLW_Kurve_E')
        
        
        for i =1:length (Dichte(:,1))
            for j=1:length (Dichte(1,:))
                
                if Dichte(i,j)>Dichtewerte_Druckausgabe(1,end)
                    Dichte(i,j)=Dichtewerte_Druckausgabe(1,end);
                elseif Dichte(i,j)<Dichtewerte_Druckausgabe(1,1)
                    Dichte(i,j)=NaN;
                end
            end
        end
        
        Druck=interp1(Dichtewerte_Druckausgabe,Druckwerte,Dichte);
        
    elseif (e<L)&&(L<=d)&&(T<=35) && (T>0)
        %Graph D
        load('LLLLW_Kurve_D')
        
        for i =1:length (Dichte(:,1))
            for j=1:length (Dichte(1,:))
                if Dichte(i,j)>Dichtewerte_Druckausgabe(1,end)
                    Dichte(i,j)=Dichtewerte_Druckausgabe(1,end);
                elseif Dichte(i,j)<Dichtewerte_Druckausgabe(1,1)
                    Dichte(i,j)=NaN;
                end
            end
        end
        
        Druck=interp1(Dichtewerte_Druckausgabe,Druckwerte,Dichte);
        
    elseif (d<L)&&(L<=c)&&(T<=35) && (T>0)
        %Graph C
        load('LLLLW_Kurve_C')
        
        for i =1:length (Dichte(:,1))
            for j=1:length (Dichte(1,:))
                if Dichte(i,j)>Dichtewerte_Druckausgabe(1,end)
                    Dichte(i,j)=Dichtewerte_Druckausgabe(1,end);
                elseif Dichte(i,j)<Dichtewerte_Druckausgabe(1,1)
                    Dichte(i,j)=NaN;
                end
            end
        end
        
        Druck=interp1(Dichtewerte_Druckausgabe,Druckwerte,Dichte);
        
    elseif (c<L)&&(L<=b)&&(T<=35) && (T>0)
        %Graph B
        load('LLLLW_Kurve_B')
        
        for i =1:length (Dichte(:,1))
            for j=1:length (Dichte(1,:))
                if Dichte(i,j)>Dichtewerte_Druckausgabe(1,end)
                    Dichte(i,j)=Dichtewerte_Druckausgabe(1,end);
                elseif Dichte(i,j)<Dichtewerte_Druckausgabe(1,1)
                    Dichte(i,j)=NaN;
                end
            end
        end
        
        Druck=interp1(Dichtewerte_Druckausgabe,Druckwerte,Dichte);
        
    elseif (b<L)&&(L<=100)&&(T<=35) && (T>0)
        %Graph A
        load('LLLLW_Kurve_A')
        
        for i =1:length (Dichte(:,1))
            for j=1:length (Dichte(1,:))
                if Dichte(i,j)>Dichtewerte_Druckausgabe(1,end)
                    Dichte(i,j)=Dichtewerte_Druckausgabe(1,end);
                elseif Dichte(i,j)<Dichtewerte_Druckausgabe(1,1)
                    Dichte(i,j)=NaN;
                end
            end
        end
        
        Druck=interp1(Dichtewerte_Druckausgabe,Druckwerte,Dichte);
        
        
    else (L>100)||(L<0) || (T>35) && (T<0)
        disp('ungültige Eingabe');
    end
    %disp(Druck);
    %clear Druck
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
elseif strcmp(Typ,'LLLW')
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LLLW %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Geraden Temperatur-Luftfeuchtigkeit
    
    e = -(2/7)*T+42;
    d = -(2/7)*T+60;
    c = -(18/32)*T+76;
    b = -(22/32)*T+92;
    
    
    %Entscheidung, welcher Graph zur Druckerfassung herangezogen werden muss
    %Auslesen des Drucks [MPa] mit Hilfe der Farbdichte
    
    if (e>=L) && (L>0)&&(T<=35) && (T>0)
        %Graph E
        load('LLLW_Kurve_E')
        
        for i =1:length (Dichte(:,1))
            for j=1:length (Dichte(1,:))
                if Dichte(i,j)>Dichtewerte_Druckausgabe(1,end)
                    Dichte(i,j)=Dichtewerte_Druckausgabe(1,end);
                elseif Dichte(i,j)<Dichtewerte_Druckausgabe(1,1)
                    Dichte(i,j)=NaN;
                end
            end
        end
        
        Druck = interp1(Dichtewerte_Druckausgabe,Druckwerte,Dichte);
        
    elseif (e<L)&&(L<=d)&&(T<=35) && (T>0)
        %Graph D
        load('LLLW_Kurve_D')
        
        for i =1:length (Dichte(:,1))
            for j=1:length (Dichte(1,:))
                if Dichte(i,j)>Dichtewerte_Druckausgabe(1,end)
                    Dichte(i,j)=Dichtewerte_Druckausgabe(1,end);
                elseif Dichte(i,j)<Dichtewerte_Druckausgabe(1,1)
                    Dichte(i,j)=NaN;
                end
            end
        end
        
        Druck = interp1(Dichtewerte_Druckausgabe,Druckwerte,Dichte);
        
    elseif (d<L)&&(L<=c)&&(T<=35) && (T>0)
        %Graph C
        load('LLLW_Kurve_C')
        
        for i =1:length (Dichte(:,1))
            for j=1:length (Dichte(1,:))
                if Dichte(i,j)>Dichtewerte_Druckausgabe(1,end)
                    Dichte(i,j)=Dichtewerte_Druckausgabe(1,end);
                elseif Dichte(i,j)<Dichtewerte_Druckausgabe(1,1)
                    Dichte(i,j)=NaN;
                end
            end
        end
        
        Druck = interp1(Dichtewerte_Druckausgabe,Druckwerte,Dichte);
        
    elseif (c<L)&&(L<=b)&&(T<=35) && (T>0)
        %Graph B
        load('LLLW_Kurve_B')
        
        for i =1:length (Dichte(:,1))
            for j=1:length (Dichte(1,:))
                if Dichte(i,j)>Dichtewerte_Druckausgabe(1,end)
                    Dichte(i,j)=Dichtewerte_Druckausgabe(1,end);
                elseif Dichte(i,j)<Dichtewerte_Druckausgabe(1,1)
                    Dichte(i,j)=NaN;
                end
            end
        end
        
        Druck = interp1(Dichtewerte_Druckausgabe,Druckwerte,Dichte);
        
    elseif (b<L)&&(L<=100)&&(T<=35) && (T>0)
        %Graph A
        load('LLLW_Kurve_A')
        
        for i =1:length (Dichte(:,1))
            for j=1:length (Dichte(1,:))
                if Dichte(i,j)>Dichtewerte_Druckausgabe(1,end)
                    Dichte(i,j)=Dichtewerte_Druckausgabe(1,end);
                elseif Dichte(i,j)<Dichtewerte_Druckausgabe(1,1)
                    Dichte(i,j)=NaN;
                end
            end
        end
        
        Druck = interp1(Dichtewerte_Druckausgabe,Druckwerte,Dichte);
        
    else (L>100)||(L<0) || (T>35) && (T<0)
        disp('ungültige Eingabe');
    end
    %disp(Druck);
    %clear Druck
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
elseif strcmp(Typ,'LLW')
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LLW %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Geraden Temperatur-Luftfeuchtigkeit
    
    d = -(4/7)*T+58;                                                           %Benennung erfolgt von unten nach oben
    c = -(36/35)*T+84;
    b = -(4/5)*T+96;
    
    
    %Entscheidung, welcher Graph zur Druckerfassung herangezogen werden muss
    %Auslesen des Drucks [MPa] mit Hilfe der Farbdichte
    
    
    if (d>=L) && (L>0)&&(T<=35) && (T>0)
        %Graph D
        load('LLW_Kurve_D')
        
        for i =1:length (Dichte(:,1))
            for j=1:length (Dichte(1,:))
                if Dichte(i,j)>Dichtewerte_Druckausgabe(1,end)
                    Dichte(i,j)=Dichtewerte_Druckausgabe(1,end);
                elseif Dichte(i,j)<Dichtewerte_Druckausgabe(1,1)
                    Dichte(i,j)=NaN;
                end
            end
        end
        
        Druck = interp1(Dichtewerte_Druckausgabe,Druckwerte,Dichte);
        
    elseif (d<L)&&(L<=c)&&(T<=35) && (T>0)
        %Graph C
        load('LLW_Kurve_C')
        
        for i =1:length (Dichte(:,1))
            for j=1:length (Dichte(1,:))
                if Dichte(i,j)>Dichtewerte_Druckausgabe(1,end)
                    Dichte(i,j)=Dichtewerte_Druckausgabe(1,end);
                elseif Dichte(i,j)<Dichtewerte_Druckausgabe(1,1)
                    Dichte(i,j)=NaN;
                end
            end
        end
        
        Druck = interp1(Dichtewerte_Druckausgabe,Druckwerte,Dichte);
        
    elseif (c<L)&&(L<=b)&&(T<=35) && (T>0)
        %Graph B
        load('LLW_Kurve_B')
        
        for i =1:length (Dichte(:,1))
            for j=1:length (Dichte(1,:))
                if Dichte(i,j)>Dichtewerte_Druckausgabe(1,end)
                    Dichte(i,j)=Dichtewerte_Druckausgabe(1,end);
                elseif Dichte(i,j)<Dichtewerte_Druckausgabe(1,1)
                    Dichte(i,j)=NaN;
                end
            end
        end
        
        Druck = interp1(Dichtewerte_Druckausgabe,Druckwerte,Dichte);
        
    elseif (b<L)&&(L<=100)&&(T<=35) && (T>0)
        %Graph A
        load('LLW_Kurve_A')
        
        for i =1:length (Dichte(:,1))
            for j=1:length (Dichte(1,:))
                if Dichte(i,j)>Dichtewerte_Druckausgabe(1,end)
                    Dichte(i,j)=Dichtewerte_Druckausgabe(1,end);
                elseif Dichte(i,j)<Dichtewerte_Druckausgabe(1,1)
                    Dichte(i,j)=NaN;
                end
            end
        end
        
        Druck = interp1(Dichtewerte_Druckausgabe,Druckwerte,Dichte);
        
    else (L>100)||(L<0) || (T>35) && (T<0)
        disp('ungültige Eingabe');
    end
    %disp(Druck);
    %clear Druck
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
elseif strcmp(Typ,'LW')
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LW %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Geraden Temperatur-Luftfeuchtigkeit
    
    d = -(18/35)*T+50;                                                         %Benennung erfolgt von unten nach oben
    c = -(19/35)*T+70;
    b = -(17/35)*T+90;
    
    
    %Entscheidung, welcher Graph zur Druckerfassung herangezogen werden muss
    %Auslesen des Drucks [MPa] mit Hilfe der Farbdichte
    
    
    if (d>=L) && (L>0)&&(T<=35) && (T>0)
        %Graph D
        load('LW_Kurve_D')
        
        for i =1:length (Dichte(:,1))
            for j=1:length (Dichte(1,:))
                if Dichte(i,j)>Dichtewerte_Druckausgabe(1,end)
                    Dichte(i,j)=Dichtewerte_Druckausgabe(1,end);
                elseif Dichte(i,j)<Dichtewerte_Druckausgabe(1,1)
                    Dichte(i,j)=NaN;
                end
            end
        end
        
        Druck = interp1(Dichtewerte_Druckausgabe,Druckwerte,Dichte);
        
    elseif (d<L)&&(L<=c)&&(T<=35) && (T>0)
        %Graph C
        load('LW_Kurve_C')
        
        for i =1:length (Dichte(:,1))
            for j=1:length (Dichte(1,:))
                if Dichte(i,j)>Dichtewerte_Druckausgabe(1,end)
                    Dichte(i,j)=Dichtewerte_Druckausgabe(1,end);
                elseif Dichte(i,j)<Dichtewerte_Druckausgabe(1,1)
                    Dichte(i,j)=NaN;
                end
            end
        end
        
        Druck = interp1(Dichtewerte_Druckausgabe,Druckwerte,Dichte);
        
    elseif (c<L)&&(L<=b)&&(T<=35) && (T>0)
        %Graph B
        load('LW_Kurve_B')
        
        for i =1:length (Dichte(:,1))
            for j=1:length (Dichte(1,:))
                if Dichte(i,j)>Dichtewerte_Druckausgabe(1,end)
                    Dichte(i,j)=Dichtewerte_Druckausgabe(1,end);
                elseif Dichte(i,j)<Dichtewerte_Druckausgabe(1,1)
                    Dichte(i,j)=NaN;
                end
            end
        end
        
        Druck = interp1(Dichtewerte_Druckausgabe,Druckwerte,Dichte);
        
    elseif (b<L)&&(L<=100)&&(T<=35) && (T>0)
        %Graph A
        load('LW_Kurve_A')
        
        for i =1:length (Dichte(:,1))
            for j=1:length (Dichte(1,:))
                if Dichte(i,j)>Dichtewerte_Druckausgabe(1,end)
                    Dichte(i,j)=Dichtewerte_Druckausgabe(1,end);
                elseif Dichte(i,j)<Dichtewerte_Druckausgabe(1,1)
                    Dichte(i,j)=NaN;
                end
            end
        end
        
        Druck = interp1(Dichtewerte_Druckausgabe,Druckwerte,Dichte);
        
    else (L>100)||(L<0) || (T>35) && (T<0)
        disp('ungültige Eingabe');
    end
    %disp(Druck);
    %clear Druck;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
else
    disp('Ungültige Eingabe');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
end

end

