function [Trames, CutSignal, Signal] = speechget2(filename, framesize, offset ,seuil);
%
% SPEECHGET2
%
% SYNTAXE :
%
% [Trames, CutSignal, Signal] = SPEECHGET2([filename [, framesize, offset [, seuil]]])
%
% Extrait des signaux de mots à partir du fichier de parole
% au format wav donné en argument avec élimination des zones de
% silence par seuillage.Les mots sont collés les uns à la suite des autres.
% Les signaux extraits sont normalisés (entre -1 et +1) puis subdivisés en trames 
% successives de longueur 'framesize'
% avec un entrelacement 'offset' et rangés en ligne dans le tableau <Trames>
%
% ARGUMENTS : [OPTIONNELS]
%
% filename 	: nom du fichier à ouvrir
% framesize	: taille des trames en nombre d'échantillons
% offset    : facteur d'entrelacement en nombre d'échantillons
% seuil     : seuil de détection du signal de parole (0 à 1)
%             0 : le signal dont la puissance est supérieure à la puissance
%                 minimale en zone de silence est détecté
%             1 : seuil maximal, aucun signal détecté
% VALEURS DE RETOUR :
%
% Trames 	: matrice des trames de signaux rangés en ligne
% Signal 	: le signal entier extrait du fichier
% CutSignal : le signal correspondant aux trames sélectionnées
%
% VOIR AUSSI :
%
%  UISPEECHGET
%
% COMPATIBILITE : 
%   >= matlab 5.1
%

% Bruno Gas - LIS/P&C UPMC
% Création : juin 2002
% version : 1.0
% Derniere révision : 
%  - modifs antérieures : voir SPEECHGET
%  - B. Gas (14/06/2002): extrait les mots d'une phrase (utiliser un seuil très petit:0.005)

if nargin==0
    filename = input('Nom complet du fichier .wav à ouvrir = ','s');
    framesize = input('Longueur des trames (256) = ');
    offset = input('facteur d''entrelacement (128) = ');
    seuil = input('seuil de détection (0->1 (0=détection maximale)) = ');
elseif nargin==1
    framesize = input('Longueur des trames (256) = ');
    offset = input('facteur d''entrelacement (128) = ');
    seuil = input('seuil de détection (0 à 1 (0=détection maximale)) = ');
elseif nargin==3
    seuil = input('seuil de détection (0 à 1 (0=détection maximale)) = ');
elseif nargin ~=4
    error('[SPEECHGET] usage : [Trames, CutSignal, Signal] = SPEECHGET([filename [,framesize, offset [,seuil]])');   
end;

if seuil<0 | seuil>1, error('[SPEECHGET] erreur : l''argument <seuil> doit etre compris entre 0 et 1'); end;

Base = 0;

[sig,fe,nbits]=wavread(filename);

% extraction des trames de signal :
[ech_nbr chanel] = size(sig);
if chanel == 2
   sig = (sig(:,1) + sig(:,2))/2;  % stéréo -> mono
end;
sig = sig';

% normalisation entre -1 et +1 :
sig = signorm(sig,1);

frame_nbr = fix((ech_nbr-framesize)/(framesize-offset));
lost_nbr = rem((ech_nbr-framesize), framesize-offset);

Trames = zeros(frame_nbr,framesize);
frame_num = 1;
for ech=1:offset:(frame_nbr-1)*offset+1; 
	Trames(frame_num,:) = sig(ech:ech+framesize-1);
	frame_num = frame_num + 1;
end;

% calcul puissance du bruit sur chaque trame :
Pnoisysig = sum((Trames.^2)');  		% P signal bruité
Pnoise = min(Pnoisysig);				% estim. P du bruit minimum
Pmax = max(Pnoisysig - Pnoise);         % P max du signal sans le bruit

Pseuil = Pnoise + seuil*Pmax;       % seuil de la puissance
%Pseuil = Pmax/20;

% Sélection des trames :
ind = find(Pnoisysig>Pseuil);	
%first = min(ind);							% 1ere trame supérieure au seuil
%last = max(ind);							% dernière trame > seuil

%Trames = Trames(first:last,:);      % première <= trames <= dernière
Trames = Trames(ind,:);				% seules les trames > seuil

% Retour des signaux d'origine et tronqué :
tab=[]; %tab contient les indices de trame de début et de fin de chaque mot placés
        %les uns en dessous des autres
tab=[tab;ind(1)];
for i=1:length(ind)-1
   if ind(i+1)-ind(i)>1
      tab=[tab;ind(i);ind(i+1)];
   end
end
ind;
tab=[tab;ind(length(ind))];

CutSignal=[];
for i=1:2:length(tab)-1
	indfirst = (tab(i)-1)*offset+1;
   indlast = (tab(i+1)-1)*offset+framesize;
   CutSignal=[CutSignal  sig(indfirst:indlast)];
end
Signal = sig;