function [Detect, Signal, WSignal] = speechdetect(filename, seuil, framesize, offset);
%
% SPEECHDETECT
%
% SYNTAXE :
%
% [Detect, Signal, WSignal] = SPEECHDETECT([filename [, seuil [, framesize [,offset]]]])
%
% Extrait des signaux de parole à partir du fichier de parole
% au format wav donné en argument avec élimination des zones de
% silence par seuillage.
%
% ARGUMENTS : [OPTIONNELS]
%
% filename 	: nom du fichier à ouvrir
% seuil     : seuil de détection du signal de parole exprimé en pourcent de la puissance 
%             maximale du signal (0 à 100%)
%             0%  : aucun signal détecté
%             100%: le signal dont la puissance est supérieure à la puissance estimée du bruit 
%                   est détecté
% framesize : longueur des trames de calcul de la puissance
% offset    : facteur d'entrelacement des trames de calcul de la puissance
%
% VALEURS DE RETOUR :
%
% Detect       : tableau des indices de début et de fin du signal détecté
% Signal 	   : le signal entier extrait du fichier
% WSignal      : puissance du signal initial estimée sur chaque trame de calcul
%
% VOIR AUSSI :
%
%  speechget, uispeechdetect
%
% COMPATIBILITE : 
%   >= matlab 5.1
%

% Bruno Gas - LISIF/PARC UPMC
% Création : 28 juillet 2001
% version : 1.0
% Derniere révision : 
 
if nargin==0
    filename = input('Nom complet du fichier .wav à ouvrir = ','s');
    seuil = input('seuil de détection (0->100% (100=détection maximale)) = ');
    framesize = input('dimension des trames de calcul de la puissance = ');
    offset = input('entrelacement des trames = ');
elseif nargin==1
    seuil = input('seuil de détection (0 à 100% (100=détection maximale)) = ');
    framesize = input('dimension des trames de calcul de la puissance = ');
    offset = input('entrelacement des trames = ');
elseif nargin==2
    framesize = input('dimension des trames de calcul de la puissance = ');
    offset = input('entrelacement des trames = ');
elseif nargin==3
    offset = input('entrelacement des trames = ');    
elseif nargin>4
    error('[SPEECHDETECT] usage : [Detect, DetectSignal, Signal, W] = SPEECHDETECT([filename [, seuil [, framesize [,offset]]]])');   
end;

if seuil<0 | seuil>100, error('[SPEECHDETECT] erreur : le <seuil> doit etre compris entre 0 et 100'); end;
if framesize<1, error('[SPEECHDETECT] erreur : la taille des trames de calcul doit être >= 1'); end;
if offset <1, error('[SPEECHDETECT] erreur : le facteur d''entrelacement doit être >= 1'); end;
if offset >framesize, error('[SPEECHDETECT] erreur : le facteur d''entrelacement doit être <= à framesize'); end;
 
[Signal,fe,nbits] = wavread(filename);

% extraction des trames de signal :
[ech_nbr chanel] = size(Signal);
if chanel == 2
   Signal = (Signal(:,1) + Signal(:,2))/2;  % stéréo -> mono
end;
Signal = Signal';

frame_nbr = fix((ech_nbr-framesize)/(framesize-offset));
lost_nbr = rem((ech_nbr-framesize), framesize-offset);

Trames = zeros(frame_nbr,framesize);
frame_num = 1;
for ech=1:offset:(frame_nbr-1)*offset+1; 
	Trames(frame_num,:) = Signal(ech:ech+framesize-1);
	frame_num = frame_num + 1;
end;

% calcul puissance du bruit sur chaque trame :
WSignal = sum((Trames.^2)');  		% P signal bruité
Pnoise = min(WSignal);			      % estim. P du bruit minimum
Pmax = max(WSignal - Pnoise);       % P max du signal sans le bruit

Pseuil = Pnoise + (100-seuil)*Pmax/100; % seuil de la puissance

% Sélection des trames :
ind = find(WSignal>Pseuil);	
first = min(ind);							% 1ere trame supérieure au seuil
last = max(ind);							% dernière trame > seuil

Trames = Trames(first:last,:);      % première <= trames <= dernière
%Trames = Trames(ind,:);				% seules les trames > seuil

% Retour des signaux d'origine et tronqué :
indfirst = (first-1)*offset+1;
indlast = (last-1)*offset+framesize;
Detect = [indfirst indlast];
if isempty(Detect)
   warning('[SPEECHDETECT] seuil trop faible : aucun signal détecté');
   Detect = [0 0];   
end;



