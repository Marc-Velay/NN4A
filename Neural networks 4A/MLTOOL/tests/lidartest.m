
% tests des signaux Lidar

clear all;
close all;


% extraction des signaux lidar :
%-------------------------------

Fe  = 1;                % fréquences normalisées
Nbr = 2;                % Nbr. de signaux par fréquences
[Base, Freq, Size] = lidarget('C:\Mes documents\Bases\Lidar1',Nbr,'app',10);
[Base, Labels] = base2label(Base);
Base = basenorm(Base,0.8);

SigNbr  = length(Freq); % Nbr. total de signaux chargés
FreqNbr = max(Labels);  % nombre de fréquences différentes
Nbr = SigNbr/FreqNbr;   % Nbr. de signaux par fréquences réellement chargés

disp(['Nombre de fréquences : ' num2str(FreqNbr)]);
disp(['Nombre de signaux par fréquences : ' num2str(Nbr)]);
disp(['Nombre total de signaux (dimension de la base) : ' num2str(SigNbr)]);
disp(['Nombre d''échantillons par signaux : ' num2str(Size)]);

% Visualisation des signaux :
%----------------------------
for i=1:FreqNbr,
    plot(Base(:,i));
    pause;
end;

