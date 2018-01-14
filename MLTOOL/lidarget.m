function [Base, Freq, Size] = lidarget(path, Nbr, Option, Rsb);
%
% LIDARGET
%
% SYNTAXE :
%
%   [Base, Freq] = lidarget(path, Nbr, AppTstGen, Rsb);  
%
% Charge une base de signaux Lidar de diff�rentes fr�quences.
% les signaux sont labellis�s selon leur fr�quence (1 pour la 1ere fr�quence,
% 2 pour la deuxi�me, etc.
%
% ARGUMENTS :
%
% path   : r�pertoire o� sont rang�s les fichiers Lidar
% Nbr    : nombre de trames g�n�r�es pour chaque fr�quence. Le nombre total
%        de signaux g�n�r�s est donc �gal � Freq*Nbr.
% Option : l'une des trois chaines 'app', 'crv' ou 'gen' :
%          'app' : pour constituer une base d'apprentissage
%          'crv' : une base de cross-validaton
%          'tst' : une base de test          
% Rsb    : Rapport signal sur bruit en d�cibels (-10, -5, -2, 0 +2, +5, +10).
%
%
% VALEURS DE RETOUR :
%
% Base   : matrice des signaux rang�s en ligne, avec les labels
%          en dernier �l�ment de chaque ligne.
%          Pour extraire ces labels de la base et construire un vecteur
%          de cibles, utiliser BASE2TARGET, ou BASE2LABEL pour construire
%          un vecteur de labels.
% Freq :   tableau des fr�quences en Hz. La dimension du tableau d�finit le
%          nombre de classes de signaux et donc le nombre de labels
%          diff�rents g�n�r�s.
% Size :   longueur des trames extraites (ex: 128 �chantillons)
%
%
% COMPATIBILITE :
%
%   Matlab 4.3+
%

% Bruno Gas - UPMC LIS/PARC, <gas@ccr.jussieu.fr>
% Cr�ation : 24 mars 2001
% Version : 1.1
% Derniere r�vision : 
% - B.Gas (26/03/2001) changement de nom, GETLIDARSIG devient LIDARGET


% Control arguments :
%--------------------
if nargin~=4, error('[LIDARGET] usage : [Base, Freq] = getlidarsig(path, Nbr, Option, Rsb)'); end;

if exist(path,'dir')~=7
    error('[LIDARGET] erreur : argument <path> incorrecte (chemin introuvable)'); end;

switch Option
case 'app',
    TypeBase = 'App';
case 'crv',
    TypeBase = 'Crv';
case 'tst',
    TypeBase = 'Tst';
otherwise,
    error('[LIDARGET] erreur : argument <Option> incorrecte (''app'', ''crv'' ou ''tst'') '); 
end;

% Recherche des fichiers Lidar :
%-------------------------------
d           = dir(path);
FileNbr     = length(d);
Filename    = ['Base' TypeBase];    % nom des bases
offset      = length(Filename)+2;
ind = []; brsb = [];                % indices et rsb des fichiers
for i=1:FileNbr, 
    if length(findstr(d(i).name,Filename))==1,
        fin = findstr(d(i).name,'.mat');
        if length(fin)~=0
            name = d(i).name(offset:fin-1);
            lg = length(name);  
            if name(1)=='m', 
                brsb = [brsb -str2num(name(2:lg))];
            else 
                brsb = [brsb str2num(name)]; 
            end;
            ind = [ind i];            
        end;     
    end;
end;

FileNbr = length(brsb);
if FileNbr==0, 
    error('[LIDARGET] erreur : Fichiers Lidar introuvables dans le r�p. sp�cifi�'); end;

[ans, FileInd] = find(brsb==Rsb); FileInd = ind(FileInd);
if length(FileInd)==0, 
    error(['[LIDARGET] erreur : aucun signal Lidar de RSB �gal � ' num2str(Rsb) ' dans la base']); 
else
    Filename = d(FileInd).name;
end;
    

% Extraction des signaux :
%-------------------------
eval(['load ''' path '\' Filename ''' Classe Entree Info;']);

[Size, SigNbr] = size(Entree);          % dimension des signaux
FreqNbr = max(Classe);                  % nombre de fr�quences pr�sentes
SigFreqNbr = SigNbr/FreqNbr;            % nombre de trames par fr�quence
if (Nbr>SigFreqNbr)
    warning('[LIDARGET] : nombre de signaux demand� trop grand par rapport au nombre disponible');
    disp(['[LIDARGET] : nombre r�duit � ' num2str(SigFreqNbr)]);
    Nbr = SigFreqNbr;
end;

ind = reshape(1:SigNbr, SigFreqNbr, FreqNbr)';
ind = ind(:,1:Nbr);
ind = ind(:)';

Labels = Classe(ind)';
Base = Entree(:,ind)';
Base = [Base Labels]; 
eval('Freq = Info(3,ind);'); 
