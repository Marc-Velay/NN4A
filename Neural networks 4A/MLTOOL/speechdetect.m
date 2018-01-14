function [Detect, Signal, WSignal] = speechdetect(filename, seuil, framesize, offset);
%
% SPEECHDETECT
%
% SYNTAXE :
%
% [Detect, Signal, WSignal] = SPEECHDETECT([filename [, seuil [, framesize [,offset]]]])
%
% Extrait des signaux de parole � partir du fichier de parole
% au format wav donn� en argument avec �limination des zones de
% silence par seuillage.
%
% ARGUMENTS : [OPTIONNELS]
%
% filename 	: nom du fichier � ouvrir
% seuil     : seuil de d�tection du signal de parole exprim� en pourcent de la puissance 
%             maximale du signal (0 � 100%)
%             0%  : aucun signal d�tect�
%             100%: le signal dont la puissance est sup�rieure � la puissance estim�e du bruit 
%                   est d�tect�
% framesize : longueur des trames de calcul de la puissance
% offset    : facteur d'entrelacement des trames de calcul de la puissance
%
% VALEURS DE RETOUR :
%
% Detect       : tableau des indices de d�but et de fin du signal d�tect�
% Signal 	   : le signal entier extrait du fichier
% WSignal      : puissance du signal initial estim�e sur chaque trame de calcul
%
% VOIR AUSSI :
%
%  speechget, uispeechdetect
%
% COMPATIBILITE : 
%   >= matlab 5.1
%

% Bruno Gas - LISIF/PARC UPMC
% Cr�ation : 28 juillet 2001
% version : 1.0
% Derniere r�vision : 
 
if nargin==0
    filename = input('Nom complet du fichier .wav � ouvrir = ','s');
    seuil = input('seuil de d�tection (0->100% (100=d�tection maximale)) = ');
    framesize = input('dimension des trames de calcul de la puissance = ');
    offset = input('entrelacement des trames = ');
elseif nargin==1
    seuil = input('seuil de d�tection (0 � 100% (100=d�tection maximale)) = ');
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
if framesize<1, error('[SPEECHDETECT] erreur : la taille des trames de calcul doit �tre >= 1'); end;
if offset <1, error('[SPEECHDETECT] erreur : le facteur d''entrelacement doit �tre >= 1'); end;
if offset >framesize, error('[SPEECHDETECT] erreur : le facteur d''entrelacement doit �tre <= � framesize'); end;
 
[Signal,fe,nbits] = wavread(filename);

% extraction des trames de signal :
[ech_nbr chanel] = size(Signal);
if chanel == 2
   Signal = (Signal(:,1) + Signal(:,2))/2;  % st�r�o -> mono
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
WSignal = sum((Trames.^2)');  		% P signal bruit�
Pnoise = min(WSignal);			      % estim. P du bruit minimum
Pmax = max(WSignal - Pnoise);       % P max du signal sans le bruit

Pseuil = Pnoise + (100-seuil)*Pmax/100; % seuil de la puissance

% S�lection des trames :
ind = find(WSignal>Pseuil);	
first = min(ind);							% 1ere trame sup�rieure au seuil
last = max(ind);							% derni�re trame > seuil

Trames = Trames(first:last,:);      % premi�re <= trames <= derni�re
%Trames = Trames(ind,:);				% seules les trames > seuil

% Retour des signaux d'origine et tronqu� :
indfirst = (first-1)*offset+1;
indlast = (last-1)*offset+framesize;
Detect = [indfirst indlast];
if isempty(Detect)
   warning('[SPEECHDETECT] seuil trop faible : aucun signal d�tect�');
   Detect = [0 0];   
end;



