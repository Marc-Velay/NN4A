
% tests des signaux Lidar

clear all;
close all;


% extraction des signaux lidar :
%-------------------------------

Fe  = 1;                % fr�quences normalis�es
Nbr = 2;                % Nbr. de signaux par fr�quences
[Base, Freq, Size] = lidarget('C:\Mes documents\Bases\Lidar1',Nbr,'app',10);
[Base, Labels] = base2label(Base);
Base = basenorm(Base,0.8);

SigNbr  = length(Freq); % Nbr. total de signaux charg�s
FreqNbr = max(Labels);  % nombre de fr�quences diff�rentes
Nbr = SigNbr/FreqNbr;   % Nbr. de signaux par fr�quences r�ellement charg�s

disp(['Nombre de fr�quences : ' num2str(FreqNbr)]);
disp(['Nombre de signaux par fr�quences : ' num2str(Nbr)]);
disp(['Nombre total de signaux (dimension de la base) : ' num2str(SigNbr)]);
disp(['Nombre d''�chantillons par signaux : ' num2str(Size)]);

% Visualisation des signaux :
%----------------------------
for i=1:FreqNbr,
    plot(Base(:,i));
    pause;
end;

