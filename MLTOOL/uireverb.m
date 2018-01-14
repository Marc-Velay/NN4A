
% uireverb


clear all;
close all;

demoterm = 0;
while demoterm==0
    choix = menu('DémoRéverb',...
   	'Tester une réverbération',...
   	'Visualiser la réponse impulsionnelle',...
   	'Quitter');

    if choix==1       
        [filename, pathname] = uigetfile('*.wav','Sélectionnez un fichier WAV');
        [Signal, SampleRate, NBits] = wavread([pathname filename]);


        default={'16','0.1'};
        prompt={'Délais de réverbération (>= 1) : ','Gain : '};
        titre = 'Paramètres de la réverbération';
        answer=inputdlg(prompt,titre,1,default);
        if isempty(answer)
            errordlg('Pas de réponse : valeurs par défaut!',' ');
            delay = 16;
            gain = 0.1;   
        else            
            delay = str2num(char(answer(1)));
            gain = str2num(char(answer(2)));
        end;
        
        wavplay(Signal, SampleRate);
        RVSignal = reverb(Signal', delay, gain)';
        wavplay(RVSignal, SampleRate);            
       
    elseif choix==2
        reponse = reverb;
        plot(reponse);        
    elseif choix==3
        demoterm=1;
    end;
end;
        
close all;
clear all;















