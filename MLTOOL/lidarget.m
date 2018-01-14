function [Base, Freq, Size] = lidarget(path, Nbr, Option, Rsb);
%
% LIDARGET
%
% SYNTAXE :
%
%   [Base, Freq] = lidarget(path, Nbr, AppTstGen, Rsb);  
%
% Charge une base de signaux Lidar de différentes fréquences.
% les signaux sont labellisés selon leur fréquence (1 pour la 1ere fréquence,
% 2 pour la deuxième, etc.
%
% ARGUMENTS :
%
% path   : répertoire où sont rangés les fichiers Lidar
% Nbr    : nombre de trames générées pour chaque fréquence. Le nombre total
%        de signaux générés est donc égal à Freq*Nbr.
% Option : l'une des trois chaines 'app', 'crv' ou 'gen' :
%          'app' : pour constituer une base d'apprentissage
%          'crv' : une base de cross-validaton
%          'tst' : une base de test          
% Rsb    : Rapport signal sur bruit en décibels (-10, -5, -2, 0 +2, +5, +10).
%
%
% VALEURS DE RETOUR :
%
% Base   : matrice des signaux rangés en ligne, avec les labels
%          en dernier élément de chaque ligne.
%          Pour extraire ces labels de la base et construire un vecteur
%          de cibles, utiliser BASE2TARGET, ou BASE2LABEL pour construire
%          un vecteur de labels.
% Freq :   tableau des fréquences en Hz. La dimension du tableau définit le
%          nombre de classes de signaux et donc le nombre de labels
%          différents générés.
% Size :   longueur des trames extraites (ex: 128 échantillons)
%
%
% COMPATIBILITE :
%
%   Matlab 4.3+
%

% Bruno Gas - UPMC LIS/PARC, <gas@ccr.jussieu.fr>
% Création : 24 mars 2001
% Version : 1.1
% Derniere révision : 
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
    error('[LIDARGET] erreur : Fichiers Lidar introuvables dans le rép. spécifié'); end;

[ans, FileInd] = find(brsb==Rsb); FileInd = ind(FileInd);
if length(FileInd)==0, 
    error(['[LIDARGET] erreur : aucun signal Lidar de RSB égal à ' num2str(Rsb) ' dans la base']); 
else
    Filename = d(FileInd).name;
end;
    

% Extraction des signaux :
%-------------------------
eval(['load ''' path '\' Filename ''' Classe Entree Info;']);

[Size, SigNbr] = size(Entree);          % dimension des signaux
FreqNbr = max(Classe);                  % nombre de fréquences présentes
SigFreqNbr = SigNbr/FreqNbr;            % nombre de trames par fréquence
if (Nbr>SigFreqNbr)
    warning('[LIDARGET] : nombre de signaux demandé trop grand par rapport au nombre disponible');
    disp(['[LIDARGET] : nombre réduit à ' num2str(SigFreqNbr)]);
    Nbr = SigFreqNbr;
end;

ind = reshape(1:SigNbr, SigFreqNbr, FreqNbr)';
ind = ind(:,1:Nbr);
ind = ind(:)';

Labels = Classe(ind)';
Base = Entree(:,ind)';
Base = [Base Labels]; 
eval('Freq = Info(3,ind);'); 
